require_relative '../lib/inquirer'

value = Ask.confirm "Are you sure?"
puts "you chose #{value}"
