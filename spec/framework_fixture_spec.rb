require 'spec_helper'

describe FrameworkFixture do
  
  include Rack::Test::Methods
  
  def app
    FrameworkFixture.app.call
  end
  
  before(:all) do
    @gem = ENV['RAILS'] ? 'rails' : ENV['SINATRA'] ? 'sinatra' : nil
    @exact_version = ENV['RAILS'] || ENV['SINATRA']
    @loose_version = @exact_version ? "<#{@exact_version.to_i + 1}" : nil
  end
  
  describe :load_config do
  
    it "should populate @config" do
      FrameworkFixture.config.should == {"rails"=>
        {"<3"=>
          {"rails2"=>
            ["app/controllers/application_controller.rb",
             "config/environment.rb",
             "config/routes.rb"]},
         "<4"=>
          {"rails3"=>
            ["app/controllers/application_controller.rb",
             "config/application.rb",
             "config/routes.rb",
             "Gemfile"]}},
       "sinatra"=>
        {"<1"=>{"sinatra"=>["application.rb"]},
         "<2"=>{"sinatra"=>["application.rb"]}}}
    end
  end
  
  describe :require_gem do
    
    it "should populate @gem" do
      FrameworkFixture.framework.should == @gem
    end
    
    it "should populate @loose_version" do
      FrameworkFixture.loose_version.should == @loose_version
    end
    
    it "should populate @exact_version" do
      FrameworkFixture.exact_version[0..0].should == @exact_version
    end
    
    it "should return @loose_version when framework method is called" do
      FrameworkFixture.send(@gem).should == @loose_version
    end
  end
  
  describe :create_build do
    
    it "should create builds directory" do
      File.exists?($root + '/spec/fixtures/builds').should == true
    end
    
    it "should populate @build" do
      FrameworkFixture.build.should == "#{$root}/spec/fixtures/builds/#{@gem}#{@exact_version}"
    end
    
    it "should populate @app" do
      FrameworkFixture.app.class.should == Proc
    end
    
    it "should create framework build directory" do
      File.exists?(FrameworkFixture.build).should == true
    end
    
    it "should require the environment" do
      req = "#{$root}/spec/fixtures/builds/#{@gem}#{@exact_version}"
      if @gem == 'rails'
        req += "/config/environment.rb"
      elsif @gem == 'sinatra'
        req += "/application.rb"
      end
      $".include?(req).should == true
    end
  end
  
  describe :rack_test do
    
    it "should have a pulse" do
      get "/pulse"
      last_response.body.should == '1'
    end
  end
end