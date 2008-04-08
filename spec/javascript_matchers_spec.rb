require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + "/../lib/js_matchers")

describe :call_js do
  include JavascriptMatchers
  
  it 'should match script content using a regexp' do
    string = '<script>foo</script>'
    string.should call_js(/fo*/)
  end

  describe "with a function name" do
    it 'should match a function call' do
      string = '<script>fname()</script>'
      string.should call_js('fname')
    end
    
    it 'should match a method call' do
      string = '<script>obj.fname()</script>'
      string.should call_js('fname')
      string.should call_js('obj.fname')
    end
    
    it 'should require parentheses' do
      string = '<script>fname</script>'
      string.should_not call_js('fname')
    end
    
    it 'should not match part of a name' do
      string = '<script>fname()</script>'
      string.should_not call_js('fnam')
      string.should_not call_js('name')
    end
    
    it 'should not match outside of a script tag' do
      string = '<script>text</script><p>fname()</p>'
      string.should_not call_js('fname')
    end
  end
  
  describe "with a constructor" do
    it 'should match a constructor with arguments' do
      string = '<script>var obj = new klass()</script>'
      string.should call_js('new klass')
    end
    
    it 'should match a constructor without arguments' do
      string = '<script>var obj = new klass()</script>'
      string.should call_js('new klass')
    end
    
    it 'should not match part of a name' do
      string = '<script>var obj = new klass()</script>'
      string.should_not call_js('new klas')
    end
  end
end
