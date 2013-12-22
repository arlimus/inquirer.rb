# encoding: utf-8
require 'minitest_helper'

describe Checkbox do
  before :each do
    IOHelper.output = ""
    IOHelper.keys = nil
  end

  it "doesn't render the dialog with 0 items" do
    Checkbox.ask "select", [], clear: false
    IOHelper.output.must_equal ""
  end

  it "renders the dialog with 3 items" do
    Checkbox.ask "select", ["one","two","three"], clear: false
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m⬡ one\n ⬡ two\n ⬡ three\n"
  end

  it "it finishes selection on pressing enter" do
    IOHelper.keys = "enter"
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [false,false,false]
  end

  it "selects and renders other items correctly (press down, press up, space, cycle)" do
    IOHelper.keys = ["down","space","enter"]
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [false,true,false]
    IOHelper.output.must_equal "select:\n ⬡ one\n\e[36m‣\e[0m\e[36m⬢\e[0m two\n ⬡ three\n"

    IOHelper.keys = ["space","down","space","enter"]
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [true,true,false]
    IOHelper.output.must_equal "select:\n \e[36m⬢\e[0m one\n\e[36m‣\e[0m\e[36m⬢\e[0m two\n ⬡ three\n"

    IOHelper.keys = ["space","down","space","down","space","enter"]
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [true,true,true]
    IOHelper.output.must_equal "select:\n \e[36m⬢\e[0m one\n \e[36m⬢\e[0m two\n\e[36m‣\e[0m\e[36m⬢\e[0m three\n"

    IOHelper.keys = ["down","down","down","space","enter"]
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [true,false,false]
    IOHelper.output.must_equal "select:\n\e[36m‣\e[0m\e[36m⬢\e[0m one\n ⬡ two\n ⬡ three\n"

    IOHelper.keys = ["up","space","enter"]
    Checkbox.ask( "select", ["one","two","three"], clear: false
      ).must_equal [false,false,true]
    IOHelper.output.must_equal "select:\n ⬡ one\n ⬡ two\n\e[36m‣\e[0m\e[36m⬢\e[0m three\n"
  end

end
