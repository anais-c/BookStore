class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  
  private
  
    def current_cart
      #A partir del id que encontramos dentro del hash session cuya key es :cart_id, encuentra el cart correspondiente a esa id en la tabla carts.
      Cart.find(session[:cart_id])
      #Si no existe tal cart, creamos uno (un nuevo row en la tabla Cart).
      #Del nuevo row, seleccionamos la casilla del id (cart.id) e introducimos ese valor en el hash session.
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  
end
