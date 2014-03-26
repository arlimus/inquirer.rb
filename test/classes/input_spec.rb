# encoding: utf-8
require 'minitest_helper'

describe Input do
  before :each do
    IOHelper.output = ""
    IOHelper.keys = ['t','y','p','e','d',' ','i','n','p','u','t',"\r"]
  end

  it "should use chars value from the user" do
    Input.ask("please type input").must_equal "typed input"
  end

  it "accepts and renders response correctly" do
    Input.ask("please type input")
    IOHelper.output.must_equal "please type input: \e[36mtyped input\e[0m\n"
  end

  it "should return default value if given and there is no input" do
    IOHelper.keys = "\r"
    Confirm.ask("Are you sure?", default: "I'm default").must_equal "I'm default"
  end

end
