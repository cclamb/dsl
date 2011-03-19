module ErrorHandling
  def raise_syntax_error
    raise DslSyntaxError.new
  end
end