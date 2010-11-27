FrameworkFixture
================

Dynamically generate Rails and Sinatra apps to be tested by <code>Rack::Test</code>.

Why? Because I don't like committing tons of unnecessary fixture files to my projects.

Requirements
------------

<pre>
gem install framework_fixture
</pre>

Add frameworks.yml to Fixtures Directory
----------------------------------------

<pre>
rails:
  &lt;3:
    rails2:
      - app/controllers/application_controller.rb
      - config/environment.rb
      - config/routes.rb
  &lt;4:
    rails3:
      - app/controllers/application_controller.rb
      - config/application.rb
      - config/routes.rb
      - Gemfile
sinatra:
  &lt;1:
    sinatra:
      - application.rb
  &lt;2:
    sinatra:
      - application.rb
</pre>

(See [specs](https://github.com/winton/framework_fixture/tree/master/spec/) for example of what this configuration maps to)

Add to Test Helper
------------------

<pre>
require 'rubygems'
require 'framework_fixture'

FrameworkFixture.generate(File.dirname(__FILE__) + '/fixtures')
</pre>

Write Test
----------

<pre>
require 'spec_helper'

if FrameworkFixture.rails == '&lt;4'
  describe 'Rails 3' do

    include Rack::Test::Methods

    def app
      FrameworkFixture.app.call
    end

    it "should have a pulse" do
      get "/pulse"
      last_response.body.should == '1'
    end
  end
end
</pre>

Run Tests With Framework Environment Variable
---------------------------------------------

<pre>
RAILS=2 spec spec
RAILS=3 spec spec
SINATRA=1 spec spec
</pre>