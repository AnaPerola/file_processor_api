# frozen_string_literal: true
class ProcessFileService
 def initialize(file)
    @file = file.is_a?(ActionDispatch::Http::UploadedFile) ? file : file[:file]
  end

  def self.call(file)
    new(file).process
  end

  def process
    return { error: 'File is not present' } unless @file

    grouped_orders = group_orders(parse_lines)
    grouped_orders.values.map do |user_data|
      {
        user_id: user_data[:user_id],
        name: user_data[:name],
        orders: build_orders(user_data[:orders])
      }
    end
  end

  private

  def group_orders(orders)
    orders.each_with_object({}) do |order, result|
      user_id = order[:user_id]
      result[user_id] ||= { user_id: user_id, name: order[:name], orders: {} }

      user_orders = result[user_id][:orders]
      user_orders[order[:order_id]] ||= {
        order_id: order[:order_id],
        date: order[:date],
        products: []
      }

      user_orders[order[:order_id]][:products] << {
        product_id: order[:product_id],
        value: order[:product_value]
      }
    end
  end

  def build_orders(orders_hash)
    orders_hash.values.map do |order|
      {
        order_id: order[:order_id],
        total: calculate_total(order[:products]),
        date: order[:date],
        products: order[:products]
      }
    end
  end

  def calculate_total(products)
    total = products.sum { |p| p[:value].to_f }
    format('%.2f', total)
  end

   def parse_lines
    @file.read.split("\n").filter_map do |line|
      next if line.strip.empty?

      {
        user_id: extract_int(line[0, 10]),
        name: line[10, 45].strip,
        order_id: extract_int(line[55, 10]),
        product_id: extract_int(line[65, 10]),
        product_value: parse_value(line[75, 12]),
        date: parse_date(line[87, 8])
      }
    end
  end

   def extract_int(value)
    value.to_s.strip.sub(/^0+/, '').to_i
  end

  def parse_value(raw)
    value = raw.to_s.strip.sub(/^0+/, '')
    format('%.2f', value.to_f)
  end

   def parse_date(date_str)
    return nil unless date_str && date_str.size == 8

    Date.strptime(date_str, '%Y%m%d').strftime('%Y-%m-%d')
  rescue
    date_str
  end

end
