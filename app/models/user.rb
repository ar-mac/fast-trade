class User < ActiveRecord::Base
  
  REGIONS = ["Dolnośląskie", "Kujawsko-pomorskie", "Lubelskie", "Lubuskie",
  "Łódzkie", "Małopolskie", "Mazowieckie", "Opolskie", "Podkarpackie",
  "Podlaskie", "Pomorskie", "Śląskie", "Świętokrzyskie", "Warmińsko-mazurskie",
  "Wielkopolskie", "Zachodniopomorskie"]
  
  validates :name,
    uniqueness: true,
    presence: true,
    length: { in: (3..20) }
  validates :region,
    inclusion: { in: REGIONS, message: 'to nie jest województwo' } #I18n.t('errors.user.invalid_region') }
  validates :password,
    length: { minimum: 7 },
    allow_blank: true
  
  has_secure_password
  
  has_many :offers
  
  scope :active, -> { where(active: true) }
  scope :from_newest, ->{ order(created_at: :desc) }
  
end
