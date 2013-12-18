module ListRendererBase

  def render heading = nil, list = [], footer = nil
    ( heading.nil? ? "" : self::Heading % heading ) +
    list.map do |li|
      li["selected"] ?
        self::SelectedItem % li["value"] :
        self::Item % li["value"]
    end.join("") +
    ( footer.nil? ? "" : self::Footer % footer )
  end
end

module ListRendererSimple
  include ListRendererBase
  extend self
  Heading = "%s:\n"
  Footer = "%s\n"
  Item = "  %s\n"
  SelectedItem = "x %s\n"
end

class List
  def initialize elements, question = nil, renderer = ListRendererSimple
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