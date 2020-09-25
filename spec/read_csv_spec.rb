# frozen_string_literal: true

require 'read_csv'

describe 'Read Csv Module exctract_data methods' do
  it 'raises no error on csv file input' do
    expect { ReadFile.extract_data './spec/input_test.csv' }.not_to raise_error
  end
  it 'returns an array with csv\'s data' do
    extracted_data = ReadFile.extract_data('./spec/input_test.csv')
    expect(extracted_data.class).to eq(Array)
    expect(extracted_data[0]).to eq(%w[INV 92 248])
    expect(extracted_data.last).to eq(%w[T 19796 20081])
  end
end
