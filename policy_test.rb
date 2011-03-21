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

describe 'policy' do
  it 'should call blocks immediately' do
    is_called = false
    policy = Policy.new do
      is_called = true
    end
    is_called.should == true
  end
end

describe 'activity' do
  it 'should call blocks immediately' do
    is_called = false
    policy = Policy.new do
      activity :a1 do
        is_called = true
      end
    end
    is_called.should == true
  end
end

describe 'constraint' do
  it 'should have a deferred call' do

    is_called = false
    is_constraint_called = false
    is_obligation_called = false

    policy = Policy.new do
      activity :a1 do
        is_called = true
        constraint do
          is_constraint_called = true
        end
        obligation do
          is_obligation_called = true
        end
      end
    end

    is_called.should == true
    is_constraint_called.should == false
    is_obligation_called.should == false

    is_called = false
    policy.evaluate

    is_called.should == false
    is_constraint_called.should == true
    is_obligation_called.should == true
  end
end

describe 'constraint' do
  it 'deferred call test, short form' do

    is_called = false
    is_constraint_called = false
    is_obligation_called = false

    policy = Policy.new do
      activity :a1 do
        is_called = true
        constraint { is_constraint_called = true }
        obligation { is_obligation_called = true }
      end
    end

    is_called.should == true
    is_constraint_called.should == false
    is_obligation_called.should == false

    is_called = false
    policy.evaluate

    is_called.should == false
    is_constraint_called.should == true
    is_obligation_called.should == true
  end
end

describe 'constraint' do
  it 'should have a deferred call, tags' do

    is_called = false
    is_constraint_called = false
    is_obligation_called = false

    policy = Policy.new do
      activity :a1 do
        is_called = true
        constraint :c1 do
          is_constraint_called = true
        end
        obligation :o1 do
          is_obligation_called = true
        end
      end
    end

    is_called.should == true
    is_constraint_called.should == false
    is_obligation_called.should == false

    is_called = false
    policy.evaluate

    is_called.should == false
    is_constraint_called.should == true
    is_obligation_called.should == true
  end
end

describe 'artifact' do
  it 'should allow artifact testing inside of constraints' do
    is_called_1 = is_called_2 = is_called_3 = false
    policy = Policy.new do
      activity :a1 do
        constraint do
          artifact { |a| is_called_1 = true }
        end
        constraint do
          artifact { |a| is_called_2 = true }
        end
        constraint do
          artifact { |a| is_called_3 = true }
        end
      end
    end

    is_called_1.should == false
    is_called_2.should == false
    is_called_3.should == false
    is_error = false

    # we have no associated artifact so an exception should be raised.
    begin
      policy.evaluate
    rescue
      is_error = true
    end
  
    is_error.should == true
    is_called_1.should == false
    is_called_2.should == false
    is_called_3.should == false

    policy.assoc_artifact = 'artifact'
    policy.evaluate

    is_called_1.should == true
    is_called_2.should == true
    is_called_3.should == true

  end
end
