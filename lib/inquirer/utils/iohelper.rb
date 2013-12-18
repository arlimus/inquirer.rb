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

  # http://www.alecjacobson.com/weblog/?p=75
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

  def read_key with_exit_codes = true
    raw = read_key_raw
    raise Interrupt if with_exit_codes and ( raw == "ctrl-c" or raw == "ctrl-d" )
    raw
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
