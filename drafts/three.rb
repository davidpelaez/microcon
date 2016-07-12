# authenticate_with
# validate_with
require 'pry'

module A

  def self.included(klass)
    puts "---- #{self} included IN #{klass}"
    unless klass.instance_variable_defined? :@contextualizers
      klass.instance_variable_set :@contextualizers, []
    end
    klass.extend ClassMethods
  end

  module ClassMethods

    attr_accessor :contextualizers

    def included(klass)
      puts "+--- #{self} included IN #{klass}"
      if klass.instance_variable_defined? :@contextualizers
        current = klass.instance_variable_get :@contextualizers
        updated = current + @contextualizers
        klass.instance_variable_set :@contextualizers, updated
      else
        raise "x?"
      end
    end

    def contextualize(&blk)
      @contextualizers << blk
    end

    def inherited(klass)
      klass.instance_variable_set :@contextualizers, @contextualizers
    end

  end
end

module X

  include A

  contextualize do
    puts "I come from X"
    { x: true }
  end

  contextualize do
    puts "I come from X too"
    { x2: true }
  end

end

module W

  include A

  contextualize do
    puts "I come from W"
    { w: true }
  end
end

class Base
  include A
end

class Y < Base

  include X
  include W

  contextualize do
    puts "I come from Y"
    { y: true }
  end

  def contextualize
    #binding.pry
    self.class.contextualizers.map { |x| x.call }.reduce &:merge
  end
end

Y.new.contextualize

#binding.pry
