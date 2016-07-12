module Microcon
  module Contextualizer

  def self.included(klass)
    unless klass.instance_variable_defined? :@contextualizers
      klass.instance_variable_set :@contextualizers, []
    end
    klass.extend Dry::Monads::Either::Mixin
    klass.include Dry::Monads::Either::Mixin
    klass.extend ClassMethods
  end

  module ClassMethods

    attr_accessor :contextualizers

    def included(klass)
      if klass.instance_variable_defined? :@contextualizers
        current = klass.instance_variable_get :@contextualizers
        updated = current + @contextualizers
        klass.instance_variable_set :@contextualizers, updated
      end
    end

    def contextualize_with(&blk)
      @contextualizers << blk
    end

    def inherited(klass)
      klass.instance_variable_set :@contextualizers, @contextualizers
    end

  end
end
end
