require 'source_annotation_extractor'

# Monkey-patch to look in public/javascripts and in js source files
class SourceAnnotationExtractor
  def find_in_with_js(dir)
    results = find_in_without_js(dir)

    Dir.glob("#{dir}/*") do |item|
      case
      when File.basename(item)[0] == ?.
      when File.directory?(item)
      when item =~ /\.js$/
        results.update(extract_annotations_from(item, /(?:\/\/|\/\*)\s*(#{tag})(?:.*:|:)?\s*(.*?)(?:\*\/)?$/))
      end
    end

    results
  end
  alias_method_chain :find_in, :js

  def default_dirs
    %w[app lib test]
  end unless method_defined?(:default_dirs)

  def default_dirs_with_js
    default_dirs_without_js + %w[public/javascripts]
  end
  alias_method_chain :default_dirs, :js
  
  def find_with_default_dirs(dirs=default_dirs)
    find_without_default_dirs(dirs)
  end
  alias_method_chain :find, :default_dirs
end
