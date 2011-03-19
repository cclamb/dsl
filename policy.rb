require './error_handling'

class Policy
  
  include ErrorHandling

  def initialize(&block)
    @ctx = :load
    @active_activity = nil
    @misc_key = 0
    @defined_activities = {}
    instance_eval(&block)
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

  private

  def process_block(tag, &block)
    raise_syntax_error if @ctx != :activity
    if tag == nil
      tag = @misc_key
      @misc_key = @misc_key + 1
    end
    @defined_activities[@active_activity][tag] = block
  end

end
