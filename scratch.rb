
$h={:c1=>lambda{true}, :c2=>lambda{false}}

class AndEvaluator
  def call(h)
    f = false
    h.each_value do |v|
      f = v.call
      puts f
      break if f == false
    end
    f
  end
end

class OrEvaluator
  def call(h)
    f = false
    h.each_value do |v|
      f = v.call
      puts f
      break if f == true
    end
    f
  end
end
