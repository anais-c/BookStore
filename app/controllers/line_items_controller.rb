class LineItemsController < ApplicationController
  
  #Include CurrentCart module
  include CurrentCart
  
  #Find the shopping cart for the current session or creating one if there isn't one there alredy.
  #The set_cart method (wich sets the value of the @cart, that is the value of the current cart) is to be involved before the create action (a method is called before an action)
  before_action :set_cart, only: [:create]
  #set de value of the @line_item instance variable before the show, edit, update ar destroy actions
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  #Cuando apretamos el botón "Add to Cart", estamos creando un nuevo line_item a partir de un producto. Para crearlo primero necesitamos saber...
  #...el id del producto. Después lo asociamos también a una cart determinada @cart.
  def create
    @cart = current_cart
    #local variable: product, because is no need to make this available to the view  
    product = Product.find(params[:product_id])
    #Del hash params, encuentra el valor id asociado a la key :product_id y busca en el modelo Product el objeto asodiado a esa id y dale el nombre de 'product'.
    #Con el 'product' que acabamos de encontrar, creamos una relación entre el objeto @cart y el 'product'. Guardamos el resultado en una variable de instancia @line_item.
    #En el modelo line_items.rb vemos que un line_item pertenece a un produco y a un cart. Aquí establecemos esa relación:
    #Un determinado producto genera uno de los tantos line_items que pertenecen al cart. Ese line_item lo guardamos en la variable @line_item.
    @line_item = @cart.line_items.build(product: product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart, notice: 'Line item was successfully created.' }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
