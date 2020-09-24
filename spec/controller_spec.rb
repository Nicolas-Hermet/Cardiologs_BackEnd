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
  it 'redirects properly on root' do
    get '/'
    expect(last_response.status).to eq(302)
    expect(last_response.location).to include('/delineation/new')
  end
end
