raise "this spec require rspec_on_rails, and can only be run within an application that includes it" unless File.expand_path(File.dirname(__FILE__)) =~ %r|/vendor/plugins/| and File.directory?(File.dirname(__FILE__) + '/../../rspec_on_rails')

require File.dirname(__FILE__) + '/../../rspec_on_rails/spec/spec_helper.rb'
