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
  
  belongs_to :user
  belongs_to :category
  
  scope :by_status, ->(status) { where(status_id: status) if status && !status.empty?}
  
  def status
    STATUS[status_id]
  end
  
  def valid_in_the_future
    if valid_until < Time.zone.today
      errors.add(:valid_until, I18n.t('activerecord.errors.offer.valid_in_the_past'))
    end
  end
  
  def self.update_expiration
    #this method is triggered at 00:00 am by whenever config/scheldule.rb
    #sets status 2 - closed, when offer expires
    self.update_all('status = 2', ['valid_until < ?', Time.zone.today])
  end
  
  def self.build(params)
    if params[:status]
      by_status(params[:status])
    end
    paginate(page: params[:page])
  end
  
end
