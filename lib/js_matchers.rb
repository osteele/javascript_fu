module JavascriptMatchers
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
  def call_js(pattern)
    pattern = case
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
    # only look in script tags
    have_tag('script', pattern)
  end
end
