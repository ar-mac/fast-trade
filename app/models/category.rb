class Category < ActiveRecord::Base
  NAME_CODES = [
    'elements.category.main',
    'elements.category.music',
    'elements.category.automotive',
    'elements.category.sport',
    'elements.category.food',
    'elements.category.it',
    'elements.category.business',
    'elements.category.money',
    'elements.category.news',
    'elements.category.science',
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
