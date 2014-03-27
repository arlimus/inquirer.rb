require_relative '../lib/inquirer'

value1 = Ask.confirm "Are you sure?"
value2 = Ask.confirm "Are you really sure?", default: false
puts "you chose #{value1} and #{value2}"
