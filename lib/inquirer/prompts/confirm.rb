require 'term/ansicolor'

# Base rendering for confirm
module ConfirmRenderer
  def render heading = nil, value = nil, footer = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the list
    ( value.nil? ? "" : @value % value ) +
    # render the footer
    ( footer.nil? ? "" : @footer % footer )
  end
end

# Default formatting for confirm rendering
class ConfirmDefault
  include ConfirmRenderer
  C = Term::ANSIColor
  def initialize( style )
    @heading = "%s: (Y/n)"
    @value = "%s"
    @footer = "%s"
  end
end

class Confirm
  def initialize question = nil, renderer = nil
    @question = question
    @value = ""
    @prompt = ""
    @renderer = renderer || ConfirmDefault.new( Inquirer::Style::Default )
  end

  def update_prompt
    # call the renderer
    @prompt = @renderer.render(@question, @value)
  end

  # Run the list selection, wait for the user to select an item and return
  # the selected index
  # Params:
  # +clear+:: +Bool+ whether to clear the selection prompt once this is done
  #   defaults to true; set it to false if you want the prompt to remain after
  #   the user is done with selecting
  def run clear = true
    # render the
    IOHelper.render( update_prompt )
    # loop through user confirm
    # IOHelper.read_char
    IOHelper.read_key_while true do |key|
      raw  = IOHelper.char_to_raw(key)

      case raw
      when "y","Y"
        @value = true
        false
      when "n","N"
        @value = false
        false
      when "return"
        @value = true
        false
      end
      # raw != "return"
    end
    # clear the final prompt and the line
    IOHelper.clear if clear
    # return the value
    @value
  end

  def self.ask question = nil, opts = { clear: true }
    l = Confirm.new question, opts[:renderer]
    l.run opts[:clear]
  end

end
