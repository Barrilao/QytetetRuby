#encoding: utf-8

module ModeloQytetet
  class Jugador
    attr_accessor :casilla_actual,:encarcelado, :saldo, :propiedades
    attr_writer :carta
    attr_reader :nombre
    
    
    def initialize(n)
      @encarcelado = false
      @nombre = n
      @saldo = 7500
      @casilla_actual = nil
      @propiedades = Array.new
      @carta = nil
    end
    
    def tengo_propiedades 
      return @propiedades.length != 0
    end
    
    def get_propiedad(numero)
      @propiedades.at(numero)
    end
    
    def actualizar_posicion(casilla)
      tengoPropietario= false
      if casilla.numeroCasilla < @casilla_actual.numeroCasilla
        modificar_saldo(1000)
      end
      @casilla_actual = casilla
      
      if casilla.soy_edificable
        tengoPropietario = casilla.tengo_propietario
        if casilla.tengo_propietario&& !casilla.propietario_encarcelado
          modificar_saldo(-casilla.cobrar_alquiler)
          
          
        end
      end

      if casilla.tipo == TipoCasilla::IMPUESTO
        modificar_saldo(-casilla.coste)
      end
      tengoPropietario
    end
    
    def comprar_titulo
      puedoComprar = false
      if @casilla_actual.soy_edificable
        tengoPropietario = @casilla_actual.tengo_propietario
        if !tengoPropietario
          costeCompra = @casilla_actual.coste
          if costeCompra<=@saldo
            titulo = @casilla_actual.asignar_propietario(self)
            titulo.casilla = @casilla_actual
            @propiedades << titulo
            modificar_saldo(-costeCompra)
            puedoComprar = true
          end
        end
        
      end
      puedoComprar
    end
    
    def devolver_carta_libertad 
      aux=@carta
      @carta=nil
      
      return @carta
      
    end
    
    def ir_a_carcel(c)
      @casilla_actual = c
      @encarcelado = true
      
    end
    
    def modificar_saldo(cantidad) 
      @saldo += cantidad
    end
    
    def obtener_capital 
      capital = @saldo
      for i in @propiedades.length
        precioEdificarHotelyCasa = @propiedades.at(i).casilla.get_precio_edificar()
        costeBase = @propiedades.at(i).casilla.coste
        numCasas = @propiedades.at(i).casilla.numCasas
        numHoteles = @propiedades.at(i).casilla.numHoteles
        
        if(!@propiedades.at(i).getHipotecada())
          capital += costeBase + (precioEdificarHotelyCasa * (numCasas + numHoteles))

        else
          capital -= @propiedades.at(i).hipotecaBase 
        end
      end
      return capital;
      
    end
    
    def obtener_propiedades_hipotecadas(hipotecada)
      hipotecadas = Array.new
      noHipotecadas = Array.new
      
      for i in 0..@propiedades.length
        if(@propiedades.at(i).hipotecada)
          hipotecadas << @propiedades.at(i)
        else
          noHipotecadas << @propiedades.at(i)
        end
      end
      
      if(hipotecada)
        return hipotecadas
      else
        return noHipotecadas
      end

      
    end
    
    def pagar_cobrar_por_casa_hotel(cantidad) 
      numeroTotal=cuantas_casas_hoteles_tengo 
      modificar_saldo(numeroTotal*cantidad)
      
    end
    
    def pagar_libertad(cantidad)
      tengoSaldo = tengo_saldo(cantidad)
      if tengoSaldo
        modificar_saldo(-cantidad)
      end
      tengoSaldo
    end
    
    def puedo_edificar_casa(c) 
      esMia = es_de_mi_propiedad(c)
      if esMia
        costeEdificarCasa = c.get_precio_edificar
        tengoSaldo = tengo_saldo(costeEdificarCasa)
        tengoSaldo
      end
      
      false
      
    end
    
    def puedo_edificar_hotel(c)
      esMia = es_de_mi_propiedad(c)
      if esMia
        costeEdificarHotel = c.get_precio_edificar
        tengoSaldo = tengo_saldo(costeEdificarHotel)
        tengoSaldo
      end
      
      false
      
    end
    
    def puedo_hipotecar(c) 
      es_de_mi_propiedad(c)
    end
    
    def puedo_pagar_hipoteca(c) #Sin implementar
      
    end
    
    def puedo_vender_propiedad(c)
      (es_de_mi_propiedad(c) && !c.tituloPropiedad.hipotecada)
      
    end
    
    def tengo_carta_libertad 
      return @cartaLibertad != nil
    end
    
    def vender_propiedad(c)
      precioVenta = c.vender_titulo
      modificar_saldo(precioVenta)
      eliminar_de_mis_propiedades(c)
      
    end
    
    def cuantas_casas_hoteles_tengo 
      @propiedades.inject(0) do |sum, p|
        sum + p.casilla.numCasas + p.casilla.numHoteles
      end
      
    end
    
    def eliminar_de_mis_propiedades(c) 
      @propiedades.delete(c.tituloPropiedad)
      
    end
    
    def es_de_mi_propiedad(c)
      for i in @propiedades
        if(c == i.casilla)
          return true
        end
      end
      
      return false
      
    end
    
    def tengo_saldo(cantidad) 
      ret = false
      
      if(@saldo >= cantidad)
        ret = true
      end
      return ret 
    end
        def to_s
          "\nNombre: #{@nombre}" \
          "\nSaldo: #{@saldo}" \
          "\nCarta Libertad: #{!@carta.nil?}" \
          "\nEncarcelado: #{@encarcelado}" \
          "\nCasilla Actual: #{@casilla_actual.numeroCasilla}" \
          "\nPropiedades:" \
          "#{@propiedades}"
      end
    
  end
end
