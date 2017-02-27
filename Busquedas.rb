class Elemento
	def initialize(origen)
		@origen = origen
		@next = nil
		@anterior = nil
	end
	
	def getAnterior
		@anterior
	end
	
	def setAnterior(anterior)
		@anterior = anterior
	end
	
	def getNext
		@next
	end
	
	def setNext(sig)
		@next = sig
	end
	
	def setOrigen(origen)
		@origen = origen
	end
	
	def getOrigen
		@origen
	end
	
	def igual?(elemento)
		elemento.getOrigen == @origen
	end
	
	def method_missing(m, *args)  
		false
	end
	
	def mostrar
		print @origen
	end
end

class Lista
	def initialize
		@cabeza = nil
		@cola = nil
		@elementos = 0
	end
	
	def vacio?
		@cabeza.nil?
	end
	
	def size
		@elementos
	end
	
	def add(elemento)
		if vacio?
			@cabeza = elemento
			@cola = @cabeza
		else
			@cola.setNext(elemento)
			elemento.setAnterior(@cola)
			@cola = @cola.getNext
		end
		@elementos = @elementos + 1
	end
	
	def esta?(nodo)
		if vacio?
			return false
		else
			temp = @cabeza
			while not temp.nil? and not nodo.igual?(temp)
				temp = temp.getNext
			end
			if temp.nil?
				return false
			else
				return true
			end
		end
	end
	
	def getCabeza
		@cabeza
	end
	
	def getCola
		@cola
	end
	
	def remove(nodo)
		if self.vacio?
			return nil
		else
			temp = @cabeza
			while not temp.nil? and not nodo.igual?(temp)
				temp = temp.getNext
			end
			if temp.nil?
				return nil
			else
				if temp.getAnterior.nil?
					@cabeza = @cabeza.getNext
					if not @cabeza.nil?
						@cabeza.setAnterior(nil)
					end
				else
					if temp.getNext.nil?
						@cola = @cola.getAnterior
						@cola.setNext(nil)
					else
						sig = temp.getNext
						ant = temp.getAnterior
						ant.setNext(sig)
						sig.setAnterior(ant)
					end
				end
				@elementos = @elementos - 1
				return temp
			end
		end
	end
	
	def mostrar
		temp = @cabeza
		while not temp.nil?
			temp.mostrar
			if not temp.getNext.nil?
				print " "
			end
			temp = temp.getNext
		end
	end
	
	def mostrarInverso
		temp = @cola
		while not temp.nil?
			temp.mostrar
			if not temp.getAnterior.nil?
				print " "
			end
			temp = temp.getAnterior
		end
	end
	
	def sacar
		if not self.vacio?
			if @cabeza.arbol?
				elem = Arbol.new(@cabeza.getElemento, @cabeza.getPadre, @cabeza.getOperacion)
				elem.setHijos = @cabeza.getHijos
			else
				elem = Elemento.new(@cabeza.getOrigen)
			end
			@cabeza = @cabeza.getNext
			if not @cabeza.nil?
				@cabeza.setAnterior(nil)
			end
			@elementos = @elementos - 1
			return elem
		else
			return nil
		end
	end
end

class Pila < Lista
	def initialize
		super
	end
	
	def push(elemento)
		add(elemento)
	end
	
	def pop
		if not self.vacio?
			elem = Elemento.new(@cola.getOrigen)
			@cola = @cola.getAnterior
			if @cola.nil?
				@cabeza = nil
			else
				@cola.setNext(nil)
			end
			@elementos = @elementos - 1
			return elem
		else
			return nil
		end
	end
	
	def clone
		temp = @cabeza
		pila = Pila.new
		while not temp.nil?
			pila.push(Elemento.new(temp.getOrigen))
			temp = temp.getNext
		end
		pila
	end
end

class Cola < Lista
	def initialize
		super
	end
	
	def encolar(elemento)
		add(elemento)
	end
	
	def atender
		if self.vacio?
			return false
		else
			temp = @cabeza
			@cabeza = @cabeza.getNext
			if not @cabeza.nil?
				@cabeza.setAnterior(nil)
			end
			temp.setNext(nil)
			@elementos = @elementos - 1
			return temp
		end
	end
	
	def clone
		temp = @cabeza
		cola = Cola.new
		while not temp.nil?
			cola.encolar(Elemento.new(temp.getOrigen))
			temp = temp.getNext
		end
		return cola
	end
