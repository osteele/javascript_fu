task :notes => "javascript:notessetup"

namespace :javascript do
  task :notessetup do
    require "#{File.dirname(__FILE__)}/../lib/js_annotation_extractor"
  end
end
