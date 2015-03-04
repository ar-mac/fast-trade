class DateCivilization
  
  
  def initialize(params)
    @date_params = params
  end
  
  def civilize
    begin
      date = Date.civil(
        @date_params[:"(1i)"].to_i,
        @date_params[:"(2i)"].to_i,
        @date_params[:"(3i)"].to_i
      )
    rescue
      date = nil
    ensure
      return date
    end
  end
  
  
end