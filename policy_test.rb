
require 'policy'

describe "Execute block" do
  it "Should be able to submit a block to a new policy" do
    has_run = false
    policy = Policy.new { has_run = true }
    has_run.should == true 
  end
end

describe "Execute block in context" do
  it "Should be able to call class methods in context" do
    policy = Policy.new do
      
    end
  end
end
