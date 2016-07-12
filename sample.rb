require 'pry'
require 'require_all'
require_all './http'

module XContextualizer
  include Microcon::Contextualizer
  contextualize_with do
    {x_cont: true}
  end
end

class Controller < Microcon::BaseController

  include XContextualizer

  contextualize_with do |body:, headers:, params:|
    # HERE only result or hashes should be accepted?
    { controller_cont: true}
  end

  process_with do |context|
    binding.pry
    puts "PROCESSING: #{context}"
    Result::OK(data: context)
  end

end

module AuthenticationContextualizer
  include Microcon::Contextualizer

  TOKEN_HEADER = :x_auth_token

  validate_session_token = -> token {
    Right true
  }

  contextualize_with do |headers:, params:, body:|
    Dry::Monads::Maybe(headers[TOKEN_HEADER])
      .bind(validate_session_token)
      .or(Result::Unauthorized())
      .bind {|user_data| { user: user_data } }
  end

end


class SecuredController < Controller

  include AuthenticationContextualizer

  contextualize_with do |body:, headers:, params:|
    # HERE only result or hashes should be accepted?
    { child_controller_cont: true }
  end

  Handler = -> context {
    puts "HANDLERS!";
    binding.pry
    Result::OK(data: context)
  }

  process_with Handler

end

require 'rack/mock'

env = Rack::MockRequest.env_for '/aloha?iuo=3', input: '{"y":22}'
req = Rack::Request.new env
req.set_header "HTTP_X_AUTH_TOKEN", 'bar'

r = ControllerChild.call req.env

pry and true

module Microcon
  class ResultHandlers
    register Result::Mine do |result|
      { status: 400, data: result.error }
    end
  end
end
