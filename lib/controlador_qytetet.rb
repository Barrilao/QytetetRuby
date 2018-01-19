#encoding: utf-8

require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "casilla"
require_relative "tablero"
require_relative "titulo_propiedad"
require_relative "tipo_casilla"
require_relative "qytetet"
require_relative "metodo_salir_carcel"
require_relative "jugador"
require_relative "dado"
require_relative "vista_textual_qytetet"
require_relative "calle"


module InterfazTextualQytetet
  class ControladorQytetet
    include ModeloQytetet
    def initialize
      @qytetet = nil
      @jugadorActual = nil
      @casillaActual = nil
      @vista = VistaTextualQytetet.new
    end
    
    def inicializacion_juego
      nombres = Array.new
      @qytetet= Qytetet.instance
      nombres = @vista.obtener_nombre_jugadores
      @qytetet.inicializar_juego(nombres)
      @jugadorActual = @qytetet.jugadorActual
      @casillaActual = @jugadorActual.casilla_actual
      @vista.mostrar(@qytetet.to_s)
    end
    
    def desarrollo_juego
      while @jugadorActual.saldo > 0
        libre=false
        @vista.mostrar("Turno del jugador: " + @jugadorActual.nombre + "\n")
        @vista.mostrar("Está situado en la casilla: #{@casillaActual}\n")
        if @jugadorActual.encarcelado
          @vista.mostrar("El jugador: " + @jugadorActual.nombre + " se encuentra en las Mazmorras de Ventormenta.\n")
          tipoSalida = @vista.menu_salir_carcel
          if tipoSalida==0
            libre=@qytetet.intentar_salir_carcel(MetodoSalirCarcel::TIRANDODADO)
          else
            libre=@qytetet.intentar_salir_carcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
          end
          if libre
            @qytetet.jugadorActual.encarcelado=false
            @jugadorActual = @qytetet.jugadorActual
            @vista.mostrar("Por esta vez te libras jugador: " + @jugadorActual.nombre + "\n")
          else
            @vista.mostrar("Gusano miserable, no te escaparas " + @jugadorActual.nombre + " vas a pasar a la sombra un largo tiempo JAJAJAJA\n")
          end
        
        end
        if !@jugadorActual.encarcelado
          @vista.mostrar("Tiras el dado\n")
          tienePropietario = @qytetet.jugar
          @jugadorActual = @qytetet.jugadorActual
          @casillaActual = @jugadorActual.casilla_actual
          @vista.mostrar("Avanzas hasta la casilla:  #{@casillaActual}\n")
          if @jugadorActual.saldo > 0
            if !@jugadorActual.encarcelado
              if @casillaActual.tipo == TipoCasilla::SORPRESA
                @vista.mostrar("Has caido en una casilla sorpresa: #{@qytetet.cartaActual}\n")
                tienePropietario = @qytetet.aplicar_sorpresa
                @vista.mostrar("Se acaba de aplicar la sorpresa :D\n" )
                @jugadorActual = @qytetet.jugadorActual
                @casillaActual = @jugadorActual.casilla_actual
                if !@jugadorActual.encarcelado && @jugadorActual.saldo > 0
                  if @casillaActual.tipo == TipoCasilla::CALLE
                    @vista.mostrar("Está situado en la casilla:  #{@casillaActual}\n")
                    if !tienePropietario
                      elegirQuieroComprar = @vista.elegir_quiero_comprar
                      if elegirQuieroComprar == 0
                        @qytetet.comprar_titulo_propiedad
                        @jugadorActual = @qytetet.jugadorActual
                        @casillaActual = @jugadorActual.casilla_actual
                        @vista.mostrar("Felicidades, has obtenido la propiedad\n" )
                      end
                    end
                  end
                end
              elsif @casillaActual.tipo == TipoCasilla::CALLE
                if !tienePropietario
                  elegirQuieroComprar = @vista.elegir_quiero_comprar
                  if elegirQuieroComprar == 0
                        @qytetet.comprar_titulo_propiedad
                        @jugadorActual = @qytetet.jugadorActual
                        @casillaActual = @jugadorActual.casilla_actual
                        @vista.mostrar("Felicidades, has obtenido la propiedad\n" )
                  end
                end
              end
              if !@jugadorActual.encarcelado && @jugadorActual.saldo > 0 && @jugadorActual.tengo_propiedades
                nombrePropiedades = Array.new
                for p in @jugadorActual.propiedades
                  nombrePropiedades << p.nombre
                end
                ncasilla = @vista.menu_elegir_propiedad(nombrePropiedades)
                casilla = @jugadorActual.get_propiedad(ncasilla).casilla 
                opcion = 1
                while opcion != 0 && @jugadorActual.tengo_propiedades
                  opcion = @vista.menu_gestion_inmobiliaria
                  if opcion == 1
                    @qytetet.edificar_casa(casilla)
                  end
                  if opcion == 2
                    @qytetet.edificar_hotel(casilla)
                  end
                  if opcion == 3
                    @qytetet.vender_propiedad(casilla)
                  end
                  if opcion == 4
                    @qytetet.hipotecar_propiedad(casilla)
                  end
                  if opcion == 5
                    @qytetet.cancelar_hipoteca(casilla)
                  end
                  @jugadorActual = @qytetet.jugadorActual
                  @casillaActual = @jugadorActual.casilla_actual
                  @vista.mostrar("HECHO\n" )
                end
              end
            end
          end 
        end
        if @jugadorActual.saldo > 0
          @qytetet.siguiente_jugador
          @jugadorActual = @qytetet.jugadorActual
          @casillaActual = @jugadorActual.casilla_actual
        end
      end
      @vista.mostrar("FIN DEL JUEGO\n" )
      @qytetet.obtenerRanking
    end
     def self.main
      controlador = ControladorQytetet.new
      controlador.inicializacion_juego
      controlador.desarrollo_juego
    end
  end
  ControladorQytetet.main
end
