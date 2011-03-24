require './policy'
require './keywords'
require 'open-uri'

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

describe 'artifact' do

  before :all do
    $defined_activities = {}
  end

  it 'should create a new artifact and extract defined properties' do
    uri = URI.parse('http://www.unm.edu/zimmerman_library/218')
    artifact :a1 do
      define :foo => 'bar'
      define :uri => uri
    end

    artif = $defined_artifacts[:a1]

    artif.foo.should == 'bar'
    artif.uri.should == uri
    artif.bar.should == nil
  end
end

describe 'tuple' do

  before :all do
    $defined_policies = {}
    $defined_tuples = {}
    $defined_artifacts = {}
  end

  it 'should associate a defined policy with a defined artifact' do
    policy :p1
    artifact :a1
    tuple :t1, :a1, :p1
    $defined_tuples[:t1][0].instance_of?(Artifact).should == true
    $defined_tuples[:t1][1].instance_of?(Policy).should == true
  end

  it 'should assiciate anonymous policies and artifacts' do
    pending 'anon support not implemented'
    tuple :t1, (artifact :a1), (policy :p1)
    $defined_tuples[:t1][0].instance_of?(Artifact).should == true
    $defined_tuples[:t1][1].instance_of?(Policy).should == true
  end

  it 'should associate anonymous policies with defined artifacts' do
    pending 'anon support not implemented'
    artifact :a1
    tuple :t1, :a1, (policy :p1)
    $defined_tuples[:t1][0].instance_of?(Artifact).should == true
    $defined_tuples[:t1][1].instance_of?(Policy).should == true
  end

  it 'should associate defined policies with anonymous artifacts' do
    pending 'anon support not implemented'
    policy :p1
    tuple :t1, (artifact :a1), :p1
    $defined_tuples[:t1][0].instance_of?(Artifact).should == true
    $defined_tuples[:t1][1].instance_of?(Policy).should == true
  end

  it 'should handle non-trivial anonymous policies' do
    artifact :a1
    tuple :t1, :a1, (policy do
      activity :play do
        constraint :c1
      end
      activity :record do
        constraint :c1
        constraint :c2
      end
      activity :rewind
      activity :fast_forward do
        constraint :c1
        constraint :c2
        constraint :c3
      end
      activity :stop do
        constraint :c1
        constraint :c2
        constraint :c3
        constraint :c4
      end
      activity :pause do
        constraint :c1
        constraint :c2
        constraint :c3
        constraint :c4
        constraint :c5
      end
    end)
    $defined_tuples[:t1][0].instance_of?(Artifact).should == true
    $defined_tuples[:t1][1].instance_of?(Policy).should == true
    $defined_tuples[:t1][1].evaluate
  end

  it 'should handle non-trivial anonymous activities'

  it 'should handle non-trivial anonymous policies and anonymous activities'

end



