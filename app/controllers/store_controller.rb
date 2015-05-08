class StoreController < ApplicationController
  #list of methods or controllers for wich authorization is not required
  skip_before_action :authorize
  def index
    @products = Product.order(:title)
    @cart = current_cart
  end
end
