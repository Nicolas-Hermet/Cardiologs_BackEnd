# frozen_string_literal: true

require 'sinatra'
require 'read_csv'
require 'ecg_analysis'

# Delineation App
class ApplicationController < Sinatra::Base
  get '/' do
    redirect '/delineations/new/'
  end

  get '/delineations/new/' do
    erb :new_delineation
  end

  post '/delineations/new/' do
    @ecg = ECGAnalysis.new ReadFile.extract_data params[:ecg][:tempfile] if params[:ecg]
    @ecg.change_date_and_time_of_recording(params['recorded-at']) if params['recorded-at']
    erb :new_delineation
  end
end
