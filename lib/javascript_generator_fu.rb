module ActionView
  module Helpers
    module PrototypeHelper
      class JavaScriptGenerator #:nodoc:
        module GeneratorMethods
          # Example:
          #
          #   # Generates:
          #   #   Event.observe("window", "load", function() { fn(); });
          #   # or:
          #   #   $(document).ready(function() { fn(); });
          #   page.onload do
          #     page.call 'fn'
          #    end
          def onload
            if use_jquery?
              record "$(document).ready(function() {\n\n"
            else
              record "Event.observe(\"window\", \"load\", function() {\n\n"
            end
            yield
            record "});"
          end
          
          private
          def use_jquery?
            js = JavaScriptGenerator.new(nil) do |page|
              page.insert_html('top', 'id')
            end.to_s
            js =~ /^\$\(/
          end
        end
      end
    end
  end
end
