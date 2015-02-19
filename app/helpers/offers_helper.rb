module OffersHelper
  
  def statuses_for_options
    statuses = []
    Offer::STATUS.each_with_index {|status, index| statuses << [I18n.t(status), index]}
    return statuses
  end
  
end
