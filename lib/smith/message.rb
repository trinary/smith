
class Message

  MessageAttrs = %w( id type body room_id created_at user_id username                                             user_type user_admin user_avatar user_email )
  attr_accessor *MessageAttrs

  def self.build!(msg)

    Message.new do |message|
      message.id          = msg['id']
      message.type        = msg['type']
      message.body        = msg['body'].downcase unless msg['body'].nil?
      message.room_id     = msg['room_id']
      message.created_at  = msg['created_at']

      unless msg['user'].nil?
        message.user_id     = msg['user']['id']
        message.username    = msg['user']['name'].downcase
        message.user_type   = msg['user']['type']
        message.user_admin  = msg['user']['admin']
        message.user_avatar = msg['user']['avatar_url']
        message.user_email  = msg['user']['email_address']
      end
    end
  end

  def initialize(&block)
    MessageAttrs.each { |attr| self.__send__ "#{attr}=", attr }

    yield(self)
  end
end
