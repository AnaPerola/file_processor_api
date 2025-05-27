# frozen_string_literal: true

class ProcessFileService
  def initialize(file, filter_params = {})
    @file = file
    @filter_criteria = build_filter_criteria(filter_params)
    @parser = FixedWidthParser.new(file)
  end

  def self.call(file, **filter_params)
    new(file, filter_params).process
  end

  def process
    return { error: 'File is not present' } unless @file

    parsed_lines = @parser.parse
    filtered_lines = parsed_lines.select { |line| @filter_criteria.matches?(line) }
    grouped_orders = group_orders(filtered_lines)

    grouped_orders.values.map do |user_data|
      {
        user_id: user_data[:user_id],
        name: user_data[:name],
        orders: build_orders(user_data[:orders])
      }
    end
  end

  private

  def build_filter_criteria(filter_params)
    FilterCriteriaService.new(
      order_ids: filter_params[:order_ids],
      start_date: parse_date_param(filter_params[:start_date]),
      end_date: parse_date_param(filter_params[:end_date])
    )
  end

  def parse_date_param(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end

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
end
