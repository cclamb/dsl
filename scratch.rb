
$h={:c1=>lambda{true}, :c2=>lambda{false}}

class Ander
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

class Orer
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
