class FilterCriteriaService
  attr_reader :order_ids, :start_date, :end_date

  def initialize(order_ids: nil, start_date: nil, end_date: nil)
    @order_ids = order_ids
    @start_date = start_date
    @end_date = end_date
  end

  def matches?(order)
    matches_order_id?(order[:order_id]) &&
      matches_date?(order[:date])
  end

  private

  def matches_order_id?(order_id)
    return true if order_ids.nil? || order_ids.empty?
    order_ids.include?(order_id)
  end

  def matches_date?(date)
    return true if date.nil?
    return false if start_date && date < start_date
    return false if end_date && date > end_date
    true
  end
end
