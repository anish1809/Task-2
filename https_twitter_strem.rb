
require 'rubygems'
require 'net/http'
require 'net/http/oauth'
require 'json'
require 'multi_json'

class Twitter
  attr_accessor :username, :datetime, :tweet

  def self.create_twitts(hash)
    twit = Twitter.new
    twit.username = hash["user"]["screen_name"] if hash["user"]
    twit.datetime = hash["created_at"]
    twit.tweet = hash["text"]
    twit
    puts twit.inspect
  end

end

uri = URI('https://stream.twitter.com/1.1/statuses/sample.json?filter_level=low')
http = Net::HTTP.new('stream.twitter.com', Net::HTTP.https_default_port)

Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri
  Net::HTTP::OAuth.sign!(http, request, {
    consumer_key: "S0NNIbEbNhSZnXvPWU6IVw1Rh",
    consumer_secret: "9axzKqcNGsdlQTkXf5az5EyPUsnLYaZEQAm2HyvpwnlNYjDVRL",
    token: "784444422-5QrEstqGrsHtTKEXzzBunL6XZN7B7mseRglLiTCl",
    token_secret: "35MWT8016AhJPyFWami2fdyLx3FeYI4AdT4thOq4MmgvX"
  })
  http.request request do |response|
    response.read_body do |chunk|
      tweets =  chunk.split(/\r\n/)
      tweets.each do |tweet|
        begin
          hash = MultiJson.decode(tweet)
          Twitter.create_twitts(hash)
        rescue MultiJson::DecodeError
        end
      end  
    end
  end

end


