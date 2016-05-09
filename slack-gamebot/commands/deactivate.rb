module SlackGamebot
  module Commands
    class Deactivate < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        arguments = match['expression'].split.reject(&:blank?) if match['expression']
        users = User.find_many_by_slack_mention!(client.owner, arguments) if arguments && arguments.any?
        if !users
          client.say(channel: data.channel, text: 'Try _deactivate @someone_.', gif: 'help')
          logger.info "DEACTIVATE: #{client.owner} - #{user.user_name}, failed, no users"
        elsif !user.captain?
          client.say(channel: data.channel, text: "You're not a captain, sorry.", gif: 'sorry')
          logger.info "DEACTIVATE: #{client.owner} - #{user.user_name} deactivating #{users.map(&:user_name).and}, failed, not captain"
        else
          users.each(&:deactivate!)
          client.say(channel: data.channel, text: "#{users.map(&:user_name).and} #{users.count == 1 ? 'has' : 'have'} been deactivated.", gif: 'power')
          logger.info "DEACTIVATE: #{client.owner} - #{user.user_name} deactivated #{users.map(&:user_name).and}"
        end
      end
    end
  end
end
