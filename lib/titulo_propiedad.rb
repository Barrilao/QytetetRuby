#encoding: utf-8

module ModeloQytetet
  class TituloPropiedad
     attr_reader :nombre, :alquilerBase, :factorRevalorizacion, :hipotecaBase, :precioEdificar
     attr_accessor :hipotecada, :casilla
     attr_writer :propietario
     
    def initialize(name, ab, fr, hb, pe)
      @nombre = name
      @hipotecada = false
      @alquilerBase = ab
      @factorRevalorizacion = fr
      @hipotecaBase = hb 
      @precioEdificar = pe
      @casilla = nil
      @propietario = nil
    end
    
    def getCasilla()
      return @casilla
    end
    
    def cobrar_alquiler(coste)
      @propietario.modificar_saldo(-coste)
    end
    
    def propietario_encarcelado #"Sin implementar"
      @propietario.encarcelado
    end
    
    def tengo_propietario
      return @jugador != nil
    end
    
    def to_s
      return "Nombre: #{@nombre} \n Hipotecada: #{@hipotecada} \n Alquiler Base: #{@alquilerBase}
                \n Factor Revalorización: #{factorRevalorizacion} \n Hipoteca Base: #{hipotecaBase}
                \n Precio Edificar: #{precioEdificar}"
    end
  end
end
