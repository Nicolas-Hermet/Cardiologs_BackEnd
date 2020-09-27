# frozen_string_literal: true

require 'controller'
require 'rspec'
require 'rack/test'

describe 'Delineation page' do
  include Rack::Test::Methods

  def app
    ApplicationController.new
  end

  context '/delineations/new/' do
    it 'responds and has correct content' do
      get '/delineations/new/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('<p>Upload your CSV file to delineate</p>')
    end

    it 'has an \'upload button' do
      get '/delineations/new/'
      expect(last_response.body).to include('<button type=\'submit\'>Upload ')
    end
  end

  it 'redirects properly on root' do
    get '/'
    expect(last_response.status).to eq(302)
    expect(last_response.location).to include('/delineations/new/')
  end

  it 'posts csv files' do
    post '/delineations/new/'
    expect(last_response.status).to eq(200)
  end
end
