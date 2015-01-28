class Offer < ActiveRecord::Base
  
  STATUS = [
    I18n.t('activerecord.attributes.offer.status.pending'), 
    I18n.t('activerecord.attributes.offer.status.active'),
    I18n.t('activerecord.attributes.offer.status.closed')
  ]
  
  validates :title,
    presence: true,
    uniqueness: :true,
    length: { minimum: 5, maximum: 40 }
  validates :content,
    presence: true,
    length: { minimum: 20 }
  validates :status_id,
    presence: true,
    numericality: true,
    inclusion: { in: (0..2) }
  validates :category_id,
    presence: true,
    numericality: true,
    inclusion: { in: (0...Category::NAMES.count)}
  validates :user_id,
    presence: true
  validate :valid_in_the_future
  
  
  def status
    STATUS[status_id]
  end
  
  def valid_in_the_future
    if valid_until < Time.zone.today
      errors.add(:valid_until, I18n.t('activerecord.errors.offer.valid_in_the_past'))
    end
  end
  
  def self.update_expiration
    #sets status 2 - closed, when offer expires
    self.update_all('status = 2', ['valid_until < ?', Time.zone.today])
  end
  
end
