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
    if params['recorded-at'].match(/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}/)
      @ecg.change_date_and_time_of_recording(params['recorded-at'])
    end
    erb :new_delineation
  end
end
