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

end
