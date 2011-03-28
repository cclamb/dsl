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
  end

  def evaluator(evaluator_type)
    @ctx = :evaluator
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
    @defined_activities.each do |k,v|
      v.each do |k,v|
        case v.arity < 0 ? ~v.arity : v.arity
          when 0 ; instance_exec { v.call }
          when 1 ; instance_exec { v.call(artifact) }
          when 2 ; instance_exec { v.call(artifact, context) }
          else ; raise DslSyntaxError.new('incorrect constraint arity')
        end unless v == nil
      end
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

  def select_stock_evaluator(symbol)
    case symbol
      when :std_eval; AndEvaluator.new
    end
  end

end
