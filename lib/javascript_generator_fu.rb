module ActionView #:nodoc:
  module Helpers #:nodoc:
    module PrototypeHelper #:nodoc:
      class JavaScriptGenerator #:nodoc:
        module GeneratorMethods
          # Executes the content of the block upon the completion of
          # page load.  This uses Prototype's
          # <code>Event.observe(window, 'load')</code>, or
          # <code>$(document).ready()</code> if jrails is loaded.
          #
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
            if jquery?
              self << "$(document).ready(function() {\n"
            else
              self << "Event.observe(\"window\", \"load\", function() {\n"
            end
            yield
            self << "\n});"
          end
          
          private
          def jquery?
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
