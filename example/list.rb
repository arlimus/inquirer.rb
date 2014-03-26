require_relative '../lib/inquirer'
idx = Ask.list "Look behind you...", [
  "a three-headed monkey!",
  "a pink pony",
  "Godzilla"
]
idx = Ask.list "Look behind you...", [
  "a three-headed monkey!",
  "a pink pony",
  "Godzilla"
]
puts "you selected #{idx}"
