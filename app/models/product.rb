class Product < ActiveRecord::Base
  has_many :order_contents
  has_many :orders, through: :order_contents

  has_many :users, through: :orders

  belongs_to :category

  validates :price,
            :numericality => { :greater_than => 0,
                               :less_than_or_equal_to => 10000,
                               :message => "Must be between 0 and 10000." }
  validates :sku,
              :uniqueness => {:message => "Needs to be unique"}

  validates :name, :description, :price, :presence => { :message => "Can not be blank" }

  def category_name
    category.name
  end

  def find_by_id(num)
    find(num).first
  end

  def times_ordered
    self.orders.where("checkout_date IS NOT NULL").count
  end

  def in_cart
    self.orders.where("checkout_date IS NULL").count
  end

  def self.product_count(timeframe = 1000000)

    Product.where("created_at > ?", timeframe.days.ago).count

  end

  def self.products_in_category(cat_id)
    Product.where("category_id = ?", cat_id)
  end

  def self.category_items(cat_id)
    self.products_in_category(cat_id).select("id, name")
  end

  def self.delete_category(cat_id)
    Product.where("category_id = ?", cat_id)
            .update_all(:category_id => nil)
  end

end
