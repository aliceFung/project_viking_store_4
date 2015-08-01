class User < ActiveRecord::Base
  validates :first_name, :last_name, :email,
            :length => {:in => (1..64), :message => "Must be between 1 and 64 characters."}
  validates :email, :format => {:with => /@/}

# ----------------- Associations -------------------


  has_many :addresses #, dependent: :destroy #before_destroy/around_destroy to keep addresses associated with orders

  has_many :credit_cards, dependent: :destroy

  has_many :orders

  has_many :order_contents, through: :orders
  has_many :products, through: :order_contents

  belongs_to :default_shipping_address_id,
              class_name: "Address",
              foreign_key: :shipping_id
  belongs_to :default_billing_address_id,
              class_name: "Address",
              foreign_key: :billing_id

  has_many :cities, through: :addresses
  has_many :states, through: :addresses

  accepts_nested_attributes_for :addresses, :reject_if => :all_blank, :allow_destroy => :true


  # ------------------------ Methods -----------------

  def shopping_cart
    self.orders.where("checkout_date IS NULL").first || self.orders.create(user_id: self.id)
  end

  def self.find_by_email(email_str)
    self.where("email = ?", email_str).first
  end

  # Last 7 Days

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def orders_checked_out
    self.orders.where("checkout_date IS NOT NULL").order("checkout_date DESC")
  end

  def orders_in_cart
    self.orders.where("checkout_date IS NULL")
  end

  def self.user_count(timeframe = nil)

    if timeframe.nil?
      return User.all.length
    else
      return User.where("created_at > ?", timeframe.days.ago).count
    end
  end

  def self.top_user_location(scope, num=3)
    # Finds top user
    if scope == 'state'
      User.select("COUNT(*) AS num_of_users, states.name")
          .joins("JOIN addresses ON users.billing_id=addresses.id")
          .joins("JOIN states ON addresses.state_id=states.id")
          .group("states.name")
          .order("num_of_users DESC")
          .limit(num)
    elsif scope == 'city'
      User.select("COUNT(*) AS num_of_users, cities.name")
          .joins("JOIN addresses ON users.billing_id=addresses.id")
          .joins("JOIN cities ON addresses.city_id=cities.id")
          .group("cities.name")
          .order("num_of_users DESC")
          .limit(num)
    end
  end

  def self.highest_value(scope = "single")
    # Finds highest revenue from individual user
    # Returns highest order if "single", returns total revenue from user if "total"
    # Returns highest average order value for user if "average"
    if scope == 'single'
      group_by = "users.id, orders.id"
    elsif scope == 'total'
      group_by = "users.id"
    else
      raise ArgumentError.new("Invalid Input")
    end

    User.select("ROUND(SUM(quantity * products.price), 2) AS total, (users.first_name||' '||users.last_name) AS user_name")
        .joins("JOIN orders ON orders.user_id=users.id")
        .joins("JOIN order_contents ON order_contents.order_id=orders.id")
        .joins("JOIN products ON order_contents.product_id=products.id")
        .where("checkout_date IS NOT NULL")
        .group(group_by)
        .order("total DESC")
        .first
  end


  def self.highest_avg_order_value
      # subquery =
      # User.select("ROUND(SUM(quantity * products.price), 2) AS order_total, users.id AS user_num, users.first_name, users.last_name")
      #     .joins("JOIN orders ON orders.user_id=users.id")
      #     .joins("JOIN order_contents ON order_contents.order_id=orders.id")
      #     .joins("JOIN products ON order_contents.product_id=products.id")
      #     .where("checkout_date IS NOT NULL")
      #     .group("users.id, order_id")
      # subquery.select("AVG(order_total) AS average, user_num, users.first_name || users.last_name")
      #         .group("user_num")
      #         .order("average DESC")
      #         .limit(10)
      User.find_by_sql("
        SELECT round(AVG(order_total), 2) AS average, user_name
          FROM (
            SELECT SUM(quantity * products.price) AS order_total, users.id as user_id, (users.first_name||' '||users.last_name) AS user_name
              FROM users JOIN orders ON orders.user_id=users.id
                         JOIN order_contents ON order_contents.order_id=orders.id
                         JOIN products ON order_contents.product_id=products.id
              WHERE checkout_date IS NOT NULL
              GROUP BY users.id, orders.id
          )
          GROUP BY user_id
          ORDER BY average DESC
          LIMIT 1
        ").first
  end

  def self.most_order
    User.select("COUNT(orders.id) AS num_of_orders, (users.first_name||' '||users.last_name) AS user_name")
        .joins("JOIN orders ON users.id=orders.user_id")
        .where("checkout_date IS NOT NULL")
        .group("users.id")
        .order("num_of_orders DESC")
        .first
  end
end











