class Message < ActiveRecord::Base
  
  belongs_to :issue
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  
  validates :content,
    presence: :true,
    length: { minimum: 5 }
  validates :issue_id,
    presence: true
  validates :author_id,
    presence: true
    
  
  
end
