require 'minitest/autorun'
require 'inquirer'

begin
  require 'turn'
  Turn.config do |c|
   # use one of output formats:
   # :outline  - turn's original case/test outline mode [default]
   # :progress - indicates progress with progress bar
   # :dotted   - test/unit's traditional dot-progress mode
   # :pretty   - new pretty reporter
   # :marshal  - dump output as YAML (normal run mode only)
   # :cue      - interactive testing
   c.format  = :pretty
   # turn on invoke/execute tracing, enable full backtrace
   # c.trace   = true
   # use humanized test names (works only with :outline format)
   c.natural = true
  end
rescue LoadError
end

# overload all necessary methods of iohelper
# this will serve as a mock helper to read input and output
module IOHelper
  extend self
  attr_accessor :output, :keys
  def render sth
    @output += sth
  end
  def clear
    @output = ""
  end
  def rerender sth
    @output = sth
  end
  def read_key_while return_char = false, &block
    Array(@keys).each do |key|
      break unless block.(key)
    end
  end
end
