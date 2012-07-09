require "pp"
require "bundler"

Bundler.require(:development)

$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/framework_fixture"

FrameworkFixture.generate File.dirname(__FILE__) + '/fixtures'