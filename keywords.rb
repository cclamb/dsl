require './policy'
require './artifact'
require './dsl_syntax_error'

$defined_policies = {}
$defined_tuples = {}
$defined_artifacts = {}

$anonymous_artfact_tag = 0
$anonymous_policy_tag = 0

def policy(tag = nil, evaluator = nil, &block)
  $defined_policies[tag] \
    = evaluator != nil ? Policy.new(evaluator, &block) \
    : Policy.new(&block)
end

def tuple(tuple_tag, artifact, policy)
  a = nil
  if artifact.instance_of?(Artifact)
    a = artifact
  else
    a = $defined_artifacts[artifact]
  end
  raise DslSyntaxError.new('artifact is not a symbol or an anon policy') if a == nil

  p = nil
  if policy.instance_of?(Policy)
    p = policy
  else
    p = $defined_policies[policy]
  end
  raise DslSyntaxError.new('policy is not a symbol or an anon policy') if p == nil

  $defined_tuples[tuple_tag] = [a, p]
end

def artifact(tag = nil, &block)
  $defined_artifacts[tag] = Artifact.new(&block)
end
