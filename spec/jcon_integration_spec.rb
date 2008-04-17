require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + "/../lib/js_fu_matchers")

require 'jcon'

describe :call_js do
  include JavascriptFu::Matchers
  include JCON::Matchers

  it "should integrate with the jcon gem" do
    '<script>fn("id", {x:1, y:2}, true)</script>'.should call_js('fn') do |args|
      args[0].should conform_to_js('string')
      args[1].should conform_to_js('{x:int, y:int}')
      args[2].should conform_to_js('boolean')
      args.should conform_to_js('[string, {x:int, y:int}, boolean]')
    end
  end
end
