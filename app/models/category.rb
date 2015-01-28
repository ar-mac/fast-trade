class Category < ActiveRecord::Base
  NAMES = [
    I18n.t('links.categories.main'),
    I18n.t('links.categories.music'),
    I18n.t('links.categories.automotive'),
    I18n.t('links.categories.sport'),
    I18n.t('links.categories.food'),
    I18n.t('links.categories.it'),
    I18n.t('links.categories.business'),
    I18n.t('links.categories.money'),
    I18n.t('links.categories.news'),
    I18n.t('links.categories.science'),
    I18n.t('links.categories.fashion'),
    I18n.t('links.categories.other')
  ]
    
  
  def name
    NAMES[name_id]
  end
end
