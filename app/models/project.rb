class Project < ActiveRecord::Base
  validates :progress,
    numericality: true,
    inclusion: { in: (0..100) }
    
  def bar_class
    case progress
    when (80..100) then 'progress-bar-success'
    when (50..79) then 'progress-bar-info'
    when (30..49) then 'progress-bar-warning'
    else
      'progress-bar-danger'
    end
  end
end
