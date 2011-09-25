
require 'rubygems'

require 'tinder'

require 'pry'
require 'awesome_print'

$:.unshift(File.join(File.dirname(__FILE__), "/../lib"))
require 'smith/settings'
require 'smith/smithbot'

class Smith

  VERSION = "0.1.0"

  $stdout.reopen(File.open("log/smith.log", "w+"))
  $stderr.reopen(File.open("log/smith.log", "w+"))

  def start(args)
    room_name = args[0]
    puts "Starting Smithbot in the #{room_name} chat room..."
    settings = Settings.build! room_name

    Smithbot.launch settings
  end

  def stop(arg)
    puts "Stopping server..."
  end

  private

  def execute(cmd)
    puts `#{cmd}`
  end
end
