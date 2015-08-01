class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user
  has_one :shipping_user, class_name: "User", foreign_key: :shipping_id
  has_one :billing_user, class_name: "User", foreign_key: :billing_id

  delegate :default_billing_id, to: :user
  delegate :default_shipping_id, to: :user

  # ------------------- Validations ---------------------

  validates :street_address, :zip_code, :state_id, :user_id,
            :presence => true



  # before_create :check_city

  # ------------------- Methods ---------------------

  # def default_billing?
  #   id == self.user.default_billing_id
  # end

end