end

class ColaOrdenada < Cola
	def initialize
		super
	end
	
	def esta?(nodo)
		if vacio?
			return false
		else
			temp = @cabeza
			while not temp.nil? and not nodo.igual?(temp.getOrigen)
				temp = temp.getNext
			end
			if temp.nil?
				return false
			else
				return true
			end
		end
	end
	
	def encolar(elemento)
		temp = @cabeza
		while not temp.nil? and elemento.getOrigen.compareTo(temp.getOrigen) >= 0
			temp = temp.getNext
		end
		if temp.nil?
			add(elemento)
		else
			ant = temp.getAnterior
			if not ant.nil?
				elemento.setNext(temp)
				elemento.setAnterior(ant)
				ant.setNext(elemento)
				temp.setAnterior(elemento)
			else
				sig = @cabeza
				elemento.setNext(sig)
				sig.setAnterior(elemento)
				@cabeza = elemento
			end
			@elementos = @elementos + 1
		end
	end
end

class ElementoDoble < Elemento
	def initialize(origen, destino, operacion)
		super(origen)
		@destino = destino
		@operacion = operacion
	end
	
	def igual?(elemento)
		if @origen.equal?(elemento.getOrigen) and @destino.equal?(elemento.getDestino)
			true
		else
			false
		end
	end
	
	def setDestino(destino)
		@destino = destino
	end
	
	def getDestino
		@destino
	end
	
	def setOperacion(operacion)
		@operacion = operacion
	end
	
	def getOperacion
		@operacion
	end
	
	def mostrar
		print "("
		print @origen.mostrar
		print ","
		print @destino.mostrar
		print ","
		print @operacion
		print ")"
	end
end

class Grafo
	def initialize
		@Nodos = Lista.new
		@Aristas = Lista.new
	end
	
	def vacio?
		@Nodos.vacio?
	end
	
	def getNodos
		@Nodos
	end
	
	def addNodo(nodo)
		@Nodos.add(nodo)
	end
	
	def addArista(nodoDoble)
		if not self.existeArista?(nodoDoble)
			@Aristas.add(nodoDoble)
		end
	end
	
	def removeNodo(nodo)
		if not @Nodos.vacio?
			@Nodos.remove(nodo)
		end
	end
	
	def removeArista(arista)
		if not @Aristas.vacio?
			@Aristas.remove(arista)
		end
	end
	
	def getAristas
		@Aristas
	end
	
	def existeNodo?(nodo)
		return @Nodos.esta?(nodo)
	end
	
	def existeArista?(nodoDoble)
		@Aristas.esta?(nodoDoble)
	end
	
	def obtenerNodo(nodo)
		temp = @Nodos.clone.getCabeza
		while not temp.nil? and not nodo.igual?(temp)
			temp = temp.getNext
		end
		return temp
	end
	
	def mostrar
		print "Nodos\n"
		@Nodos.mostrar
		print "Aristas\n"
		@Aristas.mostrar
	end
	
	def getNodosOrigen(destino)
		nodos = Lista.new
		if not @Aristas.vacio?
			temp = @Aristas.getCabeza
			while not temp.nil?
				if destino.igual?(temp.getDestino)
					nodos.add(ElementoDoble.new(temp.getOrigen, temp.getDestino, temp.getOperacion))
				end
				temp = temp.getNext
			end
		end
		return nodos
	end
	
	def getNodosDestino(origen)
		nodos = Lista.new
		if not @Aristas.vacio?
			temp = @Aristas.getCabeza
			while not temp.nil?
				if origen.igual?(temp.getOrigen)
					nodos.add(ElementoDoble.new(temp.getOrigen, temp.getDestino, temp.getOperacion))
				end
				temp = temp.getNext
			end
		end
		return nodos
	end
end

