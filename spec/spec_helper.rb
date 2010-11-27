$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/framework_fixture/gems"
require "#{$root}/lib/framework_fixture"

FrameworkFixture.generate File.dirname(__FILE__) + '/fixtures'
FrameworkFixture::Gems.require(:spec)

require 'rack/test'
require 'pp'

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end