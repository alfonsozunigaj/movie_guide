module ApplicationHelper

  def analyse(text)

    require 'uri'
    require 'net/http'

    url = URI("https://api.meaningcloud.com/sentiment-2.1")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request.body = "key="+ ENV['MEANING_CLOUD_API_KEY'] +"&lang=en&txt="+ text +"txtf=plain"

    response = http.request(request)
    response.read_body
  end

  def parse_sentiment(grade)
    if grade == "P+"
      return 5
    elsif grade == "P"
      return 4
    elsif grade == "NEU"
      return 3
    elsif grade == "N"
      return 2
    elsif grade == "N+"
      return 1
    else
      return 0
    end
  end
end
