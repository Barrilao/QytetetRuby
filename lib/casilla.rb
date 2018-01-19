#encoding: utf-8

require_relative "tipo_casilla"

module ModeloQytetet
  class Casilla
    attr_reader :coste, :tipo
    attr_accessor :numHoteles, :numCasas, :titulo, :numeroCasilla, :numeroCasilla
    def initialize(nCasilla, c, t)
      @numeroCasilla = nCasilla
      @coste = c
      @tipo = t
      
    end
    
    def soy_edificable 
      @tipo == TipoCasilla::CALLE
    end
    
    def to_s
      "Casilla{#{@numeroCasilla}, tipo: #{@tipo}}"
    end
  
  end
end

