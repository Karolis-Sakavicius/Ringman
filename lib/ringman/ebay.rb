require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'restclient'

class Listing
  @link = ''
  @expiration_time = 0
  @title = ''
  @price = 0

  attr_reader :link, :expiration_time, :title, :price

  def initialize(url)
    @link = url

    fetch_data
  end

  def fetch_data
    begin
      conn = RestClient.get(@link)
      page = Nokogiri::HTML(conn)
      @expiration_time = page.css('.timeMs').first['timems'].to_i / 1000
      title_html = page.css('#itemTitle')
      title_html.at_css('span').remove
      @title = title_html.text
    rescue e
      raise e
    end
  end
end