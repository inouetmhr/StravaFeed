require 'sinatra'

require './strava-feed'

get '/' do
  StravaFeed.new.puts_daily_stats
end
