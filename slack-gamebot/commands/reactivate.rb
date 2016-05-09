module SlackGamebot
  module Commands
    class Reactivate < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        arguments = match['expression'].split.reject(&:blank?) if match['expression']
        users = User.find_many_by_slack_mention!(client.owner, arguments) if arguments && arguments.any?
        if !users
          client.say(channel: data.channel, text: 'Try _reactivate @someone_.', gif: 'help')
          logger.info "REACTIVATE: #{client.owner} - #{user.user_name}, failed, no users"
        elsif !user.captain?
          client.say(channel: data.channel, text: "You're not a captain, sorry.", gif: 'sorry')
          logger.info "REACTIVATE: #{client.owner} - #{user.user_name} reactivating #{users.map(&:user_name).and}, failed, not captain"
        else
          users.each(&:reactivate!)
          client.say(channel: data.channel, text: "#{users.map(&:user_name).and} #{users.count == 1 ? 'has' : 'have'} been reactivated.", gif: 'power')
          logger.info "REACTIVATE: #{client.owner} - #{user.user_name} reactivated #{users.map(&:user_name).and}"
        end
      end
    end
  end
end
