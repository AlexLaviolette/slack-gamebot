module SlackGamebot
  module Commands
    class Worst < SlackRubyBot::Commands::Base
      command 'worst', 'who is the worst?', 'worst?', 'marcus' do |client, data, _match|
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        
        ranked_players = client.owner.users.ranked
        if ranked_players.any?
          worst = ranked_players.send(:desc, :rank).first
          if user == worst
            client.say(channel: data.channel, text: "You! You are the worst #{user.user_name}")
          elsif user.rank && user.rank > 3
            client.say(channel: data.channel, text: "#{worst.user_name} is the worst, but with a rank of #{user.rank}, you suck!", gif: 'loser')
          else
            client.say(channel: data.channel, text: "#{worst.user_name} is the worst, and you are \##{user.rank} so you don't have to worry about ending up in this message anytime soon.", gif: 'rude')
          end
        else
          client.say(channel: data.channel, text: "There're no ranked players.", gif: 'empty')
        end
        logger.info "WORST: #{client.owner} - #{data.user}"
      end
    end
  end
end
