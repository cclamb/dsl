require './policy.rb'

$defined_policies = {}
$defined_tuples = {}
$defined_artifacts = {}

def policy(tag = nil, evaluator = nil, &block)
  $defined_policies[tag] \
    = evaluator != nil ? Policy.new(evaluator, &block) \
    : Policy.new(&block)
end

def tuple(tuple_tag, artifact_tag, policy_tag = nil, &b)  
  policy = nil
  if block_given?
    $defined_policies[policy_tag] = policy if policy_tag != nil
    policy = Policy.new &b 
  elseif policy_tag != nil
    policy = $defined_policies[policy_tag]
  end
  $defined_tuples[:tuple_tag] = [artifact_tag, policy]
end
