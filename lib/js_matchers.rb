module JavascriptFu
  module Matchers
    class CallJS #:nodoc:
      def initialize(pattern, spec_scope)
        @expected = pattern
        @spec_scope = spec_scope
        @pattern = case
                   when pattern.kind_of?(Regexp)
                     pattern
                   when pattern =~ /^[$_\w\d\.]+\(/
                     # already has an lparen: search verbatim
                     pattern = /\b#{pattern}/
                   when pattern =~ /^new\b/
                     # 'new': the arglist is optional
                     pattern = /\b#{pattern}\b\s*(\(.*)?/
                   else
                     # else the arglist is required
                     pattern = /\b#{pattern}\s*(\(.*)/
                   end
      end
      
      def matches?(response_or_text, &block)
        actual = response_or_text
        # Adapted from AssertSelect#matches? in rspec_on_rails:
        if ActionController::TestResponse === response_or_text and
            response_or_text.headers.key?('Content-Type') and
            response_or_text.headers['Content-Type'].to_sym == :xml
          actual = HTML::Document.new(response_or_text.body, false, true).root
        elsif String === response_or_text
          actual = HTML::Document.new(response_or_text).root
        end
        begin
          @spec_scope.assert_select(actual, 'script', @pattern, &block)
        rescue ::Test::Unit::AssertionFailedError => @error
        end
        
        @error.nil?
      end

      def failure_message; "should #{description}, but did not"; end
      def negative_failure_message; "should not #{description}, but did"; end

      def description
        "call js(#{@expected.inspect})"
      end
    end
    
    # Passes if the response has a script element that contains a call
    # to the specified function.  The argument can be a Regexp or a
    # String.  If it is a Regexp or a String that contains
    # <code>'('</code>, the matcher simply looks for a matching tag
    # (using +have_tag+).  Otherwise, the matcher further verifies that
    # the string is followed by <code>'('</code>, to indicate a
    # function call.
    #
    # Examples:
    #   response.should call_js('fn')
    #   response.should call_js('fn(1)')
    #   response.should call_js('obj.fn')
    #   response.should call_js('obj.fn(1)')
    #   response.should call_js('new C')
    #   response.should call_js('new C(1)')
    #
    def call_js(pattern, &block)
      return CallJS.new(pattern, self, &block)
      # only look in script tags
      have_tag('script', pattern)
      if block
        p self
      end
    end
  end
end
