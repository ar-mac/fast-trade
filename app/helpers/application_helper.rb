module ApplicationHelper
  
  def paginate(collection, options = {})
    defaults = {
      inner_window: 2,
      outer_window: 1
    }
    options = defaults.merge(options)
  
    will_paginate collection, options
  end
  
end
