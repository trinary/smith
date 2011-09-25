
require 'chronic'

require 'pry'
require 'awesome_print'

$:.unshift(File.join(File.dirname(__FILE__), "/../lib"))
require 'smith/builder'
require 'smith/message'

module Smithbot

  def self.room(room, usertoken)
    campfire = Tinder::Campfire.new 'absperf', :token => usertoken
    @room = campfire.find_room_by_name "#{room}"
  end

  def self.message(msg)
    @message = Message.build! msg
  end

  def self.launch(settings)
    room = Smithbot.room(settings.room, settings.usertoken)
    room.speak "I am now online."

    messages = room.listen do |msg|
      begin
        message = Smithbot.message(msg)

        if message.type.eql? 'EnterMessage'
          room.speak "Welcome to the #{room.name} chat room, #{message.username}!"
        end

        thread = Thread.new {
          if message.body.match '^smith:\s'
            Smithbot.run_command(message, room, settings)
          else
            Smithbot.run_event(message, room, settings)
          end
        } unless message.body.nil?
        thread.join

      $stdout.flush

      rescue Exception => err
        ap err.message
        ap err.backtrace

        room.speak "SMITH_ERROR: #{err.message} (#{err.backtrace[0]})"
      end
    end
  end

  def self.run_command(message, room, settings)
    if message.body.include? 'help'
      room.speak "If you would like me to run a command, please start your message with '@smith' followed by your command (ex. '@smith help'). In addition to commands, I also can respond to misc campfire events on my own."
      room.speak "Available commands: 'sysinfo', 'userinfo <name>', 'time', 'hello', 'help'"

    elsif message.body.include? 'userinfo'
      user = message.body.gsub(/smith:\suserinfo\s/, '')
      userinfo = room.users.map { |u| u if u.name.downcase.eql? user }.compact.first
      infoblock = Builder.build_userinfo userinfo

      room.speak "#{userinfo.avatar_url}"
      room.paste "#{infoblock.join("\n")}"

    elsif message.body.include? 'sysinfo'
      infoblock = Builder.build_sysinfo room, settings
      room.paste "#{infoblock.join("\n")}"

    elsif message.body.include? 'deploy ops-proc01'
      t = Thread.new {
        system("su ubuntu ; /home/ubuntu/run_chef.sh")
      }
      t.join

    elsif message.body.include? 'hello'
      room.speak "Hello #{message.username.capitalize.split("\s").first}!"

    elsif message.body.include? 'time'
      room.speak "#{Time.now}"
    end
  end

  def self.run_event(message, room, settings)
    if message.body.match '^[Pp]ing$'
      room.speak "pong"

    elsif message.body.match '^[Nn]yan'
      room.speak 'http://fi.somethingawful.com/safs/smilies/0/e/nyan.001.gif'

    elsif message.body.match '^[Ii]\s[Ll]ove\s[Yy]ou\s[Ss]mith'
      room.speak 'http://i.somethingawful.com/forumsystem/emoticons/emot-ughh.gif'
      room.speak "Can't we just be friends?"
    end
  end
end
