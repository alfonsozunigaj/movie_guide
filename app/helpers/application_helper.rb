module ApplicationHelper

  require 'httparty'
  require 'nokogiri'

  class Scraper

    attr_accessor :parse_page

    def initialize(url)
      doc = HTTParty.get(url)
      @parse_page ||= Nokogiri::HTML(doc)
    end

    def get_titles
      item_container.css("h1.css-18irvwu, h1.ejekc6u0").css("span").children.map {|title| title.inner_text }.compact
    end

    def get_texts
      item_container.css("div.css-18sbwfn, div.StoryBodyCompanionColumn").css("p").children.map {|text| text.text }.compact
    end

    private
    def item_container
      parse_page.css("article.Story-story--2QyGh, article.css-1j0ipd9")
    end


  end

  def analyseNYT(url)
    scraper = Scraper.new(url)
    texts = scraper.get_texts

    full_text = ""

    (0..texts.size).each do |index|
      full_text << "#{texts[index]} "
      if full_text.split.size > 400
        break
      end
    end
    parse_sentiment(analyse(full_text)['score_tag']).to_s
  end

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
    ActiveSupport::JSON.decode(response.read_body.to_s)
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
