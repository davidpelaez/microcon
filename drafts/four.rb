module AuthenticationContextualizer

  include Microcon::Contextualizer

  TOKEN_HEADER = "X_AUTH_TOKEN"

  ValidateToken = -> token { Right true }

  contextualize do |headers:, params:, body:|
    Dry::Monads::Maybe(headers[TOKEN_HEADER])
      .bind ValidateToken
      .or Result::Unauthorized()
      .bind { |user_data| { user: user_data } }
  end

end
