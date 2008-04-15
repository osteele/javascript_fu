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
                     pattern = /\b#{pattern}\b\s*\((.*)?/
                   else
                     # else the arglist is required
                     pattern = /\b#{pattern}\s*\((.*)/
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
          @spec_scope.assert_select(actual, 'script', @pattern) do |tags|
            if block
              raise "no arguments detected" unless tags[0].to_s =~ @pattern
              args = JavascriptFu.read_json_arglist($1)
              block.call(args)
            end
          end
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
    # If block is supplied, the arguments to the function are decoded
    # as JSON and passed to the block:
    #   # response includes <script>...fn('string', 2)...</script>
    #   response.should call_js(fn') do |args|
    #     args.should == ['string', 2]
    #   end
    #
    # Since in this case the whole argument list is parsed as one JSON list,
    # it can't include any comments or non-literal expressions.
    def call_js(pattern, &block)
      return CallJS.new(pattern, self, &block)
    end
  end
  
  # Parse until the first unmatched ")]}" or end of string
  def self.read_json_arglist(string)
    require 'activesupport'
    scanner, level = StringScanner.new(string), 0
    while scanner.scan_until(/(['"\/(){}\[\]])/)
      token = scanner[1]
      break if token =~ /[)}\]]/ and level == 0
      case token
      when /[({\[]/
        level += 1
      when /[)}\]]/
        level -= 1
      when /'/
      when /"/
      else
        raise "unimplemented"
      end
    end
    string = string[0...scanner.pos-1] if scanner.pos > 0
    ActiveSupport::JSON.decode('[' + string + ']')
  end
end
