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

  it 'says hello' do
    get '/delineation/new'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'redirects properly on root' do
    get '/'
    expect(last_response.status).to eq(302)
    expect(last_response.location).to include('/delineation/new')
  end

  it 'posts csv files' do
    post '/delineation/new'
    expect(last_response.status).to eq(200)
  end
end
