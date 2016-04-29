module SlackGamebot
  module Commands
    class Best < SlackRubyBot::Commands::Base
      command 'best', 'who is the best', 'who is the best?', 'greatest', 'who is the greatest', 'who is the greatest?', 'winner' do |client, data, _match|
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        
        ranked_players = client.owner.users.ranked
        if ranked_players.any?
          best = ranked_players.send(:asc, :rank).first
          if user == best
            client.say(channel: data.channel, text: "You! You are the best #{user.user_name}! Congratulations on your unreasonably high skill-level and ridiculously good looks!")
          elsif user.rank && user.rank <= 3
            client.say(channel: data.channel, text: "#{best.user_name} is the best, but with a rank of #{user.rank}, you aren't too bad. But then again... if you aren't first, you're last!", gif: 'loser')
          else
            client.say(channel: data.channel, text: "#{best.user_name} is the best, and you are \##{user.rank}... so you probably have no real chance of ever holding the coveted stop spot....   loser.", gif: 'rude')
          end
        else
          client.say(channel: data.channel, text: "There're no ranked players.", gif: 'empty')
        end
        logger.info "WORST: #{client.owner} - #{data.user}"
      end
    end
  end
end