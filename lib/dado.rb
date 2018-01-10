#encoding: utf-8

require "singleton"

module ModeloQytetet
  class Dado
    include Singleton
    def initialize
      
    end
    
    def tirar
      return rand(6) + 1
    end
    
    def to_s
      "Dado"
    end
    
  end
end
