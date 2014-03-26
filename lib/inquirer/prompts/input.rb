require 'term/ansicolor'

# Base rendering for input
module InputRenderer
  def render heading = nil, value = nil, default = nil, footer = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the defaults
    ( default.nil? ? "" : @default % default ) +
    # render the list
    ( value.nil? ? "" : @value % value ) +
    # render the footer
    ( footer.nil? ? "" : @footer % footer )
  end

  def renderResponse heading = nil, response = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the footer
    ( response.nil? ? "" : @response % response )
  end
end

# Default formatting for list rendering
class InputDefault
  include InputRenderer
  C = Term::ANSIColor
  def initialize( style )
    @heading = "%s: "
    @default = "(%s) "
    @value = "%s"
    @footer = "%s"
  end
end

# Default formatting for response
class InputResponseDefault
  include InputRenderer
  C = Term::ANSIColor
  def initialize( style = nil )
    @heading = "%s: "
    @response = C.cyan("%s") + "\n"
  end
end

class Input
  def initialize question = nil, default = nil, renderer = nil, responseRenderer = nil
    @question = question
    @value = ""
    @default = default
    @prompt = ""
    @pos = 0
    @renderer = renderer || InputDefault.new( Inquirer::Style::Default )
    @responseRenderer = responseRenderer = InputResponseDefault.new()
  end

  def update_prompt
    # call the renderer
    @prompt = @renderer.render(@question, @value, @default)
  end

  def update_response
    @prompt = @responseRenderer.renderResponse(@question, @value)
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
  # +response+:: +Bool+ whether show the rendered response when this is done
  #   defaults to true; set it to false if you want the prompt to remain after
  #   the user is done with selecting
  def run clear, response
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
        if @pos < @value.length
          @pos = @pos + 1
          print IOHelper.char_left
        end
      when "right"
        if @pos > 0
          @pos = @pos - 1
          print IOHelper.char_right
        end
      when "return"
        if not @default.nil? and @value == ""
          @value = @default
        end
      else
        unless ["up", "down"].include?(raw)
          @value = @value.insert(@value.length - @pos, key)
          IOHelper.rerender( update_prompt )
          update_cursor
        end
      end
      raw != "return"
    end
    # clear the final prompt and the line
    IOHelper.clear if clear

    # show the answer
    IOHelper.render( update_response ) if response

    # return the value
    @value
  end

  def self.ask question = nil, opts = {}
    l = Input.new question, opts[:default], opts[:renderer], opts[:rendererResponse]
    l.run opts.fetch(:clear, true), opts.fetch(:response, true)
  end

end
