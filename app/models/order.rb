class Order < ApplicationRecord
  include ActiveModel::Validations
  validates_with EnoughProductsValidator
  
  before_validation :set_total!

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  def set_total!
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |line_item|
      placement = placements.build(
        product_id: line_item[:product_id],
        quantity: line_item[:quantity]
      )
      yield placement if block_given?
    end
  end

end
