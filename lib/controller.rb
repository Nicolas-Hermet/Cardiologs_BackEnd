# frozen_string_literal: true

require 'sinatra'

# Delineation App
class ApplicationController < Sinatra::Base
  get '/' do
    redirect '/delineation/new'
  end

  get '/delineation/new' do
    erb :new_delineation
  end

  post '/delineation/new' do
    # TODO: call future read_file module
  end
end
