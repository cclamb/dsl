


class Policy
  
  include ErrorHandling

  def initialize(&block)
    @ctx = :load;
    instance_eval(&block)
  end
  
  def activity(tag = nil, &block)
    @ctx = :activity
  end

  def constraint(tag = nil, &block)
    raise_syntax_error if @ctx != :activity
    
  end

  def obligation(tag = nil, &block)
    raise_syntax_error if @ctx != :activity
  end

end
