module SlackGamebot
  module Commands
    class SetTag < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        auth = ::User.find_create_or_update_by_slack_id!(client, data.user)
        expression = match['expression'] if match['expression']
        arguments = expression.split.reject(&:blank?) if expression

        user = User.find_by_slack_mention!(client.owner, arguments.shift)
        tag = arguments.shift

        if !user || !tag
          client.say(channel: data.channel, text: 'Try _setrank @someone :tag:_.', gif: 'help')
          logger.info "SetTag: #{client.owner} - #{auth.user_name}, failed, no users"
        elsif !auth.captain?
          client.say(channel: data.channel, text: "You're not a captain, sorry.", gif: 'sorry')
          logger.info "SetTag: #{client.owner} - #{auth.user_name} setrank #{user.user_name}, failed, not captain"
        else
          user.set_tag!(tag)
          client.say(channel: data.channel, text: "#{user.user_name} tag set to #{tag}", gif: 'power')
          logger.info "SetTag: #{client.owner} - #{auth.user_name} set tag for #{user.user_name} to #{user.tag}"
        end
      end
    end
  end
end
