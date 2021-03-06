# -*- encoding: utf-8 -*-
root = File.expand_path('../', __FILE__)
lib = "#{root}/lib"

$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "framework_fixture"
  s.version = '0.2.2'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/framework_fixture"
  s.summary = "Dynamically generate Rails and Sinatra apps to be tested by Rack::Test"
  s.description = "Dynamically generate Rails and Sinatra apps to be tested by Rack::Test."

  s.executables = `cd #{root} && git ls-files bin/*`.split("\n").collect { |f| File.basename(f) }
  s.files = `cd #{root} && git ls-files`.split("\n")
  s.require_paths = %w(lib)
  s.test_files = `cd #{root} && git ls-files -- {features,test,spec}/*`.split("\n")

  s.add_development_dependency "rake"
  s.add_development_dependency "rails", "~> 3.0"
  s.add_development_dependency "sinatra", "~> 1.0"
  s.add_development_dependency "rspec", "~> 1.0"
  s.add_development_dependency "stasis", "~> 0.0"

  s.add_dependency "rack-test", "=0.6.1"
end