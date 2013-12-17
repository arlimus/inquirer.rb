class List
  
  def initialize elements
    @elements = elements
    @pos = 0
    @prompt = ""
  end

  def render
    items = @elements.map{|e| "  "+e}
    items[@pos][0] = ">"

    @prompt = (
      ["Please choose:"] + 
      items  
      ).join("\n")

    puts @prompt
  end

  def clear
    puts "\r" + ( "\e[A" * ( @prompt.scan(/\n/).length + 2 ))
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