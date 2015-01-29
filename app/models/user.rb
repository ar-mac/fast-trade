class User < ActiveRecord::Base
  
  REGIONS = ["Dolnośląskie", "Kujawsko-pomorskie", "Lubelskie", "Lubuskie",
  "Łódzkie", "Małopolskie", "Mazowieckie", "Opolskie", "Podkarpackie",
  "Podlaskie", "Pomorskie", "Śląskie", "Świętokrzyskie", "Warmińsko-mazurskie",
  "Wielkopolskie", "Zachodniopomorskie"]
  
  validates :name,
    uniqueness: true,
    presence: true,
    length: { in: (3..35) }
  validates :region,
    inclusion: { in: REGIONS, message: 'to nie jest województwo' } #I18n.t('errors.user.invalid_region') }
  validates :password,
    length: { minimum: 7 },
    allow_blank: true
  
  has_secure_password
  
  has_many :offers
  
  scope :from_newest, ->{ order(created_at: :desc) }
  scope :by_region, ->(region) { where(region: region) if region && !region.empty? }
  
end
