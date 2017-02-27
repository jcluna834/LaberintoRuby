load "Busquedas.rb"
load "Matrix.rb"

class Matrix
	public :"[]=", :set_element, :set_component
end

#clase arbol que va a guardar los laberintos, para este caso
class Arbol < Elemento
	def initialize(nodo, padre, operacion)
		@nodo = nodo#nodo laberinto, para este caso
		@padre = padre#padre de este nodo
		@hijos = Lista.new#lista de hijos (arboles)
		@operacion = operacion#operacion padre -> nodo
	end
	
	def arbol?
		return true
	end
	
	def setHijos(hijos)
		@hijos = hijos
	end
	
	def getElemento
		return @nodo
	end
	
	def getPadre
		return @padre
	end
	
	def getHijos
		return @hijos
	end
	
	def getOperacion
		return @operacion
	end
	
	def add(arbol)
		#agrega un hijo al arbol actual
		@hijos.add(arbol)
	end
	
	def igual?(arbol)
		return self.getElemento.igual?(arbol.getElemento)
	end

	def compareTo(arbol)
		return self.getElemento.compareTo(arbol.getElemento)
	end
end

#clase laberinto, contiene a la matriz
class Laberinto < Elemento
	def initialize(matriz)
		@matriz = matriz
		super(@matriz)
	end
	
	def getMatriz
		return @matriz
	end
	
	def igual?(laberinto)
		#dos laberintos son iguales si sus matrices son equivalentes
		m = laberinto.getMatriz
		return @matriz.eql?(m)
	end
	
	def mover(posx, posy, x, y)
		#mover del punto (x,y) al punto (posx,posy)
		if posx >= 0 and posy >=0 and posx < @matriz.row_count and posy < @matriz.column_count
			if @matriz[posx,posy] == 0 or @matriz[posx,posy] == 2
				nueva = Matrix.rows(@matriz.to_a)
				nueva[x,y] = 0
				nueva[posx,posy] = -2
				return nueva
			else
				return nil
			end
		else
			return nil
		end
	end
	
	def generarHijos
		# retorna una lista de nodos dobles, generada con
		# todos los movimientos posibles desde la posicion actual
		pos = getPosicion
		arriba = mover(pos.getOrigen - 1, pos.getDestino, pos.getOrigen, pos.getDestino)
		adelante = mover(pos.getOrigen, pos.getDestino + 1, pos.getOrigen, pos.getDestino)
		abajo = mover(pos.getOrigen + 1, pos.getDestino, pos.getOrigen, pos.getDestino)
		atras = mover(pos.getOrigen, pos.getDestino - 1, pos.getOrigen, pos.getDestino)
		hijos = Lista.new
		if not arriba.nil?
			x = Laberinto.new(arriba)
			hijos.add(ElementoDoble.new(self, x, "ARRIBA"))
		end
		if not adelante.nil?
			x = Laberinto.new(adelante)
			hijos.add(ElementoDoble.new(self, x, "ADELANTE"))
		end
		if not abajo.nil?
			x = Laberinto.new(abajo)
			hijos.add(ElementoDoble.new(self, x, "ABAJO"))
		end
		if not atras.nil?
			x = Laberinto.new(atras)
			hijos.add(ElementoDoble.new(self, x, "ATRAS"))
		end
		return hijos
	end
	
	def getPosicion
		# obtiene la posicion del jugador y lo retorna como
		# elemento doble de la forma:
		# ElementoDoble.new(posX, posY, valor manhattan a destino)
		indx = @matriz.index(-2)
		return ElementoDoble.new(indx.first, indx.last, manhattan(indx.first, indx.last))
	end
	
	def manhattan(x, y)
		# funcion manhattan
		target = @matriz.index(2)
		if not target.nil?
			return 10*((x-target.first).abs + (y-target.last).abs)
		else
			return 0
		end
	end
	
	def laberinto?
		return true
	end
	
	def mostrar
		#mostrar la matriz del laberinto
		i = 0
		print "*"
		while i<@matriz.column_count
			print "-"
			i = i + 1
		end
		print "*\n"
		@matriz.to_a.each do |a|
			print "|"
			a.each do |e|
				if e.to_i == -2
					print "☺"
				elsif e.to_i == 2
					print "☼"
				elsif e.to_i == 1
					print "░"
				else
					print " "
				end
			end
			print "|\n"
		end
		print "*"
		i = 0
		while i<@matriz.column_count
			print "-"
			i = i + 1
		end
		print "*\n"
	end

	def compareTo(laberinto)
		#funcion que compara dos laberintos, si self es equivalente a laberinto
		# retorna 0, si es mayor que laberinto retorna 1 y sino retorna -1 (menor)
		if laberinto.laberinto?
			p1 = self.getPosicion
			p2 = laberinto.getPosicion
			if p1.getOperacion == p2.getOperacion
				return 0
			elsif p1.getOperacion > p2.getOperacion
				return 1
			else
				return -1
			end
		else
			return nil
		end
	end
