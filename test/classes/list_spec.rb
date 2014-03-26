# encoding: utf-8
require 'minitest_helper'

describe List do
  before :each do
    IOHelper.output = ""
    IOHelper.keys = nil
  end

  it "finishes rendering with a clear" do
    List.ask "select", ["one","two","three"], response: false
    IOHelper.output.must_equal ""
  end

  it "doesn't render the dialog with 0 items" do
    List.ask "select", [], clear: false, response: false
    IOHelper.output.must_equal ""
  end

  it "renders the dialog with 3 items" do
    List.ask "select", ["one","two","three"], clear: false, response: false
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m \e[36mone\e[0m\n  two\n  three\n"
  end

  it "it finishes selection on pressing enter" do
    IOHelper.keys = "enter"
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 0
  end

  it "selects and renders other items correctly (press down, press up, cycle)" do
    IOHelper.keys = ["down","enter"]
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 1
    IOHelper.output.must_equal "select:\n  one\n\e[36m‣\e[0m \e[36mtwo\e[0m\n  three\n"

    IOHelper.keys = ["down","down","enter"]
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 2
    IOHelper.output.must_equal "select:\n  one\n  two\n\e[36m‣\e[0m \e[36mthree\e[0m\n"

    IOHelper.keys = ["down","down","down","enter"]
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 0
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m \e[36mone\e[0m\n  two\n  three\n"

    IOHelper.keys = ["down","up","enter"]
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 0
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m \e[36mone\e[0m\n  two\n  three\n"

    IOHelper.keys = ["up","enter"]
    List.ask( "select", ["one","two","three"], clear: false, response: false
      ).must_equal 2
    IOHelper.output.must_equal "select:\n  one\n  two\n\e[36m‣\e[0m \e[36mthree\e[0m\n"
  end

  it "selects and renders response correctly" do
    IOHelper.keys = ["down","enter"]
    List.ask( "select", ["one","two","three"])
    IOHelper.output.must_equal "select: \e[36mtwo\e[0m\n"

    IOHelper.keys = ["down","down","enter"]
    List.ask( "select", ["one","two","three"])
    IOHelper.output.must_equal "select: \e[36mthree\e[0m\n"
  end

end
