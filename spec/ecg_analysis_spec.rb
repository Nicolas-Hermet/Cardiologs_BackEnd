# frozen_string_literal: true

require 'ecg_analysis'
require 'read_csv'

describe 'ecg analysis class' do
  data = ReadFile.extract_data('./spec/input_test.csv')

  it 'has same raw data as the file' do
    expect { ECGAnalysis.new(data) }.not_to raise_error
  end

  ecg = ECGAnalysis.new(data)
  it 'parses data' do
    expect(ecg.raw_data).to eq(data)
    expect(ecg.premature_p_wave_number).to eq(2)
    expect(ecg.premature_qrs_wave_number).to eq(1)
    expect(ecg.max_rate).to eq([50.8, [17976, 19158]])
    expect(ecg.min_rate).to eq([43.0, [6571]])
    expect(ecg.mean_rate).to eq(48.1)
  end

  it 'can change start time of recording' do
    expect{ecg.change_date_and_time_of_recording("")}.not_to raise_error
    time_now = Time.now
    ecg.change_date_and_time_of_recording(time_now.strftime("%F-%k:%M:%S.%L"))
    # last significant digit can be in error (e.g 17.975 instead of 17.976)
    expect(ecg.max_rate[1][0][0...-1]).to eq((time_now + 17.976).strftime("%F-%k:%M:%S.%L")[0...-1])
    expect(ecg.min_rate[1][0][0...-1]).to eq((time_now + 6.571).strftime("%F-%k:%M:%S.%L")[0...-1])
    expect(ecg.max_rate[1][1][0...-1]).to eq((time_now + 19.158).strftime("%F-%k:%M:%S.%L")[0...-1])
  end
end
