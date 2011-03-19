
require './policy'

describe 'Execute block' do
  it 'Should be able to submit a block to a new policy' do
    has_run = false
    policy = Policy.new { has_run = true }
    has_run.should == true 
  end
end

describe 'Execute block in context' do
  it 'Should be able to call class methods in context' do

    # We need to test with a global because of scoping constraints
    $has_run = false
    
    class NewPolicy < Policy
      def run
        $has_run = true
      end
    end
    
    policy = NewPolicy.new { run }
    $has_run.should == true
  end
end

describe 'activity' do
  it 'should handle empty restrictions' do
    policy = Policy.new do
      activity :a1
    end
  end
end
