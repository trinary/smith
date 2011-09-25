
require 'yaml'

class Settings

  SettingsAttrs = %w( username usertoken room admins ignores timestamp )
  attr_accessor *SettingsAttrs

  def self.build!(room_name)
    file = YAML::load(File.open('conf/configuration.yml'))

    Settings.new do |setting|
      setting.username  = file["#{room_name}"]['user']['name']
      setting.usertoken = file["#{room_name}"]['user']['token']
      setting.room      = room_name
      setting.admins    = file["#{room_name}"]['admins']
      setting.ignores   = file["#{room_name}"]['ignores']
      setting.timestamp = Time.now.utc
    end
  end

  def initialize(&block)
    SettingsAttrs.each { |attr| self.__send__ "#{attr}=", attr }

    yield(self)
  end
end
