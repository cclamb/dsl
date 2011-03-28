class AndEvaluator

  def initialize(artifact = nil, context = nil)
    @artifact = artifact
    @context = context
  end

  def call(h = {})

    is_acceptable = true
    h.each_value do |v|

        case v.arity < 0 ? ~v.arity : v.arity
          when 0 ; instance_exec { is_acceptable = v.call }
          when 1 ; instance_exec { is_acceptable = v.call(@artifact) }
          when 2 ; instance_exec { is_acceptable = v.call(@artifact, @context) }
          else ; raise_syntax_error('incorrect constraint arity')
        end unless v == nil

        return is_acceptable if is_acceptable == false

    end

    return is_acceptable

    #h.each_value { |v| return false if v.call == false }
    #true
  end

end