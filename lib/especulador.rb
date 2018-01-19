# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Especulador < Jugador
    attr_reader :fianza
    
    
    def initialize(jugador, fianza)
      super(jugador.nombre)
      @factorEspeculador = 2
      @fianza = fianza
      
    end
    
    def ir_a_carcel(casilla)
      nocarcel = pagar_fianza(@fianza)
      
      if (!nocarcel)
        @casilla_actual = casilla
        @encarcelado = true
      end
    end
    
    def pagar_fianza(cantidad)
      tienesaldo = false
      
      if (@saldo > @fianza)
        tienesaldo = true
        modificar_saldo(-@fianza)
      end
      
      return tienesaldo
    end
    
    def pagar_impuestos(cantidad)
      modificar_saldo(cantidad/2)
    end
    
    def convertirme(fianza)
      return self
    end
    
     def to_s
      super
    end
    
    protected :pagar_impuestos
    private :pagar_fianza
  end
end
