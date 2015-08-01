class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: true

  def value
    product.price*quantity
  end

  def self.revenue(timeframe = nil)
    if timeframe.nil?
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .joins("JOIN orders ON order_contents.order_id=orders.id")
                  .where("checkout_date IS NOT NULL")
                  .first.total
    else
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .joins("JOIN orders ON order_contents.order_id=orders.id")
                  .where("checkout_date > ?", timeframe.days.ago)
                  .first.total
    end
  end
end