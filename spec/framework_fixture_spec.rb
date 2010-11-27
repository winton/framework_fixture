require 'spec_helper'

describe FrameworkFixture do
  
  before(:all) do
    @gem = ENV['RAILS'] ? 'rails' : ENV['SINATRA'] ? 'sinatra' : nil
    @version = ENV['RAILS'] || ENV['SINATRA']
    @config_version = @version ? "<#{@version.to_i + 1}" : nil
    
    FrameworkFixture.root = File.dirname(__FILE__) + '/fixtures'
    FrameworkFixture.load_config
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
    
    before(:all) do
      FrameworkFixture.require_gem
    end
    
    it "should populate @gem" do
      FrameworkFixture.framework.should == @gem
    end
    
    it "should populate @config_version" do
      FrameworkFixture.config_version.should == @config_version
    end
    
    it "should populate @version" do
      FrameworkFixture.version[0..0].should == @version
    end
    
    it "should return @config_version when framework method is called" do
      FrameworkFixture.send(@gem).should == @config_version
    end
  end
  
  describe :create_build do
    
    before(:all) do
      FrameworkFixture.create_build
    end
    
    it "should create builds directory" do
      File.exists?($root + '/spec/fixtures/builds').should == true
    end
    
    it "should populate @build" do
      FrameworkFixture.build.should == "#{$root}/spec/fixtures/builds/#{@gem}#{@version}"
    end
    
    it "should populate @app" do
      FrameworkFixture.app.class.should == Proc
    end
    
    it "should create framework build directory" do
      File.exists?(FrameworkFixture.build).should == true
    end
    
    it "should require the environment" do
      req = "#{$root}/spec/fixtures/builds/#{@gem}#{@version}"
      if @gem == 'rails'
        req += "/config/environment.rb"
      elsif @gem == 'sinatra'
        req += "/application.rb"
      end
      $".include?(req).should == true
    end
  end
end