#encoding: utf-8

require_relative "tipo_casilla"

module ModeloQytetet
  class Casilla
    attr_reader :numeroCasilla, :coste, :tipo, :precioCasilla
    attr_accessor :numHoteles, :numCasas, :tituloPropiedad
    
    def initialize(nCasilla, c, pc, t, tp)
      @numeroCasilla = nCasilla
      @coste = c
      @numHoteles = 0
      @numCasas = 0
      @precioCasilla = pc #No sale en el guión, debe tener un precio de 300-2000
      @tipo = t
      @tituloPropiedad = tp
      
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
      if @numCasas = 4
        respuesta = @numHoteles < 4
      end  
      respuesta
    end
    
    def soy_edificable 
      @tipo == TipoCasilla::CALLE
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
      if (@tipo == TipoCasilla::CALLE)
        "Numero casilla: #{@numeroCasilla} \n Coste: #{@coste} \n Numero Hoteles: #{@numHoteles} \n Numero Casas: #{@numCasas} \n Tipo: #{@tipo} \n Titulo propiedad: #{@tituloPropiedad}"
      else
        "Numero casilla: #{@numeroCasilla}  \n Tipo: #{@tipo}"

      end
    end
  
  end
end

