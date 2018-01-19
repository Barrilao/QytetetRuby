#encoding: utf-8

module ModeloQytetet
  class Calle < Casilla
    
    attr_accessor :numHoteles, :numCasas, :tituloPropiedad
    
    def initialize(nCasilla, c,tp)
      super(nCasilla,c,TipoCasilla::CALLE)
        @numHoteles = 0
        @numCasas = 0
        @tituloPropiedad = tp
        @tituloPropiedad.casilla = self
    end
    
    
    def asignar_propietario(jugador) 
      @tituloPropiedad.propietario = jugador
      @tituloPropiedad
    end
    
    def calcular_valor_hipoteca 
      h = @tituloPropiedad.hipotecaBase
      h + (@numCasas * h * 0.5 + @numHoteles * h).to_i
    end
    
    def cancelar_hipoteca #Sin implementar
      
    end
    
    def cobrar_alquiler
      coste_alquiler_base  = @tituloPropiedad.alquilerBase
      coste_alquiler_total = coste_alquiler_base + (@numCasas * 0.5 + @numHoteles * 2).to_i

      @tituloPropiedad.cobrar_alquiler(coste_alquiler_total)
      coste_alquiler_total   
    end
    
    def edificar_casa 
      @numCasas += 1
      @tituloPropiedad.precioEdificar
    end
    
    def edificar_hotel
      @numHoteles = 0
      @numHoteles += 1
      @tituloPropiedad.precioEdificar
    end
    
    def esta_hipotecada 
      return @tituloPropiedad.hipotecada
    end
    
    def get_coste_hipotecada #Sin implementar
      
    end
    
    def get_precio_edificar  
      costeEdificarCasa = @tituloPropiedad.precioEdificar
      costeEdificarCasa 
    end
    
    def hipotecar
      @tituloPropiedad.hipotecada = true
      calcular_valor_hipoteca
    end
    
    def precio_total_comprar #Sin implementar
      
    end
    
    def propietario_encarcelado
      @tituloPropiedad.propietario_encarcelado?
      
    end
    
    def se_puede_edificar_casa 
      @numCasas < 4
    end
    
    def se_puede_edificar_hotel
      respuesta = false
      if @numCasas == 4
        respuesta = @numHoteles < 4
      end  
      respuesta
    end
    
    def soy_edificable
      true
    end
    
    def tengo_propietario 
      @tituloPropiedad.tengo_propietario
    end
    
    def vender_titulo
      precioCompra=@coste+(@numCasas+@numHoteles)*@tituloPropiedad.precioEdificar
      precioVenta=(precioCompra+@tituloPropiedad.factorRevalorizacion*precioCompra)
      @tituloPropiedad.propietario = nil
      @numHoteles = 0
      @numCasas = 0
      precioVenta
      
    end
    
    def asignar_titulo_propiedad #Sin implementar
      
    end
    
        def to_s
      if (@tipo == TipoCasilla::CALLE && !tengo_propietario)
        "Casilla{#{@numeroCasilla}, coste: #{@coste}}\ncon titulo: #{@tituloPropiedad}"
      elsif (@tipo == TipoCasilla::CALLE && tengo_propietario)
        "Casilla{#{@numeroCasilla}, propietario: #{@tituloPropiedad.propietario.nombre} coste: #{@coste}, numHoteles: #{@numHoteles}, numCasas: #{@numCasas}}\ncon titulo: #{@tituloPropiedad}"
      end
    end
  end
end
