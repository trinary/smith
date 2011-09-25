
module Builder

  def self.build_userinfo(userinfo)
    [ "Name: #{userinfo.name}",
      "User ID: #{userinfo.id}",
      "Email: #{userinfo.email_address}",
      "Avatar: #{userinfo.avatar_url}",
      "Created: #{userinfo.created_at}" ]
  end

  def self.build_sysinfo(room, settings)
    [ "Smith Version: #{Smith::VERSION}",
      "Ruby Version: #{RUBY_VERSION}",
      "Smith Admins: #{settings.admins.map { |a| a['name'] }.join(', ')}",
      "Smith Ignores: #{settings.ignores.map { |i| i['name'] }.join(', ')}",
      "Room ID: #{room.id}",
      "Room: #{room.name}",
      "Current Users: #{room.users.map { |u| u.name }.join(', ')}",
      "Current Time: #{Time.now.utc}",
      "Start Time: #{settings.timestamp}" ]
  end
end
