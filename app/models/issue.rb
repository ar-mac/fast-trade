class Issue < ActiveRecord::Base
  
  belongs_to :reciever, class_name: 'User', foreign_key: 'reciever_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :offer
  has_many :messages, dependent: :destroy
  
  validates :title,
    presence: true,
    length: { minimum: 5 }
  validates :reciever_id,
    presence: true
  validates :sender_id,
    presence: true
  validates :offer_id,
    presence: true
  
end
