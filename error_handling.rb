require './dsl_syntax_error'

module ErrorHandling
  def raise_syntax_error(msg)
    raise DslSyntaxError.new(msg)
  end
end
