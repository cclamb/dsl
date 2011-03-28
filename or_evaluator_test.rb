require './or_evaluator'

describe 'call' do

  it 'should return false with empty hash' do
    o = OrEvaluator.new
    o.call({}).should == false
  end

  it 'should return false for no arg submitted' do
    o = OrEvaluator.new
    o.call.should == false
  end

  it 'should return the disjunction of a hash of lambdas' do
    o = OrEvaluator.new
    o.call({:a => ->{true}, :b => ->{true}, :c => ->{false}}).should == true
    o.call({:a => ->{true}, :b => ->{false}, :c => ->{false}}).should == true
    o.call({:a => ->{false}, :b => ->{true}, :c => ->{false}}).should == true
    o.call({:a => ->{true}, :b => ->{false}, :c => ->{true}}).should == true
    o.call({:a => ->{true}, :b => ->{true}, :c => ->{true}}).should == true
    o.call({:a => ->{false}, :b => ->{false}, :c => ->{false}}).should == false
  end

  it 'should handle lambas of arity 1' do
    o = OrEvaluator.new('artfact')
    o.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){false}, :b => ->(x){true}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){true}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){true}}).should == true
    o.call({:a => ->(x){false}, :b => ->(x){false}, :c => ->(x){false}}).should == false
  end

  it 'should handle lambas of arity 1 with nil artifact set' do
    o = OrEvaluator.new
    o.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){false}, :b => ->(x){true}, :c => ->(x){false}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){false}, :c => ->(x){true}}).should == true
    o.call({:a => ->(x){true}, :b => ->(x){true}, :c => ->(x){true}}).should == true
    o.call({:a => ->(x){false}, :b => ->(x){false}, :c => ->(x){false}}).should == false
  end

  it 'should handle lambas of arity 2' do
    o = OrEvaluator.new('artfact', 'context')
    o.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){false}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){true}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){true}}).should == true
    o.call({:a => ->(x,y){false}, \
      :b => ->(x,y){false}, \
      :c => ->(x,y){false}}).should == false
  end

  it 'should handle lambas of arity 2 with nil artifact set' do
    o = OrEvaluator.new
    o.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){false}, :b => ->(x,y){true}, :c => ->(x,y){false}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){false}, :c => ->(x,y){true}}).should == true
    o.call({:a => ->(x,y){true}, :b => ->(x,y){true}, :c => ->(x,y){true}}).should == true
    o.call({:a => ->(x,y){false}, \
      :b => ->(x,y){false}, \
      :c => ->(x,y){false}}).should == false
  end

  it 'should fail on lambdas of arity > 2' do
    o = OrEvaluator.new
    did_fail = false
    begin
      o.call({:a => ->(x,y,z){false}})
    rescue
      did_fail = true
    end
    did_fail.should == true
  end

end