end

#clase busqueda con evaluacion de metodo manhattan
class BusquedaA
	def initialize
		@estadoInicial = nil#estado inicial, para este caso el laberinto
		@operaciones = nil#pila de operaciones
		@arbol = nil#arbol de busqueda
		@abiertos = nil#lista de abiertos
		@cerrados = nil#lista de cerrados
	end
	
	def getEstadoInicial
		return @estadoInicial
	end
	
	def cargarCamino(arbol)
		#procedimiento que carga el camino a partir del arbol final
		padre = arbol.getPadre
		if not padre.nil?
			@operaciones.push(Elemento.new(padre))
			cargarCamino(padre)
		end
	end
	
	def procedimientoA(abiertos, cerrados)
		#algoritmo recursivo de busquedaA*
		if abiertos.vacio?
			#Paso 3
			return false
		else
			#Paso 4
			actual = abiertos.sacar.getOrigen
			cerrados.add(Arbol.new(actual.getElemento, actual.getPadre, actual.getOperacion))
			if actual.getElemento.getPosicion.getOperacion == 0
				#Paso 5
				@estadoFinal = actual
				@operaciones.push(Elemento.new(actual))
				print "CAMINO\n"
				cargarCamino(actual)
				return true
			else
				#Paso 6
				m = actual.getElemento.generarHijos
				#Paso 7
				aux = m.getCabeza
				while not aux.nil?
					ar = Arbol.new(aux.getDestino,actual,aux.getOperacion)
					if not abiertos.esta?(ar) and not cerrados.esta?(ar)
						actual.add(ar)
						# Paso 8
						abiertos.encolar(Elemento.new(ar))
					end
					aux = aux.getNext
				end
				return procedimientoA(abiertos,cerrados)
			end
		end
	end
	
	def buscar
		# procedimiento de busqueda y generacion del arbol
		@operaciones = Pila.new
		#Paso 1
		@arbol = Arbol.new(@estadoInicial, nil, "INICIO")
		@abiertos = ColaOrdenada.new
		@abiertos.encolar(Elemento.new(@arbol))
		#Paso 2
		@cerrados = Lista.new
		if procedimientoA(@abiertos, @cerrados)
			mostrarCamino
		else
			print "No Es Alcanzable"
		end
	end
	
	def mostrarCamino
		if not @operaciones.nil? and not @operaciones.vacio?
			nodo = @operaciones.pop
			print "Inicio\n"
			nodo.getOrigen.getElemento.mostrar
			while not (nodo = @operaciones.pop).nil?
				print "Movimiento: ",nodo.getOrigen.getOperacion,"\n"
				nodo.getOrigen.getElemento.mostrar
			end
		else
			print "Sin operaciones\n"
		end
	end
	
	def cargarLaberinto(archivo)
		#carga el laberinto (matriz) desde el archivo ingresado
		matriz = Matrix[]
		File.open(archivo, "r") do |f|
			f.each_line do |line|
				pos = line.split(";")
				array = Array.new
				pos.each do |e|
					array.push(e.to_i)
				end
				matriz = Matrix.rows(matriz.to_a << array)
			end
		end
		if matriz.nil? or matriz.empty? or matriz.index(-2).nil? or matriz.index(2).nil? or matriz.index(0).nil?
			return false
		else
			@estadoInicial = Laberinto.new(matriz)
			return true
		end
	end
end

procedimientoA = BusquedaA.new
opc = nil
while opc.nil?
	print "MENU DE OPCIONES\n"
	print "\t1. Cargar Laberinto\n"
	print "\t2. Mostrar Laberinto\n"
	print "\t3. Mostrar Camino\n"
	print "\t0. Salir\n"
	print "Ingresa una opcion: "
	op = gets.chomp.to_i
	if op.equal?(0)
		opc = 1
		print "Adios..."
	else
		if op.equal?(1)
			#cargar laberinto
			print "Ingresa la ruta del archivo: "
			archivo = gets.chomp
			if procedimientoA.cargarLaberinto(archivo)
				print "Laberinto Cargado correctamente..."
			else
				print "Error al cargar..."
			end
		end
		if op.equal?(2)
			#mostrar laberinto
			procedimientoA.getEstadoInicial.mostrar
		end
		if op.equal?(3)
			procedimientoA.buscar
		end
	end
	print "\n\n"
end