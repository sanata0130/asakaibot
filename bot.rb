require 'date'
require 'twitter'
require 'foreman'
require 'clockwork'

@client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_OAUTH_TOKEN']
  config.access_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

def week_of_month(date)
  first_week = (date - (date.day - 1)).cweek
  this_week = date.cweek

  if this_week < first_week

    if date.month == 12
      return week_of_month(date - 7) + 1
    else
      return this_week + 1
    end
  end
  return this_week - first_week + 1
end

def update(client, tweet)
  client.update("朝会#{tweet}です。8:30に出社しましょう。")
end

module Clockwork
  handler do |job|
    today = Date.today
    tomorrow = today + 1

    week_today = week_of_month(today)
    week_tomorrow = week_of_month(tomorrow)

    if week_tomorrow == 2 && tomorrow.wday == 1 then
      update(@client, '1日前')
    elsif week_today == 2 && today.wday == 1 then
      update(@client, '当日')
    end
  end

  every(1.day, 'tweet.job', :at => ['5:00', '22:00'])
end
