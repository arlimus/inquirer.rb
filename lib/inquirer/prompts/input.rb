require 'term/ansicolor'

# Base rendering for input
module InputRenderer
  def render heading = nil, value = nil, footer = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the list
    ( value.nil? ? "" : @value % value ) +
    # render the footer
    ( footer.nil? ? "" : @footer % footer )
  end
end

# Default formatting for list rendering
class InputDefault
  include InputRenderer
  C = Term::ANSIColor
  def initialize( style )
    @heading = "%s: "
    @value = "%s"
    @footer = "%s"
  end
end

class Input
  def initialize question = nil, renderer = nil
    @question = question
    @value = ""
    @prompt = ""
    @pos = 0
    @renderer = renderer || InputDefault.new( Inquirer::Style::Default )
  end

  def update_prompt
    # call the renderer
    @prompt = @renderer.render(@question, @value)
  end

  def update_cursor
    print IOHelper.char_left * @pos
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
    # loop through user input
    # IOHelper.read_char
    IOHelper.read_key_while true do |key|
      raw  = IOHelper.char_to_raw(key)

      case raw
      when "backspace"
        @value = @value.chop
        IOHelper.rerender( update_prompt )
        update_cursor
      when "left"
        @pos = [(@pos + 1), @value.length].min
        print IOHelper.char_left
      when "right"
        @pos = [(@pos - 1), 0].max
        print IOHelper.char_right
      when "return"
        # Ignore
      else
        @value = @value.insert(@value.length - @pos, key)
        IOHelper.rerender( update_prompt )
        update_cursor
      end
      raw != "return"
    end
    # clear the final prompt and the line
    IOHelper.clear if clear
    # return the value
    @value
  end

  def self.ask question = nil, opts = { clear: true }
    l = Input.new question, opts[:renderer]
    l.run opts[:clear]
  end

end
