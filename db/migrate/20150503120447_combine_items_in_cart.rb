class CombineItemsInCart < ActiveRecord::Migration
  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the number of each product in the cart
      #Agrupa todos los line items del cart que tengan el mismo id del producto y haz la suma de la columna quantity con ellos.
      sums = cart.line_items.group(:product_id).sum(:quantity)

      #De las sumas que hemos obtenido, queremos desglosar el product_id y la cantidad de cada una
      sums.each do |product_id, quantity|
        
        #Para aquellas sumas de grupos que nos den una cantidad mayor que 1:
        if quantity > 1
          # remove individual items
          #Borra todos los line items del cart que tengan el mismo product_id
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single item
          #crea uno de los tantos line items del cart a partir del product_id indicado y llámalo item.
          cart.line_items.create(product_id: product_id, quantity: quantity)

        end
      end
    end
  end
  
  #Un principio de las migraciones es que deben poder ser reversibles, por lo que debemos incorporar un método que deshaga el método anterior en caso necesario.
  # split items with quantity>1 into multiple items
  def down
   
    #En el modelo LineItem, para cada una de las filas line_item donde la casilla de la columna quantity sean mayor que uno:
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      #para esas filas line_item con casilla quantity>1, repite tantas veces como indique la casilla quantity lo siguiente:
      line_item.quantity.times do 
                                                  #Crear un nuevo line item, cuyo cart_id y product_id sean los mismos que en el line_item con la casilla quantiy > 1.                   
        LineItem.create cart_id: line_item.cart_id,
          product_id: line_item.product_id, quantity: 1
      end
      
      #una vez hemos creado tantos line items iguales, eliminamos el line_item que agrupaba a todos los que tenían el mismo product_id, es decir, el que tenia la casilla quantity>1
      # remove original item
      line_item.destroy
    end
  end  
  
end
