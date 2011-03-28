require './dsl_syntax_error'
require './and_evaluator'
require './or_evaluator'

class Policy

  attr_accessor :artifact, :context

  def initialize(evaluator = nil, &block)
    @ctx = :load
    @active_activity = nil
    @misc_key = 0
    @defined_activities = {}
    instance_exec(&block) if block_given?
    @active_activity = nil
    @ctx = :loaded
    @artifact = nil
    @context = nil
    @evaluator = create_evaluator(evaluator)
  end

  def evaluator(evaluator_type)
    @ctx = :evaluator
    @evaluator = create_evaluator(evaluator_type)
    @ctx = :load
  end
  
  def activity(tag)
    @ctx = :activity
    @active_activity = tag
    @defined_activities[tag] = {}
    yield if block_given?
    @ctx = :load
  end

  def constraint(tag = nil, &block)
    process_block(tag, &block)
  end

  def obligation(tag = nil, &block)
    process_block(tag, &block)
  end

  def evaluate
    @evaluator.artifact = artifact
    @evaluator.context = context
    @defined_activities.each do |k,v|
      @evaluator.call(v)
    end
  end

  def pass
    true
  end
  
  def fail
    false
  end

  private

  def process_block(tag, &block)
    raise DslSyntaxError.new('ctx is' + @ctx.to_s) if @ctx != :activity
    if tag == nil
      tag = @misc_key
      @misc_key = @misc_key + 1
    end
    @defined_activities[@active_activity][tag] = block
  end

  def create_evaluator(symbol = :std_eval)
    symbol = symbol == nil ? :std_eval : symbol
    case symbol
      when :std_eval ; AndEvaluator.new(@artifact, @context)
      when :or_eval  ; OrEvaluator.new(@artifact, @context)
      else ; raise DslSyntaxError.new('custom evals currently unimplemented')
    end
  end

end
