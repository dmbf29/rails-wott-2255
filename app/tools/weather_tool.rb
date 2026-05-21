require 'open-uri'

class WeatherTool < RubyLLM::Tool
  # this is telling the AI when to use the tool
  description "Get the weather for a specific location"
  # this are the attributes the tool needs in order to run
  param :latitude, desc: "Latitude of a specific location (eg. 35.6895)"
  param :longitude, desc: "Longitude of a specific location (eg. 139.6917)"

  def execute(latitude:, longitude:)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m,wind_speed_10m"
    json = URI.parse(url).read
    # give the RubyLLM chat a JSON of the weather in a specific lat/long
    return JSON.parse(json)
  end
end
