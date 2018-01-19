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
      
      @casillas << Casilla.new(0, 0, TipoCasilla::SALIDA)
      @casillas << Calle.new(1, 300, TituloPropiedad.new("Gnomeregan",0,0,0,0))
      @casillas << Calle.new(2, 300, TituloPropiedad.new("Isla de Eco",0,0,0,0))
      @casillas << Casilla.new(3, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.new(4, 500, TituloPropiedad.new("El Exodar",0,0,0,0))
      @casillas << Casilla.new(5, 0, TipoCasilla::CARCEL)
      @carcel = @casillas.at(5)
      @casillas << Calle.new(6, 700, TituloPropiedad.new("Lunargenta",0,0,0,0))
      @casillas << Calle.new(7, 700, TituloPropiedad.new("Darnassus",0,0,0,0))
      @casillas << Casilla.new(8, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.new(9, 900, TituloPropiedad.new("Cima del Trueno",0,0,0,0))
      @casillas << Casilla.new(10, 0, TipoCasilla::PARKING)
      @casillas << Calle.new(11, 1100, TituloPropiedad.new("Forjaz",0,0,0,0))
      @casillas << Calle.new(12, 1100, TituloPropiedad.new("Entrañas",0,0,0,0))
      @casillas << Casilla.new(13, 0, TipoCasilla::IMPUESTO)
      @casillas << Calle.new(14, 1300, TituloPropiedad.new("Shattrath",0,0,0,0))
      @casillas << Casilla.new(15, 0, TipoCasilla::JUEZ)
      @casillas << Calle.new(16, 1500, TituloPropiedad.new("Ventormenta",0,0,0,0))
      @casillas << Calle.new(17, 1500, TituloPropiedad.new("Ogrimmar",0,0,0,0))
      @casillas << Casilla.new(18, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.new(19, 1750, TituloPropiedad.new("Dalaran",0,0,0,0))
      
    end
    
    def to_s
      return "Casillas = " << @casillas.to_s + "\t Cárcel = #{@carcel} \n"
    end
  end
end
