# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'framework_fixture/gems'
require 'framework_fixture/version'

Gem::Specification.new do |s|
  s.name = "framework_fixture"
  s.version = FrameworkFixture::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/framework_fixture"
  s.summary = ""
  s.description = ""

  FrameworkFixture::Gems::TYPES[:gemspec].each do |g|
    s.add_dependency g.to_s, FrameworkFixture::Gems::VERSIONS[g]
  end
  
  FrameworkFixture::Gems::TYPES[:gemspec_dev].each do |g|
    s.add_development_dependency g.to_s, FrameworkFixture::Gems::VERSIONS[g]
  end

  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = Dir.glob("{bin}/*").collect { |f| File.basename(f) }
  s.require_path = 'lib'
end