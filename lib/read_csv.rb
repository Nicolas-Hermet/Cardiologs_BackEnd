# frozen_string_literal: true

require 'csv'

# Module to parse CSV of ECG
module ReadFile
  def self.extract_data(csv_file)
    CSV.read csv_file
  end
end
