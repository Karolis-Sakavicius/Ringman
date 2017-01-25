require 'rubygems'
require_relative 'ebay'

class ListingsManager
  def initialize
    @listings = []
  end

  def add_listing(url, notify_times, options)
    listing = { listing: Listing.new(url), notify_times: notify_times, options: options }
    @listings.push(listing)
  end

  def run
    @runner_thread = Thread.new do
      loop do
        notify
        sleep 1
      end
    end.run
    gets
  end

  private def notify
    @listings.each do |listing|
      time_diff = Time.at(listing[:listing].expiration_time) - Time.now

      listing[:notify_times].each do |notify_time|
        if time_diff <= notify_time
          # NOTIFICATION
          listing.notify_times.delete(notify_time)
        end
      end
    end
  end

  private def kill_runner
    @runner_thread.kill
  end
end