class Bloques < Elemento
	def initialize(pila1, pila2, pila3)
		@e1 = pila1
		@e2 = pila2
		@e3 = pila3
	end
	
	def recorrer(n,a)
		while not n.nil? and not a.nil? and n.igual?(a)
			a = a.getAnterior
			n = n.getAnterior
		end
		if not a.nil? or not n.nil?
			return false
		else
			return true
		end
	end
	
	def igual?(bloque)
		a = bloque.getA.clone
		b = bloque.getB.clone
		c = bloque.getC.clone
		x = @e1.clone
		y = @e2.clone
		z = @e3.clone
		n = x.getCola
		a = a.getCola
		if not a.nil?
			if not n.nil? and n.igual?(a)
				if not recorrer(n,a)
					return false
				end
			else
				n = y.getCola
				if not n.nil? and n.igual?(a)
					if not recorrer(n,a)
						return false
					end
				else
					n = z.getCola
					if not n.nil? and n.igual?(a)
						if not recorrer(n,a)
							return false
						end
					else
						return false
					end
				end
			end
		end
		x = @e1.clone
		y = @e2.clone
		z = @e3.clone
		n = x.getCola
		a = b.getCola
		if not a.nil?
			if not n.nil? and n.igual?(a)
				if not recorrer(n,a)
					return false
				end
			else
				n = y.getCola
				if not n.nil? and n.igual?(a)
					if not recorrer(n,a)
						return false
					end
				else
					n = z.getCola
					if not n.nil? and n.igual?(a)
						if not recorrer(n,a)
							return false
						end
					else
						return false
					end
				end
			end
		end
		x = @e1.clone
		y = @e2.clone
		z = @e3.clone
		n = x.getCola
		a = c.getCola
		if not a.nil?
			if not n.nil? and n.igual?(a)
				if not recorrer(n,a)
					return false
				end
			else
				n = y.getCola
				if not n.nil? and n.igual?(a)
					if not recorrer(n,a)
						return false
					end
				else
					n = z.getCola
					if not n.nil? and n.igual?(a)
						if not recorrer(n,a)
							return false
						end
					else
						return false
					end
				end
			end
		end
		return true
	end
	
	def setElementos(e1, e2, e3)
		@e1 = e1
		@e2 = e2
		@e3 = e3
	end
	
	def getA
		@e1
	end
	
	def getB
		@e2
	end
	
	def getC
		@e3
	end
	
	def bloques?
		true
	end
	
	def mostrar
		print "(["
		@e1.mostrar
		print "],["
		@e2.mostrar
		print "],["
		@e3.mostrar
		print "])"
	end
end

class Jarras < Elemento
	def initialize(e1, e2)
		@e1 = e1
		@e2 = e2
	end
	
	def setElementos(e1, e2)
		@e1 = e1
		@e2 = e2
	end
	
	def getA
		@e1
	end
	
	def getB
		@e2
	end
	
	def igual?(jarra)
		if jarra.getA.getOrigen == @e1.getOrigen and jarra.getB.getOrigen == @e2.getOrigen
			true
		else
			false
		end
	end
	
	def jarras?
		true
	end
	
	def mostrar
		print "("
		print @e1.getOrigen
		print ","
		print @e2.getOrigen
		print ")"
	end
end

