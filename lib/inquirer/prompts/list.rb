# Base rendering for simple lists
module ListRendererBase
  def render heading = nil, list = [], footer = nil
    # render the heading
    ( heading.nil? ? "" : self::Heading % heading ) +
    # render the list
    list.map do |li|
      li["selected"] ? selected(li["value"]) : unselected(li["value"])
    end.join("") +
    # render the footer
    ( footer.nil? ? "" : self::Footer % footer )
  end

  private

  def selected x
    self::Selector + " " + self::SelectedItem % x
  end

  def unselected x
    "  " + self::Item % x
  end
end

# Simple formatting for list rendering
module ListRendererSimple
  include ListRendererBase
  extend self
  Heading = "%s:\n"
  Footer = "%s\n"
  Item = "%s\n"
  SelectedItem = "%s\n"
  Selector = ">"
end

# Default formatting for list rendering
module ListRenderer
  include ListRendererSimple
  extend self
  Selector = "‣"
end

class List
  def initialize elements, question = nil, renderer = ListRenderer
    @elements = elements
    @question = question
    @pos = 0
    @prompt = ""
    @renderer = renderer
  end

  def render
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
    puts @prompt
  end

  def clear
    puts "\r" + ( "\e[A" * ( @prompt.scan(/\n/).length + 1 ))
  end

  def run
    require 'io/console'
    done = false
    $stdin.noecho do
      while not done
        render
        key = IOHelper.read_key
        @pos = (@pos - 1) % @elements.length if key == "up"
        @pos = (@pos + 1) % @elements.length if key == "down"
        done = true if key == "return"
        exit 1 if key == "ctrl-c" or key == "ctrl-d"
        clear
      end
    end
  end

end