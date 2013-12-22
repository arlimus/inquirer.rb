require 'minitest_helper'
# overload all necessary methods of iohelper
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
  def read_key_while &block
    Array(@keys).each{|key| block.(key)}
  end
end

describe List do
  before :each do
    IOHelper.output = ""
    IOHelper.keys = nil
  end

  it "doesn't render the dialog with 0 items" do
    List.ask "select", [], clear: false
    IOHelper.output.must_equal ""
  end

  it "renders the dialog with 3 items" do
    List.ask "select", ["one","two","three"], clear: false
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m \e[36mone\e[0m\n  two\n  three\n"
  end

  it "it finishes selection on pressing enter" do
    IOHelper.keys = "enter"
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 0
  end

  it "selects other items correctly (press down, press up, cycle)" do
    IOHelper.keys = ["down","enter"]
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 1

    IOHelper.keys = ["down","down","enter"]
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 2

    IOHelper.keys = ["down","down","down","enter"]
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 0

    IOHelper.keys = ["down","up","enter"]
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 0

    IOHelper.keys = ["up","enter"]
    List.ask( "select", ["one","two","three"], clear: false
      ).must_equal 2
  end

end
