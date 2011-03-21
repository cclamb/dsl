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

describe 'constraint' do
  it 'should be able to pass aritfact optionally' do

    is_called = false
    is_constraint_called = false
    is_obligation_called = false

    c1_artifact = nil
    o1_artifact = nil

    policy = Policy.new do
      activity :a1 do
        is_called = true
        constraint :c1 do |a|
          is_constraint_called = true
          c1_artifact = a
        end
        obligation :o1 do |a|
          is_obligation_called = true
          o1_artifact = a
        end
      end
    end
    
    artifact = 'foo'
    policy.artifact = artifact

    is_called.should == true
    is_constraint_called.should == false
    is_obligation_called.should == false
    c1_artifact.should == nil
    o1_artifact.should == nil

    is_called = false
    policy.evaluate

    is_called.should == false
    is_constraint_called.should == true
    is_obligation_called.should == true
    c1_artifact.should == artifact
    o1_artifact.should == artifact
  end
end

describe 'constraint' do
  it 'should fail with incorrect constraint arity' do
    policy = Policy.new do
      activity :a1 do
        constraint { |x, y, z| return }
      end
    end
    
    is_err = false
    begin
      policy.evaluate
    rescue
      is_err = true
    end
    
    is_err.should == true
  end
end

describe 'constraint' do
  it 'should allow up to arity two' do
    
    is_c0_called = is_c1_called = is_c2_called = false
    c1_artifact = c2_artifact = nil
    c2_context = nil
    
    policy = Policy.new do
      activity :a1 do
        constraint { is_c0_called = true }
        constraint do |artifact| 
          is_c1_called = true
          c1_artifact = artifact
        end
        constraint do |artifact, context|
          is_c2_called = true
          c2_artifact = artifact
          c2_context = context
        end
      end
    end
    
    artifact = 'foo'
    context = 'bar'
    
    is_c0_called.should == false
    is_c1_called.should == false
    is_c2_called.should == false
    c1_artifact.should == nil
    c2_artifact.should == nil
    c2_context.should == nil
    
    policy.artifact = artifact
    policy.context = context
    policy.evaluate
    
    is_c0_called.should == true
    is_c1_called.should == true
    is_c2_called.should == true
    c1_artifact.should == artifact
    c2_artifact.should == artifact
    c2_context.should == context
    
  end
end
