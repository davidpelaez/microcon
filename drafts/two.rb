module HTTP
  module Concerns
    module Authenticated

      TOKEN_HEADER = "X_AUTH_TOKEN"

      contextualize do |req|

          token = req.headers[TOKEN_HEADER]
          return Left(HTTP::Error::Unauthorized()) if token.nil?
          Core['operations.auth.validate_session_token'].call(token: token).or {
            return Left HTTP::Error::Unauthorized()
            } >-> user_data {
              req.context.merge!(user: user_data)
              return Right(req)
            }
      end

    end
  end
end