class Busqueda
	def initialize
		@grafo = Grafo.new
		@e0 = nil
		@ef = nil
		@operaciones = Pila.new
	end
	
	def getEstadoInicial
		@e0
	end
	
	def getEstadoFinal
		@ef
	end
	
	def getResultado
		@operaciones
	end
	
	def agregar(dest,nodo,s)
		if not @grafo.existeNodo?(dest)
			# si el nodo no existe, lo creo y lo agrego
			dest.setOrigen(nodo.getOrigen+1)
			@grafo.addNodo(dest)
		else
			#si el nodo existe, lo obtengo y creo el camino
			aux = @grafo.obtenerNodo(dest)
			dest.setOrigen(aux.getOrigen)
		end
		nuevo = ElementoDoble.new(nodo,dest,s)
		@grafo.addArista(nuevo)
	end
	
	def mover(origen, destino, nodo, a, b, c)
		elem = origen.pop
		if not elem.nil?
			if destino.getCola.nil?
				s = 'mover('<<elem.getOrigen<<',S)'
			else
				s = 'mover('<<elem.getOrigen<<','<<destino.getCola.getOrigen<<')'
			end
			destino.push(elem)
			dest = Bloques.new(a,b,c)
			agregar(dest,nodo,s)
		end
	end
	
	def llenar(x, y, nodo, a, b)
		if x
			if a.getOrigen < 3
				s = 'llenar(x)'
				dest = Jarras.new(Elemento.new(3), Elemento.new(b.getOrigen))
				agregar(dest,nodo,s)
			end
		else
			s = 'llenar(y)'
			if b.getOrigen < 4
				dest = Jarras.new(Elemento.new(a.getOrigen), Elemento.new(4))
				agregar(dest,nodo,s)
			end
		end
	end
	
	def vaciar(x, y, nodo, a, b)
		if x
			if a.getOrigen > 0
				s = 'vaciar(x)'
				dest = Jarras.new(Elemento.new(0), Elemento.new(b.getOrigen))
				agregar(dest,nodo,s)
			end
		else
			s = 'vaciar(y)'
			if b.getOrigen > 0
				dest = Jarras.new(Elemento.new(a.getOrigen), Elemento.new(0))
				agregar(dest,nodo,s)
			end
		end
	end
	
	def intercambiar(x, y, nodo, a, b)
		if x
			if b.getOrigen < 4
				s = 'intercambiar(x,y)'
				b1 = b.getOrigen + a.getOrigen
				a1 = 0
				if b1 > 4
					a1 = b1 - 4
					b1 = b1 - a1
				end
				dest = Jarras.new(Elemento.new(a1), Elemento.new(b1))
				agregar(dest,nodo,s)
			end
		else
			if a.getOrigen < 3
				s = 'intercambiar(y,x)'
				a1 = a.getOrigen + b.getOrigen
				b1 = 0
				if a1 > 3
					b1 = a1 - 3
					a1 = a1 - b1
				end
				dest = Jarras.new(Elemento.new(a1), Elemento.new(b1))
				agregar(dest,nodo,s)
			end
		end
	end
	
	def generarGrafo(e0)
		@grafo = Grafo.new
		@e0 = e0
		@e0.setOrigen(1) # marco el estado inicial con 1
		@grafo.addNodo(@e0)
		actual = @grafo.getNodos.getCabeza
		if actual.bloques?
			# bloques
			while not actual.nil?
				a = actual.getA.clone
				b = actual.getB.clone
				c = actual.getC.clone
				if not a.nil? and not a.vacio?
					mover(a,b,actual,a,b,c)
					a = actual.getA.clone
					b = actual.getB.clone
					c = actual.getC.clone
					mover(a,c,actual,a,b,c)
				end
				a = actual.getA.clone
				b = actual.getB.clone
				c = actual.getC.clone
				if not b.nil? and not b.vacio?
					mover(b,a,actual,a,b,c)
					a = actual.getA.clone
					b = actual.getB.clone
					c = actual.getC.clone
					mover(b,c,actual,a,b,c)
				end
				a = actual.getA.clone
				b = actual.getB.clone
				c = actual.getC.clone
				if not c.nil? and not c.vacio?
					mover(c,a,actual,a,b,c)
					a = actual.getA.clone
					b = actual.getB.clone
					c = actual.getC.clone
					mover(c,b,actual,a,b,c)
				end
				actual = actual.getNext
			end
		else
			# jarras
			while not actual.nil?
				a = actual.getA
				b = actual.getB
				llenar(true,false,actual,a,b)
				a = actual.getA
				b = actual.getB
				vaciar(true,false,actual,a,b)
				a = actual.getA
				b = actual.getB
				intercambiar(true,false,actual,a,b)
				a = actual.getA
				b = actual.getB
				llenar(false,true,actual,a,b)
				a = actual.getA
				b = actual.getB
				vaciar(false,true,actual,a,b)
				a = actual.getA
				b = actual.getB
				intercambiar(false,true,actual,a,b)
				actual = actual.getNext
			end
		end
		print "Grafo Generado\n"
	end
	
	def buscarEstados(ef)
		if not @grafo.nil? and not @grafo.vacio?
			print "\nBuscar: "
			ef.mostrar
			print "\n"
			if @grafo.existeNodo?(ef)
				@ef = @grafo.obtenerNodo(ef)
				@operaciones = Pila.new
				actual = @ef
				print "Elemento marcado con: ", actual.getOrigen, "\n"
				while not actual.getOrigen.equal?(1)
					nodos = @grafo.getNodosOrigen(actual)
					temp = nodos.getCabeza
					while not temp.nil?
						aux = @grafo.obtenerNodo(temp.getOrigen)
						if aux.getOrigen < actual.getOrigen
							actual = aux
							@operaciones.add(Elemento.new(temp.getOperacion))
						end
						temp = temp.getNext
					end
				end
				print "\nInicial: "
				actual.mostrar
				print "\nOperaciones: "
				if not @operaciones.vacio?
					@operaciones.mostrarInverso
				else
					print "Sin Movimientos"
				end
				print "\n"
			else
				print "El estado final no es alcanzable"
			end
		else
			print "Grafo no generado"
		end
	end
	
	def chequear(a, c, nodo)
		aux = a.getCabeza
		while not aux.nil?
			if nodo.getOrigen.igual?(aux.getOrigen)
				return true
			end
			aux = aux.getNext
		end
		aux = c.getCabeza
		while not aux.nil?
			if nodo.getOrigen.igual?(aux.getOrigen)
				return true
			end
			aux = aux.getNext
		end
		return false
	end
	
	def obtenerRuta(grafo, actual)
		if not grafo.vacio?
			padre = grafo.getNodosOrigen(actual.getOrigen).getCabeza
			while not padre.nil? and not padre.getOrigen.igual?(@e0)
				@operaciones.push(Elemento.new(padre.getOperacion))
				padre = grafo.getNodosOrigen(padre.getOrigen).getCabeza
			end
			@operaciones.push(Elemento.new(padre.getOperacion))
		end
	end
	
	def amplitud(grafo, a, c)
		if a.vacio? #paso 3
			return false
		else
			#paso 4
			actual = a.sacar
			c.add(Elemento.new(actual.getOrigen))
			if not actual.nil?
				#paso 5
				if actual.getOrigen.igual?(@ef)
					obtenerRuta(grafo, actual)
					return true
				else
					#paso 6
					destinos = @grafo.getNodosDestino(actual.getOrigen)
					if not destinos.vacio?
						temp = destinos.getCabeza
						#paso 7
						while not temp.nil?
							if not chequear(a,c,Elemento.new(temp.getDestino))
								#paso 8, dado que en amplitud se usa una lista, los elementos estan ya ordenados.
								a.add(Elemento.new(temp.getDestino))								
								grafo.addNodo(Elemento.new(temp.getDestino))
								grafo.addArista(ElementoDoble.new(temp.getOrigen, temp.getDestino, temp.getOperacion))
							end
							temp = temp.getNext
						end
						#paso 9
						return amplitud(grafo,a,c)
					else
						return amplitud(grafo,a,c)
					end
				end
			else
				return false
			end
		end
	end
	
	def buscarAmplitud(ef)
		print "\nBuscar: "
		ef.mostrar
		print "\n"
		if @grafo.existeNodo?(ef)
			#paso 1
			@ef = @grafo.obtenerNodo(ef)
			abierto = Lista.new
			grafo = Grafo.new
			abierto.add(Elemento.new(@e0))
			grafo.addNodo(Elemento.new(@e0))
			#paso 2
			cerrado = Lista.new
			@operaciones = Pila.new
			if amplitud(grafo, abierto, cerrado)
				print "\nInicial: "
				@e0.mostrar
				print "\nOperaciones: "
				if not @operaciones.vacio?
					@operaciones.mostrarInverso
				else
					print "Sin Movimientos"
				end
				print "\n"
			else
				print "Elemento no encontrado\n"
			end
		else
			print "El estado final no es alcanzable\n"
		end
	end
	
	def profundidad(grafo, a, c)
		if a.vacio?
			return false
		else
			actual = a.pop
			if not actual.nil?
				if actual.getOrigen.igual?(@ef)
					obtenerRuta(grafo, actual)
					return true
				else
					destinos = @grafo.getNodosDestino(actual.getOrigen)
					if not destinos.vacio?
						temp = destinos.getCabeza
						while not temp.nil?
							if not chequear(a,c,Elemento.new(temp.getDestino))
								a.push(Elemento.new(temp.getDestino))
								grafo.addNodo(Elemento.new(temp.getDestino))
								grafo.addArista(ElementoDoble.new(temp.getOrigen, temp.getDestino, temp.getOperacion))
							end
							temp = temp.getNext
						end
						c.add(Elemento.new(actual.getOrigen))
						return amplitud(grafo,a,c)
					else
						return amplitud(grafo,a,c)
					end
				end
			else
				return false
			end
		end
	end
	
	def buscarProfundidad(ef)
		print "\nBuscar: "
		ef.mostrar
		print "\n"
		if @grafo.existeNodo?(ef)
			#paso 1
			@ef = @grafo.obtenerNodo(ef)
			abierto = Pila.new
			grafo = Grafo.new
			abierto.add(Elemento.new(@e0))
			grafo.addNodo(Elemento.new(@e0))
			#paso 2
			cerrado = Lista.new
			@operaciones = Pila.new
			if profundidad(grafo, abierto, cerrado)
				print "\nInicial: "
				@e0.mostrar
				print "\nOperaciones: "
				if not @operaciones.vacio?
					@operaciones.mostrarInverso
				else
					print "Sin Movimientos"
				end
				print "\n"
			else
				print "Elemento no encontrado\n"
			end
			print "\n"
		else
			print "El estado final no es alcanzable\n"
		end
	end
	
	def buscarProfundidadLimitada(ef, limite)
		abierto = Cola.new
		cerrado = Lista.new
		m = Lista.new
		temp = nil
		print "\nEstado Final: "
		ef.mostrar
		print "\n"
		if @grafo.existeNodo?(ef)
			@ef = @grafo.obtenerNodo(ef)
			@operaciones = Pila.new
			# en construccion...
			
			print "\nInicial: "
			actual.mostrar
			print "\nOperaciones: "
			if not @operaciones.vacio?
				@operaciones.mostrarInverso
			else
				print "Sin Movimientos"
			end
			print "\n"
		else
			print "El estado final no es alcanzable"
		end
	end
	
	def buscarDijkstra(ef)
		abierto = ColaOrdenada.new
		cerrado = Lista.new
		m = Lista.new
		temp = nil
		print "\nEstado Final: "
		ef.mostrar
		print "\n"
		if @grafo.existeNodo?(ef)
			@ef = @grafo.obtenerNodo(ef)
			@operaciones = Pila.new
			# en construccion...
			
			print "\nInicial: "
			actual.mostrar
			print "\nOperaciones: "
			if not @operaciones.vacio?
				@operaciones.mostrarInverso
			else
				print "Sin Movimientos"
			end
			print "\n"
		else
			print "El estado final no es alcanzable"
		end
	end
	
	def buscarAvida
		
	end
	
	def BuscarA
		
	end
	
	def mostrar
		if not @grafo.nil? and not @grafo.vacio?
			if @e0.bloques?
				print "Grafo de Bloques\n"
				print "Estado inicial: \n\t"
				if not @e0.getA.vacio?
					print "["
					@e0.getA.mostrar
					print "],["
				else
					print "[],["
				end
				if not @e0.getB.vacio?
					@e0.getB.mostrar
					print "],["
				else
					print "],["
				end
				if not @e0.getC.vacio?
					@e0.getC.mostrar
					print "]"
				else
					print "]"
				end
				print "\nNODOS\n"
				@grafo.getNodos.mostrar
			else
				print "Grafo de Jarras\n"
				print "Estado inicial: \n\t"
				if not @e0.getA.vacio?
					print "(",@e0.getA.getOrigen,","
				else
					print "(vacio,"
				end
				if not @e0.getB.nil?
					print @e0.getB.getOrigen,")"
				else
					print "vacio)"
				end
				print "\nNODOS\n"
				@grafo.getNodos.mostrar
			end
			print "\n"
		else
			print "Grafo no generado"
		end
	end
end

def llenarNodo(a, letra, cantidad)
	aux = nil
	i = 0
	while aux.nil? and cantidad < 3
		i = i + 1
		print "Ingrese el elemento ",i," para ", letra,": "
		valor = gets.chomp
		a.push(Elemento.new(valor))
		cantidad = cantidad + 1
		print "Salir?\n\t1.Si: "
		x = gets.chomp.to_i
		if x.equal?(1)
			aux = 1
		end
	end
	a
end

def crearElemento(letra)
	valor = -1
	while valor < 0
		print "Ingrese la cantidad de agua inicial para ", letra,": "
		valor = gets.chomp.to_i
		if letra.equal?('a')
			if valor > 3
				print "\nEl Limite de agua de a es 3...\n"
				valor = -1
			end
		else
			if valor > 4
				print "\nEl Limite de agua de a es 4...\n"
				valor = -1
			end
		end
	end
	Elemento.new(valor)
end
