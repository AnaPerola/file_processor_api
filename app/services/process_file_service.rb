# frozen_string_literal: true
class ProcessFileService
  def initialize(file)
    @file = file
  end

  def self.call(file)
    new(file).process
  end

  def process
    return { error: 'File is not present' } unless @file

    file = @file.is_a?(ActionDispatch::Http::UploadedFile) ? @file : @file[:file]
    return { error: 'No file uploaded' } unless file

    lines = file.read.split("\n").reject(&:empty?)
    parsed_orders = lines.map do |line|
      {
        user_id: line[0,10].to_s.strip.sub(/^0+/, ''),
        name: line[10,45].to_s.strip,
        order_id: line[55,10].to_s.strip.sub(/^0+/, ''),
        product_id: line[65,10].to_s.strip.sub(/^0+/, ''),
        product_value: line[75,12].to_s.strip.sub(/^0+/, '').insert(-3, '.'),
        purchase_date: parse_date(line[87,8])
      }
    end

    { orders: parsed_orders }
  end

  private

  def parse_date(date_str)
    return nil unless date_str && date_str.size == 8
    Date.strptime(date_str, '%Y%m%d').strftime('%Y-%m-%d') rescue date_str
  end
end
