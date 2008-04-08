require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + "/../lib/javascript_generator_fu")

describe :JavaScriptGenerator, :onload do
  include ::ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods
  
  def text_from_generator
    ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(nil) do |page|
      yield page
    end.to_s
  end
  
  it "should wrap the block in Event.observe or $(document).ready" do
    text = text_from_generator do |page|
      page.onload do
        page.call 'alert', 'loaded!'
      end
    end
    text.should =~ /(\bEvent.observe\("window", "load", |\$\(document\)\.ready\()function\(\) \{\s*;?\s*alert\("loaded!"\);\s*\}\);/m
  end
  
  it "should preserve the order of statements" do
    text = text_from_generator do |page|
      page.call 'f', 1
      page.onload do page.call 'f', 2 end
      page.call 'f', 3
    end
    text.should =~ /f\(1\).*f\(2\).*f\(3\)/m
  end
end
