task :stats => "javascript:statsetup"

namespace :javascript do
  task :statsetup do
    require "#{File.dirname(__FILE__)}/../lib/js_statistics"
    STATS_DIRECTORIES += [['JavaScript', "#{RAILS_ROOT}/public/javascripts"]].select { |_, dir| File.directory?(dir) }
  end
end
