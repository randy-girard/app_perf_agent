#-*- coding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = "app_perf_agent"
  s.version       = "0.0.6"
  s.date          = "2017-07-24"
  s.summary       = "AppPerf Agent"
  s.description   = "Agent for the AppPerf app."
  s.authors       = ["Randy Girard"]
  s.email         = "rgirard59@yahoo.com"

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.homepage      = "https://www.github.com/randy-girard/app_perf_agent"
  s.license       = "MIT"

  s.add_development_dependency "rake", "12.0.0"
  s.add_development_dependency "rspec", "3.6.0"
  s.add_development_dependency "pry", "0.10.4"
  s.add_development_dependency "simplecov", "0.14.1"
  s.add_runtime_dependency "msgpack"
  s.add_runtime_dependency "vmstat", "2.3.0"
end
