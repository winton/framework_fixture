require File.dirname(__FILE__) + '/framework_fixture/gems'

FrameworkFixture::Gems.require(:lib)

require 'fileutils'
require 'rubygems'
require 'yaml'

$:.unshift File.dirname(__FILE__) + '/framework_fixture'

require 'version'

class FrameworkFixture
  class <<self
    
    attr_accessor :root
    attr_reader :app, :build, :config, :config_version, :framework, :version
    
    def create_build
      FileUtils.mkdir_p @build = "#{@root}/builds"
      
      if rails
        case @version[0..0]
        when '2' then
          @build += "/rails2"
          @app = lambda { ActionController::Dispatcher.new }
          cmd = "rails _#{@version}_ #{@build}"
        when '3' then
          @build += "/rails3"
          @app = lambda { Rails3::Application }
          cmd = "rails _#{@version}_ new #{@build}"
        end
        req = @build + "/config/environment.rb"
      elsif sinatra
        @build += "/sinatra#{@version[0..0]}"
        @app = lambda { Application.new }
        req = @build + "/application.rb"
      end
      
      if req
        if !File.exists?(req)
          if cmd
            puts "Generating framework build: #{cmd}"
            puts `#{cmd}`
          else
            FileUtils.mkdir_p @build
          end
        
          if config = @config[@framework][@config_version]
            config.each do |dir, files|
              files.each do |f|
                if File.exists?(from = "#{@root}/#{dir}/#{File.basename(f)}")
                  FileUtils.cp from, "#{@build}/#{f}"
                end
              end
            end
          end
        end
        
        require req
      end
    end
    
    def generate(root)
      @root = root
      
      load_config
      require_gem
      create_build
    end
    
    def load_config
      @config = File.read(@root + '/frameworks.yml')
      @config = YAML::load(@config)
    end
    
    def rails
      @config_version if @framework == 'rails'
    end
    
    def require_gem
      if ENV['RAILS']
        g = 'rails'
      elsif ENV['SINATRA']
        g = 'sinatra'
      end
      
      if g
        v = ENV['RAILS'] || ENV['SINATRA']
      
        if v.match(/\d*/)[0].length == v.length
          v = "<#{v.to_i + 1}"
        end
        
        gem g, v
        
        @config_version = v
        @framework = g
        @version = Gem.loaded_specs[g].version.to_s
      end
    end
    
    def sinatra
      @config_version if @framework == 'sinatra'
    end
  end
end