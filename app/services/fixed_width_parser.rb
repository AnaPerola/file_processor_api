class FixedWidthParser
  def initialize(file)
    @file = file
  end

  def parse
    @file.read.split("\n").filter_map do |line|
      next if line.strip.empty?

      {
        user_id: extract_int(line[0, 10]),
        name: line[10, 30].strip,
        order_id: extract_int(line[40, 10]),
        product_id: extract_int(line[50, 10]),
        product_value: parse_value(line[60, 8]),
        date: parse_date(line[68, 8])
      }
    end
  end

  private

  def extract_int(value)
    value.to_s.strip.sub(/^0+/, '').to_i
  end

  def parse_value(raw)
    value = raw.to_s.strip.sub(/^0+/, '')
    format('%.2f', value.to_f)
  end

  def parse_date(date_str)
    return nil unless date_str && date_str.size == 8

    Date.strptime(date_str, '%Y%m%d')
  rescue ArgumentError
    nil
  end
end
