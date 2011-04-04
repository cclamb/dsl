#
# Activities must be able to support:
# is_activity a1
# is_activity a1, a2
# is_activity a1, a2, preds
# etc.
#
def is_activity(*args)
  arguments = parse(args)
  arguments
end

def constrain_by(*args)
  constraints = Constraints.new
  args.each do |e|
    if e.kind_of? Proc
      constraints << e
    else
      raise ArgumentError.new("Incorrect type to constrain_by: #{e.to_s}")
    end
  end
  constraints
end

def obligate_with(*args)
  obligations = Obligations.new
  args.each do |e|
    if e.kind_of? Proc
      obligations << e
    else
      raise ArgumentError.new("Incorrect type to constrain_by: #{e.to_s}")
    end
  end
  obligations
end

# We need these to differentiate collections of obligations & constraints?
class Obligations < Array; end
class Constraints < Array; end

# Helper functions to parse the arg lists
# parse(*a): Array -> Hash
# TODO: Really should remove dups in returned lists
def parse(*a)
  h = { :obligations => [], :constraints => [], :restricted_activities => []}
  a.each do |e|
    if e.kind_of? Obligations
      h[:obligations] = h[:obligations] + e
    elsif e.kind_of? Constraints
      h[:constraints] = h[:constraints] + e
    elsif e.kind_of? Proc
      h[:restricted_activities] << e
    else
      raise ArgumentError.new("Incorrect type to parse: #{e.to_s}")
    end
  end
  h
end
