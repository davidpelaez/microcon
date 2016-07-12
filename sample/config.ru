# Try running `rackup` and visit http://localhost:9292/aloha

require 'bundler'
Bundler.require :default

class EchoOperation
  def self.call(context)
    Result::OK data: context
  end
end

module Controllers
  module EchoContext
    include Microcon::Contextualizer
    contextualize_with do |headers:, params:, body:|
      headers.merge(body).merge(params).merge contextualizer: self.to_s
    end
  end

  module Welcome
    class Index < Microcon::Controller
      include Controllers::EchoContext
      process_with EchoOperation
    end
  end
end

AppRouter = Hanami::Router.new(namespace: Controllers) do
  get '/(:something)', to: 'welcome#index'
end

run AppRouter
