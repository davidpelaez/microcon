module Microcon

    class Controller

      #@@contextualizers = []

      include Microcon::Contextualizer

      def call(env)
        #binding.pry
        #F . parse . contextualize . process . call(env)
        result = parse(env)
          .bind {|req| self.class.contextualize(req) }
          .fmap {|context| self.class.process(context) }
          .value
        unless result.is_a?(Result)
          raise "#{result.class} is not a valid result type. Should be a Result object"
        end
        render(result)
      end

      def self.process_with(handler = nil, &blk)
        @processor = handler.nil? ? blk : handler
      end

      def self.call(env)
        self.new.call(env)
      end

      def self.process(context)
        @processor.call(context)
      end

      private

      def parse(env)
        Dry::Monads::Right Request.new(env)
      rescue Oj::ParseError
        Dry::Monads::Left Result::Error::BadRequest()
      end

      def self.contextualize(req)
        # TODO this can be a single loop
        context_parts = self.contextualizers.map do |contextualizer|
          ctr = contextualizer.call **req.to_h
          if ctr.is_a?(Result)
            return Dry::Monads::Left(ctr)
          elsif ctr.is_a?(Hash)
            next Dry::Monads::Right(ctr)
          else
            raise "#{ctr.class} is not a valid return type for a contextualizer. Must be a Result or a Hash"
          end
        end
        context_parts.reduce(Dry::Monads::Maybe({})) do |memo, obj|
          # merge_fn = Dry::Monads::Maybe(-> x,y {x.merge(y)})
          # merge_fn * memo * obj
          #binding.pry
          memo.bind {|m| obj.fmap {|o| m.merge(o)} }
        end
      end

      def render(result)
        # TODO check it's not nil
        interpreted_result = ResultHandlers[result.class].call(result)
        Response.new(**interpreted_result).to_rack
      rescue Dry::Container::Error => e
        raise "ResultHandlers cannot convert a #{result.class} to an HTTP response"
      end

      def process(context)
        raise "You must implement the context method for the controller"
      end

    end

end
