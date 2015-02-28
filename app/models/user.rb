class User < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  REGIONS = ["Dolnośląskie", "Kujawsko-pomorskie", "Lubelskie", "Lubuskie",
  "Łódzkie", "Małopolskie", "Mazowieckie", "Opolskie", "Podkarpackie",
  "Podlaskie", "Pomorskie", "Śląskie", "Świętokrzyskie", "Warmińsko-mazurskie",
  "Wielkopolskie", "Zachodniopomorskie"]
  
  validates :name,
    uniqueness: true,
    presence: true,
    length: { in: (3..35) }
  validates :region,
    inclusion: { in: REGIONS }
  validates :password,
    length: { minimum: 7 },
    allow_blank: true
  
  has_secure_password
  
  has_many :offers, dependent: :destroy
  has_many :send_issues, class_name: 'Issue', foreign_key: 'sender_id',
    dependent: :destroy
  has_many :recieved_issues, class_name: 'Issue', foreign_key: 'reciever_id',
    dependent: :destroy
  has_many :send_messages, class_name: 'Message', foreign_key: 'author_id'
  has_many :new_messages, class_name: 'Message', foreign_key: 'new_for_user_id'
  
  
  scope :from_newest, ->{ order(created_at: :desc) }
  scope :by_region, ->(region) { where(region: region) if !(region.nil? || region.empty?) }
  scope :by_status, ->(active) { where(active: active) if !active.nil? }
  
  
  def self.by_search_params(params)
    if params[:active].nil? && params[:inactive].nil?
      active = true
    elsif params[:active] == '1' && params[:inactive] == '1'
      active = nil
    elsif params[:active] == '1'
      active = true
    elsif params[:inactive] == '1'
      active = false
    end
    from_newest.
    by_status(active).
    by_region(params[:region]).
    paginate(page: params[:page])
  end
  
  def deactivate
    self.update_attribute(:active, false)
    self.deactivate_offers
  end
  
  def deactivate_offers
    self.offers.each {|offer| offer.close }
  end
  
  def activate
    self.update_attribute(:active, true)
  end
  
  def short_name
    truncate(name, length: 25, separator: ' ')
  end
  
  def active_offers_count
    self.offers.where('status_id = ?', 1).size
  end
  
  def inactive?
    !self.active?
  end
  
end
