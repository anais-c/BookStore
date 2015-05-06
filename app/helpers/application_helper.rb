module ApplicationHelper
  
  def hidden_div_if(condition, attributes = {}, &block)
    
    if condition
      attributes["style"] = "display: none"
    end
    
    #content_tag is a helper that pass the output from the &block above in the hidden_dib method
    content_tag("div", attributes, &block)
  end  
  
end
