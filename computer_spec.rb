
$_computers = {}

def computer(name)
  $_computers[name] = 'computer'
  puts $_computers
  yield if block_given?
end
