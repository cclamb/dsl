require './policy'
require './keywords'

describe 'policy' do
  before :all do
    $defined_policies = {}
  end

  it 'should define policies and add to collection' do
    is_c1_called = false
    policy :p1 do
      activity :play do
        constraint { is_c1_called = true }
      end
    end
    $defined_policies.should include(:p1)
    $defined_policies[:p1].class.to_s.should == 'Policy'
  end

  it 'should define policies with allocators' do
    is_c1_called = false
    policy :p2, :std_eval do
      activity :play do
        constraint { is_c1_called = true }
      end
    end
    $defined_policies.should include(:p2)
    $defined_policies[:p2].class.to_s.should == 'Policy'
  end

  it 'should define policies with inline allocators' do
    is_c1_called = false
    policy :p3, do
      evaluator :std_eval
      activity :play do
        constraint { is_c1_called = true }
      end
    end
    $defined_policies.should include(:p3)
    $defined_policies[:p3].class.to_s.should == 'Policy'
  end

end

describe 'tuple' do

  before :all do
    $defined_policies = {}
    $defined_tuples = {}
  end

  it 'should be tested'

end

describe 'artifact' do
  it 'should be tested'
end

