# encoding: utf-8
module Inquirer::Style
  Style = Struct.new(:selector, :checkbox_on, :checkbox_off)
  extend self

  Simple = Style.new(
    ">",
    "[x]",
    "[ ]"
  )

  Default = Style.new(
    "‣",
    "⬢",
    "⬡"
  )
end
