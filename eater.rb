# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'

module BillSplit
  def self.is_money?(value)
    if value.is_a? String then
      if value.length == 0 then
        false
      else
        first_char = value[0]
        rest = value[1 ... value.length]
        puts "first_char: #{first_char}"
        puts "rest: #{rest}"
        symbol_check = first_char == '$'
        puts "first_char == $: #{symbol_check}"
        number_check = (!!Float(rest) rescue false)
        puts "number_check: #{number_check}"
        symbol_check && number_check 
      end
    else
      false
    end
  end
end

# logic to get the environment variables. It returns a hash of the relevant
# environment variables that are used by the bot to establish a websocket
# connection to the server
def query_env
  bot_token = ENV['DISCORD_BOT_TOKEN']
  {:bot_token => bot_token}
end

def main
  curr_env = query_env

  # This creates the bot
  bot = Discordrb::Commands::CommandBot.new token: curr_env[:bot_token], prefix: 'eat!'

  # Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
  # done once, afterwards, you can remove this part if you want
  puts "This bot's invite URL is #{bot.invite_url}"
  puts 'Click on it to invite it to your server.'

  # This method call adds an event handler that will be called on any message that exactly contains the string "Ping!".
  # The code inside it will be executed, and a "Pong!" response will be sent to the channel.
  bot.command(:random,
              description: 'this is a testing function that returns a random number between the next two parameters'
             ) do |event, min, max|
    if min == nil and max == nil then
      rand 
    elsif min != nil and max == nil then
      rand(0 .. min.to_i)
    elsif min != nil and max != nil then
      rand(min.to_i .. max.to_i)
    end
  end
  bot.command(:is_money?,
              description: 'determines if the string passed is a valid money symbol'
             ) do |event, str|
     BillSplit.is_money?(str) ? "#{str} is valid money" : "#{str} is not valid money"
  end

  # Starting the bot runtime
  bot.run

end


main if __FILE__ == $PROGRAM_NAME
