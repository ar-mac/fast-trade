class Message < ActiveRecord::Base
  
  after_create :set_as_new
  
  belongs_to :issue
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :new_for_user, class_name: 'User', foreign_key: 'new_for_user_id'
  
  validates :content,
    presence: :true,
    length: { minimum: 5 }
  validates :issue_id,
    presence: true
  validates :author_id,
    presence: true
    
  def set_as_new
    new_for_id = (self.issue.reciever.id == author.id ? self.issue.sender.id : self.issue.reciever.id)
    self.update_attribute(:new_for_user_id, new_for_id)
  end
  
  def clear_being_new_for(user)
    if self.new_for_user_id == user.id
      self.update_attribute(:new_for_user_id, nil)
      self.update_attribute(:read_at, Time.zone.now)
    end
  end
  
  def created_datetime
    I18n.l(created_at, format: :message_send)
  end
  
  def read_datetime
    if read_at.nil?
      I18n.t('elements.message.not_read_yet')
    else
      I18n.l(read_at, format: :message_read)
    end
  end
  
end
