module SlackGamebot
  class Server < SlackRubyBot::Server
    include SlackGamebot::Hooks::UserChange

    attr_accessor :team

    def initialize(attrs = {})
      @team = attrs[:team]
      fail 'Missing team' unless @team
      options = { token: @team.token }
      options[:aliases] = team.game.aliases if team.game && team.game.aliases
      super(options)
      client.team = @team
    end

    def restart!(wait = 1)
      # when an integration is disabled, a live socket is closed, which causes the default behavior of the client to restart
      # it would keep retrying without checking for account_inactive or such, we want to restart via service which will disable an inactive team
      EM.next_tick do
        logger.info "#{team.name}: socket closed, restarting ..."
        SlackGamebot::Service.restart! team, self, wait
      end
    end
  end
end
