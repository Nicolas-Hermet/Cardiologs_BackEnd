# frozen_string_literal: true

require 'controller'
require 'rspec'
require 'rack/test'

describe 'Delineation page' do
  include Rack::Test::Methods

  def app
    ApplicationController.new
  end

  context '/delineation/new' do
    it 'responds and has correct content' do
      get '/delineation/new'
      expect(last_response).to be_ok
      expect(last_response.body).to include('<p>Upload your CSV file to delineate</p>')
    end

    it 'has an \'upload button' do
      get '/delineation/new'
      expect(last_response.body).to include('<input type=\'submit\' value=\'Upload\'/>')
    end
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
