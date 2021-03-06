require 'fileutils'
require 'yaml'

require 'rubygems'
require 'rack/test'

$:.unshift File.dirname(__FILE__)

class FrameworkFixture
  class <<self
    
    attr_accessor :root
    attr_reader :app, :build, :config, :exact_version, :framework, :loose_version
    
    def create_build
      FileUtils.mkdir_p @build = "#{@root}/builds"
      
      if rails
        case @exact_version[0..0]
        when '2' then
          @build += "/rails2"
          @app = lambda { ActionController::Dispatcher.new }
          cmd = "rails _#{@exact_version}_ #{@build}"
        when '3' then
          @build += "/rails3"
          @app = lambda { Rails3::Application }
          cmd = "rails _#{@exact_version}_ new #{@build}"
        end
        req = @build + "/config/environment.rb"
      elsif sinatra
        @build += "/sinatra#{@exact_version[0..0]}"
        @app = lambda { Application.new }
        req = @build + "/application.rb"
      elsif stasis
        @build += "/stasis#{@exact_version[0..0]}"
        @app = lambda do
          Stasis.new(@build, "#{@build}_output")
        end
      end
      
      unless File.exists?(@build)
        if cmd
          puts "Generating framework build: #{cmd}"
          puts `#{cmd}`
        else
          FileUtils.mkdir_p @build
        end
      end
      
      if @config[@framework] && config = @config[@framework][@loose_version]
        config.each do |dir, files|
          files.each do |f|
            if File.exists?(from = "#{@root}/#{dir}/#{File.basename(f)}")
              FileUtils.mkdir_p File.dirname("#{@build}/#{f}")
              FileUtils.cp from, "#{@build}/#{f}"
            end
          end
        end
      end
      
      require req if req
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
    
    def require_gem
      set_vars
      
      if @framework
        gem @framework, @loose_version
        @exact_version = Gem.loaded_specs[@framework].version.to_s
      end
    end
    
    def set_vars
      if ENV['RAILS']
        @framework = 'rails'
      elsif ENV['SINATRA']
        @framework = 'sinatra'
      elsif ENV['STASIS']
        @framework = 'stasis'
      end
      
      if @framework
        @loose_version = ENV['RAILS'] || ENV['SINATRA'] || ENV['STASIS']
      
        if @loose_version.match(/\d*/)[0].length == @loose_version.length
          @loose_version = "<#{@loose_version.to_i + 1}"
        end
      end
    end
    
    %w(rails sinatra stasis).each do |method|
      define_method method do
        @loose_version if @framework == method
      end
    end
    
    FrameworkFixture.set_vars
  end
end