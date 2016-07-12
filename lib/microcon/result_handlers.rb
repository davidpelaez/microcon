require 'dry-container'
#Core.finalize :base_controller do
module Microcon
    class ResultHandlers

      extend Dry::Container::Mixin

      # configure do |config|
      #   #config.registry = ->(container, key, item, options) { container[key] = item }
      #   config.resolver = ->(container, key) {
      #     # TODO how to use this to compose?
      #     Some(container[key])
      #   }
      # end

      register Result::Unauthorized, -> r {
        { status: 401, body: {error: :unauthorized } }
      }

      register Result::Void, -> r {
        { status: 204, body: { } }
      }

      register Result::Unprocessable, -> r {
        {
          status: 422,
          body: {
            error: :unprocessable_entity, reason: error.reason
          }
        }
      }

    register Result::UnprocessableWithErrors, -> r {
        {
          status: 422,
          body: {
            error: :unprocessable_entity, messages: r.errors
          }
        }
    }

    register Result::NotFound, -> r {
      {status: 404, body: {error: :not_found}}
    }


    register Result::RecordCreated, -> r {
      {status: 201, body: r.data}
    }

    register Result::OK, -> r {
      {status: 200, body: r.data}
    }

    end
  end
