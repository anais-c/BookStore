class ApplicationController < ActionController::Base
  #the before_action causes the authorize method to be invoked before every action in our application
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end  
  
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
