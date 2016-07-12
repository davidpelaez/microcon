module Microcon
  class Response #< BasicRequest

    def initialize(status:, body: {}, headers: {})
      @status = status
      @body = encode(body)
      @headers = headers.merge Rack::CONTENT_TYPE => "application/json; charset=utf-8"
    end

    def encode(body)
      # TODO transformation
      Oj.dump(body)
    end

    def to_rack
      [@status, @headers, [@body]]
    end
  end
end
