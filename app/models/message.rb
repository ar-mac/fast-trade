class Message < ActiveRecord::Base
  
  belongs_to :issue
  
  validates :content,
    presence: :true,
    length: { minimum: 20 }
  validates :issue_id,
    presence: true
    
  
  
end
