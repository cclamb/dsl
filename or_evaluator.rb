class OrEvaluator

  def initialize(artifact = nil, context = nil)
    @artifact = artifact
    @context = context
  end

  def call(h = {})

    is_acceptable = false
    h.each_value do |v|

        case v.arity < 0 ? ~v.arity : v.arity
          when 0 ; instance_exec { is_acceptable = v.call }
          when 1 ; instance_exec { is_acceptable = v.call(@artifact) }
          when 2 ; instance_exec { is_acceptable = v.call(@artifact, @context) }
          else ; raise DslSyntaxError.new('incorrect constraint arity')
        end unless v == nil

        return is_acceptable if is_acceptable == true

    end

    return is_acceptable

  end

end
