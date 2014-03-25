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

  it "should render the value besides the question in the prompt" do
    Input.ask("please type input", clear: false)
    IOHelper.output.must_equal "please type input: typed input"
  end

end
