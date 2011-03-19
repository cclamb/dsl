require './dsl_syntax_error'

describe 'message' do
  it 'should allow a message set through the ctor to be accessed' do
    err = DslSyntaxError.new('foo')
    err.message.should == 'foo'
  end
end
