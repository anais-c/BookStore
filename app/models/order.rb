class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order"]
  
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES  
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      #Para pasar los list items del cart al order, establecemos que la id del cart asociada al list item sea nil ya que posteriormente destruiremos ese cart.
      item.cart_id = nil
      #Luego añadimos cada uno d los list items del cart a la colección de list items del order.
      line_items << item
    end
  end  
end
