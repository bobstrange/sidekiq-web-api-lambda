
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :test do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :default => ['test']
