require 'io/console'

module IOHelper
  extend self

  KEYS = {
    " " => "space",
    "\t" => "tab",
    "\r" => "return",
    "\n" => "linefeed",
    "\e" => "escape",
    "\e[A" => "up",
    "\e[B" => "down",
    "\e[C" => "right",
    "\e[D" => "left",
    "\177" => "backspace",
    # ctrl + c
    "\003" => "ctrl-c",
    # ctrl + d
    "\004" => "ctrl-d"
  }

  # Read a character the user enters on console. This call is synchronous blocking.
  # This is taken from: http://www.alecjacobson.com/weblog/?p=75
  def read_char
    begin
      # save previous state of stty
      old_state = `stty -g`
      # disable echoing and enable raw (not having to press enter)
      system "stty raw -echo"
      c = STDIN.getc.chr
      # gather next two characters of special keys
      if(c=="\e")
        extra_thread = Thread.new{
          c = c + STDIN.getc.chr
          c = c + STDIN.getc.chr
        }
        # wait just long enough for special keys to get swallowed
        extra_thread.join(0.00001)
        # kill thread so not-so-long special keys don't wait on getc
        extra_thread.kill
      end
    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace
    ensure
      # restore previous state of stty
      system "stty #{old_state}"
    end
    return c
  end

  # Read a keypress on console. Return the key name (e.g. "space", "a", "B")
  # Params:
  # +with_exit_codes+:: +Bool+ whether to throw Interrupts when the user presses
  #   ctrl-c and ctrl-d. (true by default)
  def read_key with_exit_codes = true
    raw = read_key_raw
    raise Interrupt if with_exit_codes and ( raw == "ctrl-c" or raw == "ctrl-d" )
    raw
  end

  # Get each key the user presses and hand it one by one to the block. Do this
  # as long as the block returns truthy
  # Params:
  # +&block+:: +Proc+ a block that receives a user key and returns truthy or falsy
  def read_key_while &block
    STDIN.noecho do
      # as long as the block doen't return falsy,
      # read the user input key and sned it to the block
      while block.( IOHelper.read_key )
      end
    end
  end

  private

  def read_key_raw
    c = read_char
    # try to get the key name from the character
    k = KEYS[c]
    # return either the character or key name
    ( k.nil? ) ? c : k
  end

end
