#encoding: utf-8

require "singleton"
require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "casilla"
require_relative "tablero"
require_relative 'metodo_salir_carcel'

module ModeloQytetet
  class Qytetet
    include Singleton
    
    attr_reader :cartaActual, :jugadores, :mazo
    attr_accessor :jugadorActual
   
    @@MAX_JUGADORES = 4
    @@MAX_CARTAS = 10
    @@MAX_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1000
    
    def initialize
      @dado = Dado.instance
      @mazo = Array.new
      @cartaActual = nil
      @tablero = nil
      @jugadorActual = nil
      @jugadores = Array.new  
    end
    
    def aplicar_sorpresa 
      tienePropietario= false
      if @cartaActual.tipo==TipoSorpresa::PAGARCOBRAR
        @jugadorActual.modificar_saldo(@cartaActual.valor)
      end
      if @cartaActual.tipo==TipoSorpresa::IRACASILLA
        esCarcel = @tablero.es_casilla_carcel(@cartaActual.valor)
        if esCarcel
          encarcelar_jugador  
        else
          nuevaCasilla = @tablero.obtener_casilla_numero(@cartaActual.valor)
          tienePropietario = @jugadorActual.actualizar_posicion(nuevaCasilla) 
        end
      end
      if @cartaActual.tipo==TipoSorpresa::PORCASAHOTEL
        @jugadorActual.pagar_cobrar_por_casa_hotel(@cartaActual.valor)
      end
      if @cartaActual.tipo==TipoSorpresa::PORJUGADOR
        for jugador in @jugadores
          if jugador!=@jugadorActual
            cantidad = @cartaActual.valor
            jugador.modificar_saldo(cantidad)
            @jugadorActual.modificar_saldo(-cantidad)
          end
        end
      end
      if @cartaActual.tipo==TipoSorpresa::SALIRCARCEL
        @jugadorActual.carta = @cartaActual
      else
        @mazo << @cartaActual
      end
      tienePropietario
    end
    
    def cancelar_hipoteca(casilla)
      devolver = false
      if casilla.esta_hipotecada
        casilla.tituloPropiedad.hipotecada=false
        devolver = true
      end
      devolver
    end
    
    def comprar_titulo_propiedad
      @jugadorActual.comprar_titulo
    end
    
    def edificar_casa(casilla)
      puedoEdificar = false
      if(casilla.soy_edificable)
        sePuedeEdificar = casilla.se_puede_edificar_casa
        if sePuedeEdificar
          puedoEdificar = @jugadorActual.puedo_edificar_casa(casilla)
          if(puedoEdificar)
            costeEdificarCasa = casilla.edificar_casa
            @jugadorActual.modificar_saldo(-costeEdificarCasa)
          end
        end
      end
      puedoEdificar
    end
    
    def edificar_hotel(casilla) 
      puedoEdificar = false
      if(casilla.soy_edificable)
        sePuedeEdificar = casilla.se_puede_edificar_hotel
        if sePuedeEdificar
          puedoEdificar = @jugadorActual.puedo_edificar_hotel(casilla)
          if(puedoEdificar)
            costeEdificarHotel = casilla.edificar_hotel
            @jugadorActual.modificar_saldo(-costeEdificarHotel)
          end
        end
      end
      puedoEdificar
      
    end
    
    def hipotecar_propiedad(casilla)
      puedoHipotecarPropiedad = false
      if casilla.soy_edificable
        puedoHipotecar = @jugadorActual.puedo_hipotecar(casilla)
        puedoHipotecarPropiedad = puedoHipotecar
        if(puedoHipotecar)
          cantidadRecibida = casilla.hipotecar
          @jugadorActual.modificar_saldo(cantidadRecibida)
        end
      end
      puedoHipotecarPropiedad
    end
    
    def inicializar_juego(nombres) 
      inicializar_jugadores(nombres)
      inicializar_cartas_sorpresa
      inicializar_tablero
      salida_jugadores
      
    end
    
    def intentar_salir_carcel(metodo) 
      libre = false
      if metodo== MetodoSalirCarcel::TIRANDODADO
        valorDado=@dado.tirar
        if valorDado > 5
          libre = true
        end
      end
      if(metodo ==  MetodoSalirCarcel::PAGANDOLIBERTAD)
        tengoSaldo = @jugadorActual.pagar_libertad(200)
        libre = tengoSaldo
      end
      if libre
        @jugadorActual.encarcelado = false
      end
      libre
    end
    
    def jugar
      valorDado = @dado.tirar
      casillaPosicion = @jugadorActual.casilla_actual
      nuevaCasilla = @tablero.obtener_nueva_casilla(casillaPosicion, valorDado)
      tienePropietario=@jugadorActual.actualizar_posicion(nuevaCasilla)
      if !nuevaCasilla.soy_edificable
        if nuevaCasilla.tipo == TipoCasilla::JUEZ
          encarcelar_jugador
        end
        if nuevaCasilla.tipo == TipoCasilla::SORPRESA
          @cartaActual = @mazo.at(0)   #aqui hay una posibilidad de eliminar cartas
          @mazo.delete_at(0)
        end
      end
      tienePropietario
    end
    
    
    def propiedades_hipotecadas_jugador(hipotecada)
      casillas = Array.new
      hipotecas = @jugadorActual.obtener_propiedades_hipotecadas(hipotecada)
      
      for cas in @tablero.casillas
        for aux in hipotecas
          if (aux == cas.titulo)
            casillas << cas
          end
        end
      end
      casillas
    end
    
    def siguiente_jugador
      pos = 0
      long = @jugadores.length
      
      for i in 0..long
        if (@jugadorActual == @jugadores.at(i))
          pos = i
        end
      end
      
      @jugadorActual = @jugadores.at((pos + 1) % long)
      
      return @jugadorActual
      
    end
    
    def vender_propiedad(casilla)
      puedoVender = casilla.soy_edificable && @jugadorActual.puedo_vender_propiedad(casilla) && !casilla.esta_hipotecada
      if puedoVender
        @jugadorActual.vender_propiedad(casilla)
      end
      puedoVender
    end
    
    def encarcelar_jugador 
      if !@jugadorActual.tengo_carta_libertad
        casillaCarcel = @tablero.carcel
        @jugadorActual.ir_a_carcel(casillaCarcel)
      else
        carta = @jugadorActual.devolver_carta_libertad
        @mazo << carta
      end
    end
    
    def inicializar_cartas_sorpresa
      @mazo<< Sorpresa.new("EH, ¿QUE HACES ENTRANDO A LOS BAJOS FONDOS??, por tu osadía te enviaremos a la cárcel", 5,TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Te libras de esta sólo porque Lady Sylvanas necesita tus servicios, sal de la cárcel", 0, TipoSorpresa::SALIRCARCEL)
      @mazo<< Sorpresa.new("Recibes un correo de Jastor Gallywix que dice: HOOOOLA AMIGO MÍO, gracias por completar el encargo 
         de suministros de Explosivos Cierrasílex que te mandé, como agradecimiento te hago entrega de tu recompensa 1000$", 1000, TipoSorpresa::PAGARCOBRAR)      
      @mazo<< Sorpresa.new("EH, CAMPESINO, VENIMOS A POR NUESTROS IMPUESTOS, LA GUERRA DE CUENCA DE ARATHI NO SE VA A GANAR SIN 
        ESOS 600$", 600, TipoSorpresa::PAGARCOBRAR)
      @mazo<< Sorpresa.new("Bienvenido a portales Khadgar, atraviese ese portal y viajará directamente a la puerta de la cárcel ", 5, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Usas tu Piedra Hogar para volver a donde empezaste, ve a la casilla de SALIDA y cobrá los 1000$",0,TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Ya se está acercando La Legión Ardiente, debes reforzar todos tus edificios pagando 125$ por cada uno", 125, TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new("La ciudad de Ventormenta agradece tu construcción de edificios después del Cataclismo, recibe 100$ por cada uno de tus edificios",
        100, TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new("Ya estamos en el evento de La Semana de los Niños, sabemos que eres una persona solidaria y donas 150$ a cada uno de los huerfanos(jugadores)",
        150, TipoSorpresa::PORJUGADOR)
      @mazo<< Sorpresa.new("Tus campeones han vuelto de sus misiones, recibes 200$ de cada uno de ellos(jugadores)", 200, TipoSorpresa::PORJUGADOR)
      @mazo<< Sorpresa.new("El rey Anduin Wrynn ha escuchado sobre tus hazañas, por lo que te convertirás en especulador", 5000, TipoSorpresa::CONVERTIRME)
      @mazo<< Sorpresa.new("La Jefa de Guerra Sylvanas Brisaveloz te recompensa con el título de Especulador por tus logros en la
          batalla del Valle de Alterac", 3000, TipoSorpresa::CONVERTIRME)
      
      @mazo.shuffle!
      
    end
    
    def inicializar_jugadores(names)   
      if (names.length < 2 || names.length > @@MAX_JUGADORES)
        raise ArgumentError, "Número incorrecto de jugadores."
      end
      for name in names
        @jugadores << Jugador.new(name)
      end
    end
    
    def inicializar_tablero
      @tablero = Tablero.new
    end
    
    def salida_jugadores
      for jugador in @jugadores
        jugador.casilla_actual = @tablero.obtener_casilla_numero(0)
      end
      
      @jugadorActual = @jugadores.at(rand(@jugadores.length))
      
    end
    
    def obtener_ranking
      r = @jugadores.sort_by(&:obtener_capital)
                    .map { |j| [j.nombre, j.obtener_capital] }
      Hash[r]
    end
    
    def to_s
      "QYTETET
      \n->cartaActual #{@cartaActual} \n\n->mazo #{@mazo.to_s} \n\n->jugadores #{@jugadores}
      \n\n->jugadorActual #{@jugadorActual.to_s} \n\n->tablero #{@tablero.to_s} \n\n->dado #{@dado.to_s}"
    end
    private :inicializar_cartas_sorpresa, :inicializar_jugadores, :inicializar_tablero
  end
end
