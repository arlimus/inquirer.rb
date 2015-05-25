require 'term/ansicolor'
require 'inquirer/style'

# Base rendering for simple lists
module CheckboxRenderer
  def render heading = nil, list = [], footer = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the list
    list.map do |li|
      render_item li
    end.join("") +
    # render the footer
    ( footer.nil? ? "" : @footer % footer )
  end

  def renderResponse heading = nil, response = nil
    # render the heading
    ( heading.nil? ? "" : @heading % heading ) +
    # render the footer
    ( response.nil? ? "" : @response % response )
  end

  private

  def render_item x
    ( x["selected"] ? @selector : " " ) +
    ( x["active"] ? @checkbox_on : @checkbox_off ) +
    " " +
    ( x["active"] ? @active_item : @item ) % x["value"]
  end

end

# Formatting for rendering
class CheckboxDefault
  include CheckboxRenderer
  C = Term::ANSIColor
  def initialize( style )
    @heading      = "%s:\n"
    @footer       = "%s\n"
    @item         = "%s\n"
    @active_item  = "%s" + "\n"
    @selector     = C.cyan style.selector
    @checkbox_on  = C.cyan style.checkbox_on
    @checkbox_off = style.checkbox_off
  end
end

# Default formatting for response
class CheckboxResponseDefault
  include CheckboxRenderer
  C = Term::ANSIColor
  def initialize( style = nil )
    @heading = "%s: "
    @response = C.cyan("%s") + "\n"
  end
end

class Checkbox
  def initialize question = nil, elements = [], default = nil, renderer = nil, responseRenderer = nil
    @elements = elements
    @question = question
    @pos = 0
    @active = default || elements.map{|i| false}
    @prompt = ""
    @renderer = renderer || CheckboxDefault.new( Inquirer::Style::Default )
    @responseRenderer = responseRenderer = CheckboxResponseDefault.new()
  end

  def update_prompt
    # transform the list into
    # {"value"=>..., "selected"=> true|false, "active"=> true|false }
    e = @elements.
      # attach the array position
      map.with_index(0).
      map do |c,pos|
        { "value"=>c, "selected" => pos == @pos, "active" => @active[pos] }
      end
    # call the renderer
    @prompt = @renderer.render(@question, e)
  end

   def update_response
    e = @elements
      .map.with_index(0)
      .select {|f, pos| @active[pos] }
      .map {|f, pos| f }
    @prompt = @responseRenderer.renderResponse(@question, e.join(", "))
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
    # finish if there's nothing to do
    return @active if Array(@elements).empty?

    # hides the cursor while prompting
    IOHelper.without_cursor do
      # render the
      IOHelper.render( update_prompt )
      # loop through user input
      IOHelper.read_key_while do |key|
        @pos = (@pos - 1) % @elements.length if key == "up"
        @pos = (@pos + 1) % @elements.length if key == "down"
        @active[@pos] = !@active[@pos] if key == "space"
        IOHelper.rerender( update_prompt )
        # we are done if the user hits return
        key != "return"
      end
    end

    # clear the final prompt and the line
    IOHelper.clear if clear

    # show the answer
    IOHelper.render( update_response ) if response

    # return the index of the selected item
    @active
  end

  def self.ask question = nil, elements = [], opts = {}
    l = Checkbox.new question, elements, opts[:default], opts[:renderer], opts[:rendererResponse]
    l.run opts.fetch(:clear, true), opts.fetch(:response, true)
  end

end
