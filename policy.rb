class Policy

  def initialize(&block)
    instance_eval(&block)
  end

  def constraint

  end

  def obligation

  end

end
