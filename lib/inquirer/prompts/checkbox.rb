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

class Checkbox
  def initialize question = nil, elements = [], renderer = nil
    @elements = elements
    @question = question
    @pos = 0
    @active = elements.map{|i| false}
    @prompt = ""
    @renderer = renderer || CheckboxDefault.new( Inquirer::Style::Default )
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

  # Run the list selection, wait for the user to select an item and return
  # the selected index
  # Params:
  # +clear+:: +Bool+ whether to clear the selection prompt once this is done
  #   defaults to true; set it to false if you want the prompt to remain after
  #   the user is done with selecting
  def run clear = true
    # finish if there's nothing to do
    return @active if Array(@elements).empty?
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
    # clear the final prompt and the line
    IOHelper.clear if clear
    # return the index of the selected item
    @active
  end

  def self.ask question = nil, elements = [], opts = { clear: true }
    l = Checkbox.new question, elements, opts[:renderer]
    l.run opts[:clear]
  end

end
