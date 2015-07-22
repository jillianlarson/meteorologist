require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================
    @geo_url = "https://maps.googleapis.com/maps/api/geocode/json?address="+url_safe_street_address

    require 'json'
    parsed_data = JSON.parse(open(@geo_url).read)

    @latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]

    @longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

   latstring = @latitude.to_s
   longstring = @longitude.to_s

   @joint_url = "https://api.forecast.io/forecast/6ac4aa0b134529ccd14dd9d6dfa82e7b/"+latstring+","+longstring
    require 'json'
    parsed_joint = JSON.parse(open(@joint_url).read)

    @current_temperature = parsed_joint["currently"]["temperature"]

    @current_summary = parsed_joint["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_joint["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_joint["hourly"]["summary"]

    @summary_of_next_several_days = parsed_joint["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
