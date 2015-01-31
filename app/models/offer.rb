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
  
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category
  
  scope :by_status, ->(status) { where(status_id: status) if status && !status.empty?}
  scope :by_region, ->(region) { joins(:owner).where('region = ?', region) if region && !region.empty? }
  scope :by_max_valid_date, ->(date) { where('valid_until <= ?', date) if date }
  scope :by_min_valid_date, ->(date) { where('valid_until >= ?', date) if date }
  scope :by_category, ->(c_id) { where('category_id = ?', c_id) if c_id && !c_id.empty? }
  scope :from_newest, ->{ order(created_at: :desc)}
  
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
  
  
  def self.by_search_params(params, admin)
    #create quite complex search query from sended params.
    #n is number of objects per page (pagination)
    params[:status] = '1' if !admin
    begin
      min_date = Date.civil(
        params[:d_min][:"(1i)"].to_i,
        params[:d_min][:"(2i)"].to_i,
        params[:d_min][:"(3i)"].to_i
      )
    rescue
      min_date = nil
    end
    begin
      max_date = Date.civil(
        params[:d_max][:"(1i)"].to_i,
        params[:d_max][:"(2i)"].to_i,
        params[:d_max][:"(3i)"].to_i
      )
    rescue
      max_date = nil
    end
      
    from_newest.
    by_status(params[:status]).
    by_region(params[:region]).
    by_min_valid_date(min_date).
    by_max_valid_date(max_date).
    by_category(params[:c_id]).
    includes(:owner, :category).
    paginate(page: params[:page])
  end
  
  def activate
    self.update_attribute(status: 1)
  end
  
  def close
    self.update_attribute(status: 2)
  end
  
  def pending
    self.update_attribute(status: 0)
  end
  
end
