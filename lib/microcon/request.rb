module Microcon

  class Request

    attr_reader :headers, :body, :params

    def initialize(env)
      @env = env
      @req = Rack::Request.new env
      parse_body
      parse_params
      parse_headers
    end

    def to_h
      {headers: headers, params: params, body: body}
    end

    private

    def t(*args)
      Functions[*args]
    end

    def parse_body
      body = @req.body.read
      parsed_body = body.empty? ? {} : Oj.load(body)
      @body = t(:symbolize_keys)[parsed_body]
    end

    def parse_headers
      # TODO snake case headers?
      @headers = t(:symbolize_keys)[ @env.select {|k,v| k.start_with? 'HTTP_'}
        .collect {|key, val| [key.sub(/^HTTP_/, '').downcase, val]}
        .instance_eval {|hpairs| Hash[hpairs]} ]
    end

    def parse_params
      router_params = @env['router.params'] || {} # From Hanami Router
      @params = t(:symbolize_keys)[@req.params.merge(router_params)]
    end


  end
end
