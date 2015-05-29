#!/bin/env ruby

require 'logger'
require 'date'
require 'strava/api/v3'

class StravaFeed
  def initialize(access_token = nil, logger = nil)
    if logger then
      @logger = logger
    else
      @logger = Logger.new(STDOUT) 
      @logger.level = Logger::INFO
    end
    @fileout = STDOUT
    access_token ||= ENV['strava_token']
    @logger.info("access_token: #{access_token}")
    @client = Strava::Api::V3::Client.new(:access_token => access_token, 
                                          :logger => @logger)
  end
  
  def get_activities(since=nil)
    # http://strava.github.io/api/v3/activities/
    if since 
      arg = {:after => since.to_i}
      @activities = @client.list_athlete_activities(arg)
    else
      @activities = @client.list_athlete_activities
    end
  end

  def puts_activities(since=nil)
    get_activities(since)
    puts "#start_time, km" # csv format header
    @activities.map{|act| 
      date = DateTime.parse(act["start_date"]).new_offset(Rational(9,24))
      
      @fileout.print "#{date}, " 
      @fileout.puts  "#{act["distance"]/1000.0}" 
    }
  end
  #puts_activities

  def daily_stats(since=nil)
    get_activities(since)
    offset = Rational(9,24)
    stats = Hash.new(0.0)

    output = "#date, km\n" # csv format header
    @activities.map{|act| 
      datetime = DateTime.iso8601(act["start_date"])
      date = (datetime + offset).to_date
      stats[date] += act["distance"]/1000.0
    }
    #p stats
    #stats.each{|date, km| @fileout.puts "#{date}, #{km}"  }

    min, max = stats.keys.minmax
    (min..max).each{|date|
      #@fileout.puts "#{date}, #{stats[date]}" 
      output += "#{date}, #{stats[date]}\n" 
    }
    output
  end
  #puts_daily_stats
end

# Run only when TopLevel 
if (self.to_s == "main") then
  #since = Time.parse("2015/3/01")
  since = nil
  puts StravaFeed.new.daily_stats(since)
end
  
