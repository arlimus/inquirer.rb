require 'term/ansicolor'

# Base rendering for simple lists
module ListRenderer
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
    ( x["selected"] ? @selector : " " ) + " " +
    ( x["selected"] ? @selected_item : @item ) % x["value"]
  end
end

# Default formatting for list rendering
class ListDefault
  include ListRenderer
  C = Term::ANSIColor
  def initialize( style )
    @heading = "%s:\n"
    @footer = "%s\n"
    @item = "%s\n"
    @selected_item = C.cyan("%s") + "\n"
    @selector = C.cyan style.selector
  end
end

# Default formatting for response
class ListResponseDefault
  include ListRenderer
  C = Term::ANSIColor
  def initialize( style = nil )
    @heading = "%s: "
    @response = C.cyan("%s") + "\n"
  end
end

class List
  def initialize question = nil, elements = [], renderer = nil, responseRenderer = nil
    @elements = elements
    @question = question
    @pos = 0
    @prompt = ""
    @renderer = renderer = ListDefault.new( Inquirer::Style::Default )
    @responseRenderer = responseRenderer = ListResponseDefault.new()
  end

  def update_prompt
    # transform the list into
    # {"value"=>..., "selected"=> true|false}
    e = @elements.
      # attach the array position
      map.with_index(0).
      map do |c,pos|
        { "value"=>c, "selected" => pos == @pos }
      end
    # call the renderer
    @prompt = @renderer.render(@question, e)
  end

  def update_response
    @prompt = @responseRenderer.renderResponse(@question, @elements[@pos])
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
    return nil if Array(@elements).empty?

    # hides the cursor while prompting
    IOHelper.without_cursor do
      # render the
      IOHelper.render( update_prompt )
      # loop through user input
      IOHelper.read_key_while do |key|
        @pos = (@pos - 1) % @elements.length if key == "up"
        @pos = (@pos + 1) % @elements.length if key == "down"
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
    @pos
  end

  def self.ask question = nil, elements = [], opts = {}
    l = List.new question, elements, opts[:renderer], opts[:rendererResponse]
    l.run opts.fetch(:clear, true), opts.fetch(:response, true)
  end

end
