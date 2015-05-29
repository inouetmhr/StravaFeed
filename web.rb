require 'sinatra'

require './strava-feed'

get '/' do
  content_type 'text/plain'
  since = Time.parse(params['since']) rescue since = nil
  StravaFeed.new.daily_stats(since)
end
