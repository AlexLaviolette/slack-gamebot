module SlackGamebot
  module Commands
    class Best < SlackRubyBot::Commands::Base
      command 'best', 'who is the best', 'who is the best?', 'greatest', 'who is the greatest', 'who is the greatest?', 'winner' do |client, data, _match|
        client.say(channel: data.channel, text: "Alex is the best. In fact, he might be the greatest player to ever rule rocket league. Bow down before his aerial might.")
        logger.info "SUCKS: #{client.owner} - #{data.user}"
      end
    end
  end
end
