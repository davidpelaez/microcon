Result = ADT do
  BadRequest() | # 400
  Unauthorized() | # 401
  Unprocessable(reason: String) | # 422
  UnprocessableWithErrors(errors: Hash) | # 422
  NotFound() | # 404
  Void() | # 204
  RecordCreated(data: Hash) | # 201
  OK(data: Hash) # 200
end
