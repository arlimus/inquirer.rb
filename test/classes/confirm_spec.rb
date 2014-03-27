# encoding: utf-8
require 'minitest_helper'

describe Confirm do
  before :each do
    IOHelper.output = ""
  end

  it "should return true for y and Y and enter when default" do
    IOHelper.keys = "y"
    Confirm.ask("Are you sure?").must_equal true
    IOHelper.keys = "Y"
    Confirm.ask("Are you sure?").must_equal true
    IOHelper.keys = "\r"
    Confirm.ask("Are you sure?", default: true).must_equal true
  end

  it "should return false for n and N and enter when default" do
    IOHelper.keys = "n"
    Confirm.ask("Are you sure?").must_equal false
    IOHelper.keys = "N"
    Confirm.ask("Are you sure?").must_equal false
    IOHelper.keys = "\r"
    Confirm.ask("Are you sure?", default: false).must_equal false
  end

  it "should return true if not default given" do
    IOHelper.keys = "\r"
    Confirm.ask("Are you sure?").must_equal true
  end

  it "accepts and renders response correctly" do
    IOHelper.keys = "n"
    Confirm.ask("Are you sure?")
    IOHelper.output.must_equal "Are you sure?: \e[36mNo\e[0m\n"

    IOHelper.keys = "N"
    Confirm.ask("Are you sure?")
    IOHelper.output.must_equal "Are you sure?: \e[36mNo\e[0m\n"

    IOHelper.keys = "y"
    Confirm.ask("Are you sure?")
    IOHelper.output.must_equal "Are you sure?: \e[36mYes\e[0m\n"

    IOHelper.keys = "y"
    Confirm.ask("Are you sure?")
    IOHelper.output.must_equal "Are you sure?: \e[36mYes\e[0m\n"
  end

end
