require './error_handling'

$defined_policies = {}

class Policy
  
  include ErrorHandling

  attr_accessor :artifact, :context

  def initialize(evaluator = nil, &block)
    @ctx = :load
    @active_activity = nil
    @misc_key = 0
    @defined_activities = {}
    instance_exec(&block)
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
        case v.arity
          when 0 ; instance_exec { v.call }
          when 1 ; instance_exec { v.call(artifact) }
          when 2 ; instance_exec { v.call(artifact, context) }
          else ; raise_syntax_error('incorrect constraint arity')
        end
      end
    end
  end

  def pass
  end
  
  def fail
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

def policy(tag = nil, evaluator = nil, &block)
  $defined_policies[tag] \
    = evaluator != nil ? Policy.new(evaluator, &block) \
    : Policy.new(&block)
end
