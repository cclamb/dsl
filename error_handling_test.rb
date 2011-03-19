
require './error_handling'

class TestClass; include ErrorHandling; end

describe "raise_syntax_error" do
  it "should raise an exception when called" do
    clz = TestClass.new
    has_caught_error = false
    begin
      TestClass.raise_syntax_exception
    rescue
     has_caught_error = true
    end
    has_caught_error.should == true
  end
end