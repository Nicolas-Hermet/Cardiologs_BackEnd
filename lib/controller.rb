# frozen_string_literal: true

require 'sinatra'

# Delineation App
class ApplicationController < Sinatra::Base
  get '/' do
    redirect '/delineations/new/'
  end

  get '/delineations/new/' do
    erb :new_delineation
  end

  post '/delineations/new/' do
    erb :new_delineation
  end
end
