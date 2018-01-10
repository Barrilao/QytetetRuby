#encoding: utf-8



module ModeloQytetet
  class Tablero
    attr_reader  :casillas
    attr_accessor :carcel
    def initialize
      inicializar    
    end
    
    def es_casilla_carcel(numeroCasilla) 
      if @casillas.at(numeroCasilla).tipo == TipoCasilla::CARCEL
        return true
      else
        return false
      end  
      
    end
    
    def obtener_casilla_numero(numeroCasilla) 
      return @casillas.at(numeroCasilla)
    end
    
    def obtener_nueva_casilla(casilla,desplazamiento) 
      numero_casilla = casilla.numeroCasilla
      numero_casilla = (numero_casilla + desplazamiento) % @casillas.length
      
      return @casillas.at(numero_casilla) 
    end
     
    def inicializar    #Titulos de propiedad y PrecioCasilla no inicializados
      @casillas = Array.new
      
      @casillas << Casilla.new(0, 0, 0, TipoCasilla::SALIDA, nil)
      @casillas << Casilla.new(1, 300, 0, TipoCasilla::CALLE, TituloPropiedad.new("Gnomeregan",0,0,0,0))
      @casillas << Casilla.new(2, 300, 0, TipoCasilla::CALLE, TituloPropiedad.new("Isla de Eco",0,0,0,0))
      @casillas << Casilla.new(3, 0, 0, TipoCasilla::SORPRESA, nil)
      @casillas << Casilla.new(4, 500, 0, TipoCasilla::CALLE, TituloPropiedad.new("El Exodar",0,0,0,0))
      @casillas << Casilla.new(5, 0, 0, TipoCasilla::CARCEL, nil)
      @carcel = @casillas.at(5)
      @casillas << Casilla.new(6, 700, 0, TipoCasilla::CALLE, TituloPropiedad.new("Lunargenta",0,0,0,0))
      @casillas << Casilla.new(7, 700, 0, TipoCasilla::CALLE, TituloPropiedad.new("Darnassus",0,0,0,0))
      @casillas << Casilla.new(8, 0, 0, TipoCasilla::SORPRESA, nil)
      @casillas << Casilla.new(9, 900, 0, TipoCasilla::CALLE, TituloPropiedad.new("Cima del Trueno",0,0,0,0))
      @casillas << Casilla.new(10, 0, 0, TipoCasilla::PARKING, nil)
      @casillas << Casilla.new(11, 1100, 0, TipoCasilla::CALLE, TituloPropiedad.new("Forjaz",0,0,0,0))
      @casillas << Casilla.new(12, 1100, 0, TipoCasilla::CALLE, TituloPropiedad.new("Entrañas",0,0,0,0))
      @casillas << Casilla.new(13, 0, 0, TipoCasilla::IMPUESTO, nil)
      @casillas << Casilla.new(14, 1300, 0, TipoCasilla::CALLE, TituloPropiedad.new("Shattrath",0,0,0,0))
      @casillas << Casilla.new(15, 0, 0, TipoCasilla::JUEZ, nil)
      @casillas << Casilla.new(16, 1500, 0, TipoCasilla::CALLE, TituloPropiedad.new("Ventormenta",0,0,0,0))
      @casillas << Casilla.new(17, 1500, 0, TipoCasilla::CALLE, TituloPropiedad.new("Ogrimmar",0,0,0,0))
      @casillas << Casilla.new(18, 0, 0, TipoCasilla::SORPRESA, nil)
      @casillas << Casilla.new(19, 1750, 0, TipoCasilla::CALLE, TituloPropiedad.new("Dalaran",0,0,0,0))
      
    end
    
    def to_s
      return "Casillas = " << @casillas.to_s + "\t Cárcel = #{@carcel} \n"
    end
    
  end
end
