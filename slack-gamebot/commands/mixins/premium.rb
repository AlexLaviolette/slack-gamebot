module SlackGamebot
  module Commands
    module Mixins
      module Premium
        extend ActiveSupport::Concern

        module ClassMethods
          def premium_command(*values, &_block)
            command(*values) do |client, data, match|
              yield client, data, match
            end
          end

          def premium(client, data, &_block)
            yield
          end
        end
      end
    end
  end
end
