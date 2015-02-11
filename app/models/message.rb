class Message < ActiveRecord::Base
  
  validates :content,
    presence: :true,
    length: { minimum: 20 }
  validates :issue_id,
    presence: true
  
end
