module SlackGamebot
  module Commands
    class SetNick < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        auth = ::User.find_create_or_update_by_slack_id!(client, data.user)
        expression = match['expression'] if match['expression']
        arguments = expression.split.reject(&:blank?) if expression

        user = User.find_by_slack_mention!(client.owner, arguments.shift)
        rank = arguments.shift

        if !user || !rank
          client.say(channel: data.channel, text: 'Try _setrank @someone :rank:_.', gif: 'help')
          logger.info "SetRank: #{client.owner} - #{auth.user_name}, failed, no users"
        elsif !auth.captain?
          client.say(channel: data.channel, text: "You're not a captain, sorry.", gif: 'sorry')
          logger.info "SetRank: #{client.owner} - #{auth.user_name} setrank #{user.user_name}, failed, not captain"
        else
          user.set_rl_rank!(rank)
          client.say(channel: data.channel, text: "#{user.user_name} rank set to #{rank}", gif: 'power')
          logger.info "SetRank: #{client.owner} - #{auth.user_name} set rank for #{user.user_name} to #{user.rl_rank}"
        end
      end
    end
  end
end
