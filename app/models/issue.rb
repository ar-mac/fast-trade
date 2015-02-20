class Issue < ActiveRecord::Base
  
  belongs_to :reciever, class_name: 'User', foreign_key: 'reciever_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :offer
  has_many :messages, dependent: :destroy
  
  validates :reciever_id,
    presence: true
  validates :sender_id,
    presence: true
  validates :offer_id,
    presence: true
  validate :one_issue_per_sender
  
  def one_issue_per_sender
    #fails if sender had already issue in given offer
    if Issue.where('offer_id = ? AND sender_id = ?', self.offer_id, self.sender_id).first
      
      errors.add(:base, I18n.t('activerecord.errors.models.issue.exist_for_sender_offer'))
      return false
    else
      
    end
  end
  
  def sender_deactivate
    self.update_attribute(:active_for_sender, false)
  end
  
  def reciever_deactivate
    self.update_attribute(:active_for_reciever, false)
  end
  
  def both_deactivate?
    return true if !active_for_sender? && !active_for_reciever?
  end
  
  
end
