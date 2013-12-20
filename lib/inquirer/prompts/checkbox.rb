require 'term/ansicolor'
require 'inquirer/prompts/list'

# Base rendering for simple lists
module CheckboxRendererBase
  def render heading = nil, list = [], footer = nil
    # render the heading
    ( heading.nil? ? "" : self::Heading % heading ) +
    # render the list
    list.map do |li|
      render_item li
    end.join("") +
    # render the footer
    ( footer.nil? ? "" : self::Footer % footer )
  end

  private

  def render_item x
    ( x["selected"] ? self::Selector : " " ) +
    ( x["active"] ? self::CheckboxOn : self::CheckboxOff ) +
    " " +
    ( x["active"] ? self::ActiveItem : self::Item ) % x["value"]
  end

end

# Simple formatting for list rendering
module CheckboxRendererSimple
  include CheckboxRendererBase
  include Term::ANSIColor
  extend self
  Heading = "%s:\n"
  Footer = "%s\n"
  Item = "%s\n"
  ActiveItem = cyan("%s") + "\n"
  Selector = cyan ">"
  CheckboxOn = cyan "[X]"
  CheckboxOff = "[ ]"
end

# Default formatting for list rendering
module CheckboxRenderer
  include CheckboxRendererSimple
  extend self
  Selector = cyan "‣"
  CheckboxOn = cyan "⬢"
  CheckboxOff = "⬡"
end

class Checkbox
  def initialize question = nil, elements = [], renderer = CheckboxRenderer
    @elements = elements
    @question = question
    @pos = 0
    @active = elements.map{|i| false}
    @prompt = ""
    @renderer = renderer
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

  def self.ask *args
    l = Checkbox.new *args
    l.run
  end

end
