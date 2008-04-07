require 'code_statistics'

class CodeStatistics #:nodoc:
  def calculate_directory_statistics_with_js(directory, pattern = /.*\.rb$/)
    pattern = /.*\.js$|(#{pattern})/
    calculate_directory_statistics_without_js(directory, pattern)
  end
  alias_method_chain :calculate_directory_statistics, :js
end
