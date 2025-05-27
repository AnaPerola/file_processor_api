# frozen_string_literal: true

class FixedWidthParser
  def initialize(file)
    @file = file
  end

  def parse
    return [] unless @file.present?

    lines = read_lines

    lines.filter_map do |line|
      next if line.strip.empty?

      parse_line(line)
    end
  end

  private

  def read_lines
    @file.read.split("\n")
  rescue StandardError => e
    Rails.logger.error("Error reading file: #{e.message}")
    []
  end

  def parse_line(line)
    {
      user_id: extract_int(line[0, 10]),
      name: line[10, 45].strip,
      order_id: extract_int(line[55, 10]),
      product_id: extract_int(line[65, 10]),
      product_value: parse_value(line[75, 12]),
      date: parse_date(line[87, 8])
    }
  rescue => e
    Rails.logger.warn("Failed to parse line: #{line.inspect} | Error: #{e.message}")
    nil
  end

  def extract_int(str)
    str.to_s.strip.sub(/^0+/, '').to_i
  end

  def parse_value(raw)
    value = raw.to_s.strip.sub(/^0+/, '')
    format('%.2f', value.to_f)
  end

  def parse_date(date_str)
    return nil unless date_str&.size == 8

    Date.strptime(date_str, '%Y%m%d')
  rescue
    nil
  end
end
