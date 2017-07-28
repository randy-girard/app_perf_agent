#-*- coding: utf-8 -*-
$:.push "#{File.expand_path("..", __FILE__)}/lib"

Gem::Specification.new do |s|
  s.name          = "app_perf_agent"
  s.version       = "0.0.1"
  s.date          = "2017-07-24"
  s.summary       = "AppPerf Agent"
  s.description   = "Agent for the AppPerf app."
  s.authors       = ["Randy Girard"]
  s.email         = "rgirard59@yahoo.com"

  files  = `git ls-files`.split("\n") rescue []
  files += Dir["lib/**/*.rb"]
  s.files         = files

  s.require_paths = ["lib"]
  s.homepage      = "https://www.github.com/randy-girard/app_perf_agent"
  s.license       = "MIT"

  s.add_development_dependency "rake", "12.0.0"
  s.add_development_dependency "rspec", "3.6.0"
  s.add_development_dependency "pry", "0.10.4"
  s.add_development_dependency "simplecov", "0.14.1"
  s.add_runtime_dependency "oj", "3.3.2"
  s.add_runtime_dependency "vmstat", "2.3.0"
end
