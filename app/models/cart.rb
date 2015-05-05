class Cart < ActiveRecord::Base
  
  has_many :line_items, dependent: :destroy
  
  def add_product(product_id)
                                                          #ActiveRecord notice the undefined method 'find_by_product_id' and spots that it starts with find_by and ends with the name of the column. It constructs a finder method for us.
                                                          #La tabla line_items tiene una columna 'product_id'. Aquí se dice que dado el id del producto, encuentra la fila correspondiente (line_item) a ese id y que nombres esa fila como current_item.
    current_item = line_items.find_by_product_id(product_id)
                                                          #Si esa fila (objeto), a la que hemos dado el nombre de current_item, ya existe, entonces sumamos 1 a la casilla de la columna quantity.
    if current_item  
      
      current_item.quantity += 1
                                                          #Si la fila current_item no existe, la creamos. Dado el id del producto creamos uno de los tantos line_items, y a esa fila (objeto line_item) le llamamos current_item.
    else
      
      current_item = line_items.build(product_id: product_id)
      
    end
                                                          
    current_item
    
  end
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
  
end
