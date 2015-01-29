class Category < ActiveRecord::Base
  NAMES = [
    '', #empty record because category.id starts at 1
    I18n.t('elements.category.main'),
    I18n.t('elements.category.music'),
    I18n.t('elements.category.automotive'),
    I18n.t('elements.category.sport'),
    I18n.t('elements.category.food'),
    I18n.t('elements.category.it'),
    I18n.t('elements.category.business'),
    I18n.t('elements.category.money'),
    I18n.t('elements.category.news'),
    I18n.t('elements.category.science'),
    I18n.t('elements.category.fashion'),
    I18n.t('elements.category.other')
  ]
    
  has_many :offers
  
  def to_s
    NAMES[name_id]
  end
end
