require './error_handling'

class Policy
  
  include ErrorHandling

  attr_accessor :artifact

  def initialize(evaluator = nil, &block)
    @ctx = :load
    @active_activity = nil
    @misc_key = 0
    @defined_activities = {}
    instance_eval(&block)
    @active_activity = nil
    @ctx = :loaded
    @artifact = nil
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
        instance_eval { v.call }            if v.arity == 0
        instance_eval { v.call(artifact) }  if v.arity == 1
      end
    end
  end

  private

  def process_block(tag, &block)
    raise_syntax_error('ctx is' + @ctx.to_s) if @ctx != :activity
    if tag == nil
      tag = @misc_key
      @misc_key = @misc_key + 1
    end
    @defined_activities[@active_activity][tag] = block
  end

end
