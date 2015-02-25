class Category < ActiveRecord::Base
  NAME_CODES = [
    'elements.category.estates',
    'elements.category.automotive',
    'elements.category.electronics',
    'elements.category.sport',
    'elements.category.food',
    'elements.category.hobby',
    'elements.category.for_children',
    'elements.category.animals',
    'elements.category.services',
    'elements.category.music',
    'elements.category.fashion',
    'elements.category.other'
  ]
    
  has_many :offers
  
  def to_s
    I18n.t(name_code)
  end
  
  def name
    I18n.t(name_code)
  end
  
end
