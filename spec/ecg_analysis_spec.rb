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
end
