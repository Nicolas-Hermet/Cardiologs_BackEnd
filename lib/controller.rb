# frozen_string_literal: true

require 'sinatra'

# Delineation App
class ApplicationController < Sinatra::Base
  get '/' do
    redirect '/delineation/new'
  end

  get '/delineation/new' do
    'Hello World'
  end
end
