class Project < ActiveRecord::Base
  validates :progress,
    numericality: true,
    inclusion: { in: (0..100) }
end
