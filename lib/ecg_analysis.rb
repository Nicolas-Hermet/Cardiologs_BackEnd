# frozen_string_literal: true

# Compute qnt of P and QRS tagged premature
# Compute min, max rates of QRS waves and corresponding timeStamps
# Compute mean rates of QRS waves
#
class ECGAnalysis
  attr_reader :raw_data, :premature_p_wave_number, :premature_qrs_wave_number, :mean_rate, :min_rate, :max_rate

  def initialize(data)
    @raw_data = data
    @premature_p_wave_number = 0
    @premature_qrs_wave_number = 0
    @mean_rate = 0
    @min_rate = []
    @max_rate = []
    parse @raw_data
  end

  def premature?(row)
    row.last.downcase == 'premature'
  end

  def wave_type?(row, wave_type)
    row.first.downcase == wave_type.downcase
  end

  private

  def parse(data)
    data.each do |row|
      @premature_p_wave_number += 1 if premature?(row) && wave_type?(row, 'P')
      @premature_qrs_wave_number += 1 if premature?(row) && wave_type?(row, 'QRS')
    end
  end
end
