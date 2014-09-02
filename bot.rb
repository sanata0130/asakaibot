require 'date'
require 'yaml'
require 'twitter'
# require 'clockwork'
# include Clockwork

keys = YAML.load_file('config.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key = keys['twitter']['consumer_key']
  config.consumer_secret = keys['twitter']['consumer_secret']
  config.access_token = keys['twitter']['access_token']
  config.access_token_secret = keys['twitter']['access_token_secret']
end

# handler do |job|
  day = Time.now
  tomorrow = day + 1

  def update(client, tweet)
    client.update("朝会#{tweet}です。8:30に出社しましょう。")
  end

  if 6 < tomorrow.mday && tomorrow.mday < 15 && day.wday == 0 then
    update(client, '1日前')
  elsif 7 < tomorrow.mday && tomorrow.mday < 16 && day.wday == 1 then
    update(client, '当日')
  else
    update(client, 'test')
  end
# end

# every(1.day, 'tweet.job')
