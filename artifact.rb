class Artifact
  def initialize(&block)
    @attributes = {}
    instance_exec(&block)
  end

  def define(h)
    @attributes = @attributes.merge(h)
  end
end
