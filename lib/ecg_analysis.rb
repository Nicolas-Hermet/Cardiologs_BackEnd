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
    @min_rate = [0, []]
    @max_rate = [0, []]
    parse_data @raw_data
    @max_rate[0] = to_bpm(@max_rate[0])
    @min_rate[0] = to_bpm(@min_rate[0])
    @mean_rate = to_bpm(@mean_rate)
  end

  def change_date_and_time_of_recording(date_and_time)
    return unless date_and_time != ''

    chosen_time = DateTime.parse(date_and_time).to_time
    change_min_rate_time(chosen_time)
    change_max_rate_time(chosen_time)
  end

  private

  def change_min_rate_time(chosen_time)
    @min_rate[1].map! { |t| Time.at(chosen_time + t.to_f / 1000).strftime('%F-%k:%M:%S.%L') } if @min_rate[1].length
  end

  def change_max_rate_time(chosen_time)
    @max_rate[1].map! { |t| Time.at(chosen_time + t.to_f / 1000).strftime('%F-%k:%M:%S.%L') } if @max_rate[1].length
  end

  # return true if a row is tagged 'premature'
  def premature?(row)
    row.last.downcase == 'premature'
  end

  # return true if a row has the wave_type
  def wave_type?(row, wave_type)
    row.first.downcase == wave_type.downcase
  end

  # loop on the csv data row by row and count :
  #   - premature p waves
  #   - premature qrs waves
  #   - number of total qrs waves
  def parse_data(data)
    current_qrs_time = 0
    previous_qrs_time = 0
    rates_sum = 0
    qrs_wave_qnty = 0
    data.each do |row|
      count_p_qrs_premature_waves row
      next unless wave_type?(row, 'QRS')

      qrs_wave_qnty += 1
      previous_qrs_time = current_qrs_time
      current_qrs_time = row[1].to_i + (row[2].to_i - row[1].to_i) / 2 # time at wave peek
      rates_sum += compute_rate(current_qrs_time, previous_qrs_time) if previous_qrs_time != 0
    end
    @mean_rate = rates_sum / (qrs_wave_qnty - 1) # rates are computed between two waves. So n - 1 rates for n waves.
  end

  def count_p_qrs_premature_waves(row)
    @premature_p_wave_number += 1 if premature?(row) && wave_type?(row, 'P')
    @premature_qrs_wave_number += 1 if premature?(row) && wave_type?(row, 'QRS')
  end

  def compute_rate(current_time, previous_time)
    time_at_rate = previous_time + (current_time - previous_time) / 2
    # rate value at time_at_rate. i.e: between the last two peeks (current and previous)
    instant_rate = 1 / (current_time - previous_time).to_f
    max_rate? instant_rate, time_at_rate
    min_rate? instant_rate, time_at_rate
    instant_rate
  end

  def max_rate?(rate, time)
    @max_rate[1] << time if rate == @max_rate[0]
    return unless rate > @max_rate[0]

    @max_rate[0] = rate
    @max_rate[1] = [time]
  end

  def min_rate?(rate, time)
    @min_rate[1] << time if rate == @min_rate[0]
    return unless (rate < @min_rate[0]) || (@min_rate[0]).zero?

    @min_rate[0] = rate
    @min_rate[1] = [time]
  end

  def to_bpm(rate)
    (rate * 1000 * 60).round(1)
  end
end
