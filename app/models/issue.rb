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
  
  
  def sender_deactivate
    self.update(active_for_sender: false)
  end
  
  def reciever_deactivate
    self.update(active_for_reciever: false)
  end
  
  def both_deactivate?
    return true if !active_for_sender && !active_for_reciever
  end
  
  
end
