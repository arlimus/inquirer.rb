require_relative '../lib/inquirer'
idx = Ask.checkbox "Monkey see, monkey...", [
  "don't",
  "eats Banana",
  "do"
]
idx = Ask.checkbox "Monkey see, monkey...", [
  "don't",
  "eats Banana",
  "do"
]
puts "you selected #{idx}"
