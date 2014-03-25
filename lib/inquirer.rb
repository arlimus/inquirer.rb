require 'inquirer/version'
require 'inquirer/utils/iohelper'
require 'inquirer/prompts/list'
require 'inquirer/prompts/checkbox'
require 'inquirer/prompts/input'

module Ask
  extend self
  # implement prompts
  def list *args
    List.ask *args
  end
  def checkbox *args
    Checkbox.ask *args
  end
  def input *args
    Input.ask *args
  end
end
