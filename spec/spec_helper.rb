# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

#require 'simplecov'
#dir = "./reports/coverage"
#SimpleCov.coverage_dir(dir)
#SimpleCov.start

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    ::Connect4
  end
end

RSpec.configure { |c| c.include RSpecMixin }
