# frozen_string_literal: true

require 'controller'
require 'rspec'
require 'rack/test'

RSpec.describe 'Delineation App' do
  include Rack::Test::Methods

  def app
    # Sinatra::Application
    ApplicationController.new
  end
end
