#Integration tests simulate a continuous session between one or more virtual users and our application
require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products  

  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.
  
  test "buying a product" do
    #by the end of the test we want to have added an order to the orders table and a line item to the line_items table, so let's
    #...empty them out before we start.
    LineItem.delete_all
    Order.delete_all
    #we'll be using the ruby book fixture a lot, so let's load it into a local variable.
    ruby_book = products(:ruby)

    #in an integration test we can wander all over the app, so we need to pass in a full (relatibe) URL for the controller and action to be invoked...
    #...for this we use the get method without an action (otherwise, in a functional test we specify just an action when calling get.)
    #first sentence of our story: a user goes to the store index page.
    get "/"
    assert_response :success
    assert_template "index"
    
    #They select a product, adding it to their cart
    #we use Ajax request to add things to the cart, so we use the xml_http_request method to invoke an action. When it returns, we'll check that the cart now contains the requested product.
    
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success 
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product   
    
    #and check out
    
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    #filling in their details on the checkout form.Once they do and they post the data, our app creates the order and redirects to the index page.
    #when the form data is POSTed the save_order action verifies we've been redirected to the index page.
    
    post_via_redirect "/orders",
                      order: { name:     "Anais Casasayas",
                               address:  "123 The Street",
                               email:    "anais@example.com",
                               pay_type: "Check" }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size  
    
    #Then we make sure that an order and its corresponding line imtem have been created into the database. Because we cleared out the orders table at the start of the test, we'll simply verify
    #... that it now contains just our new order.
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Dave Thomas",      order.name
    assert_equal "123 The Street",   order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check",            order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
    #Finally, we verify that the mail itself is correctly addressed and has the expected subject line.
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["anais@example.com"], mail.to
    assert_equal 'Anais Casasayas <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject    
    
  end  
end
