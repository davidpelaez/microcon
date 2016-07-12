class MyController < BaseController

  # parsing is implicit
  TOKEN_HEADER = "X_AUTH_TOKEN"

  context_append do |body, headers, params|
      token = headers[TOKEN_HEADER]
      next Left Error::Unauthorized() if token.nil?
      Right auth_token: token
  end

  Some(req.headers[TOKEN_HEADER]).bind do |token|
    Core['operations.auth.validate_session_token'].call(token: token)
  end.or { Left(HTTP::Error::Unauthorized() }





end
