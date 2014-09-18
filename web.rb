require 'sinatra'

require './strava-feed'

get '/' do
  StravaFeed.new.daily_stats
end
