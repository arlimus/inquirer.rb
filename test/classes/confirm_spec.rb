# encoding: utf-8
require 'minitest_helper'

describe Confirm do
  before :each do
    IOHelper.output = ""
  end

  it "should return true for y and Y" do
    IOHelper.keys = "y"
    Confirm.ask("Are you sure?").must_equal true
    IOHelper.keys = "Y"
    Confirm.ask("Are you sure?").must_equal true
  end

  it "should return false for n and N" do
    IOHelper.keys = "n"
    Confirm.ask("Are you sure?").must_equal false
    IOHelper.keys = "N"
    Confirm.ask("Are you sure?").must_equal false
  end

end
