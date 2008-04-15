require File.join(File.dirname(__FILE__), '/../lib/js_fu_matchers')

describe JavascriptFu do
  describe :read_json_arglist do
    it "should read some values" do
      JavascriptFu.read_json_arglist('1,2').should == [1, 2]
    end
    
    it "should ignore trailing characters" do
      JavascriptFu.read_json_arglist('1,2)]]').should == [1, 2]
    end
    
    it "should enclose nested braces" do
      JavascriptFu.read_json_arglist('1,{a:2,b:3},4)]]').should == [1, {'a' => 2, 'b' => 3}, 4]
    end
    
    it "should enclose nested brackets" do
      JavascriptFu.read_json_arglist('1,[2,3],4)]]').should == [1, [2, 3], 4]
    end
    
    it "should enclose multiple nesting levels" do
      JavascriptFu.read_json_arglist('1,[{a:[2],b:{c:3}},[4]],5)]]').should == [1, [{'a' => [2], 'b' => {'c' => 3}}, [4]], 5]
    end
    
    it "should scan strings" do
      JavascriptFu.read_json_arglist("'str')").should == ['str']
      JavascriptFu.read_json_arglist('"str")').should == ['str']
      JavascriptFu.read_json_arglist("'str','ing')").should == ['str', 'ing']
    end
    
    it "should scan strings with quoted quotes" do
      JavascriptFu.read_json_arglist('"str\\"ing")').should == ['str"ing']
    end
    
    it "should scan simple regular expressions"
  end
end
