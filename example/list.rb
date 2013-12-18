require_relative '../lib/inquirer'
idx = List.ask "Look behind you...", [
  "a three-headed monkey!",
  "a pink pony",
  "Godzilla"
]
puts "you selected #{idx}"