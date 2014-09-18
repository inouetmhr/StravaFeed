require 'sinatra'

require './strava-feed'

get '/' do
  content_type 'text/plain'
  StravaFeed.new.daily_stats
end
