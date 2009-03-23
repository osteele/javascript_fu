require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run specs.' 
task :default => :spec
 
desc 'Generate documentation for the plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc' 
  rdoc.title    = 'JavaScript Fu'
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc'
  rdoc.rdoc_files.include ['lib', 'README.rdoc', 'TODO', 'MIT-LICENSE']
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  if ENV['RCOV']
    t.rcov = true
    t.rcov_dir = '../doc/output/coverage'
    t.rcov_opts = ['--exclude', 'spec\/spec']
  end
end
