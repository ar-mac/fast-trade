class Category < ActiveRecord::Base
  NAMES = [
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
    
  
  def to_s
    NAMES[name_id]
  end
end
