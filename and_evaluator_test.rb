require './and_evaluator'

describe 'call' do

  it 'should handle no predicates as a true' do
    a = AndEvaluator.new
    a.call({}).should == true
  end

  it 'should handle no argument as true' do
    a = AndEvaluator.new
    a.call.should == true
  end

  it 'should return the conjunction of predicates' do
    a = AndEvaluator.new
    a.call({:a => ->{true}, :b => ->{true}, :c => ->{false}}).should == false
    a.call({:a => ->{true}, :b => ->{false}, :c => ->{false}}).should == false
    a.call({:a => ->{false}, :b => ->{true}, :c => ->{false}}).should == false
    a.call({:a => ->{true}, :b => ->{false}, :c => ->{true}}).should == false
    a.call({:a => ->{true}, :b => ->{true}, :c => ->{true}}).should == true
  end

  it 'should handle lambas of arity 1' do
    a = AndEvaluator.new('artfact')
    a.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){false}, :b => ->(x){true}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){true}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){true}}).should == true
  end

  it 'should handle lambas of arity 1 with nil artifact set' do
    a = AndEvaluator.new
    a.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){false}, :b => ->(x){true}, :c => ->(x){false}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){true}}).should == false
    a.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){true}}).should == true
  end

  it 'should handle lambas of arity 2' do
    a = AndEvaluator.new('artfact', 'context')
    a.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){false}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){true}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){true}}).should == true
  end

  it 'should handle lambas of arity 2 with nil artifact set' do
    a = AndEvaluator.new
    a.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){false}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){true}}).should == false
    a.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){true}}).should == true
  end

  it 'should fail on lambdas of arity > 2' do
    a = AndEvaluator.new
    did_fail = false
    begin
      a.call({:a => ->(x,y,z){false}})
    rescue
      did_fail = true
    end
    did_fail.should == true
  end

end
