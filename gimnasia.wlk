class Rutina {
	
    method caloriasConsumidas(tiempo) {
		return 100 * (tiempo - self.descanso(tiempo)) * self.intensidad()
	}

	method descanso(tiempo)

	method intensidad()
}
class Running inherits Rutina {
	var property intensidad 

	override method descanso(tiempo) {
		return if (tiempo > 20) 5 else 2
	}
}

class Maraton inherits Running {
	override method caloriasConsumidas(tiempo) {
		return super(tiempo) * 2
	}
}

class Remo inherits Rutina {
	override method intensidad() = 1.3

	override method descanso(tiempo) {
		return tiempo / 5
	}
}

class RemoDeCompeticion inherits Remo {
	override method intensidad() = 1.7

	override method descanso(tiempo) {
		return (super(tiempo) - 3).max(2)
	}
}

class Persona {
    var property peso

	method tiempoDeEjercitacion()
	method caloriasPorKilo()
	method puedeHacer(rutina)

	method caloriasConsumidas(rutina) {
		return rutina.caloriasConsumidas(self.tiempoDeEjercitacion())
	}

	method pesoPerdido(rutina) {
		return self.caloriasConsumidas(rutina) / self.caloriasPorKilo()
	}

	method practicar(rutina) {
		if (self.puedeHacer(rutina)) {
			peso = 0.max(peso - self.pesoPerdido(rutina))
		}
	}
}

class Sedentaria inherits Persona {
	const property tiempoDeEjercitacion

	override method caloriasPorKilo() = 7000

	override method puedeHacer(rutina) = peso > 50
}

class Atleta inherits Persona {
	override method tiempoDeEjercitacion() = 90

	override method caloriasPorKilo() = 8000

	override method puedeHacer(rutina) {
		return self.caloriasConsumidas(rutina) > 10000
	}

	override method pesoPerdido(rutina) {
		return super(rutina) - 1
	}
}

class Predio {
	const property rutinas = #{}

	method agregarRutina(rutina) {
		rutinas.add(rutina)
	}

	method caloriasTotales(persona) {
		return rutinas.sum({ r => persona.caloriasConsumidas(r) })
	}

	method esTranqui(persona) {
		return rutinas.any({ r => persona.caloriasConsumidas(r) < 500 })
	}

	method rutinaMasExigente(persona) {
		return rutinas.max({ r => persona.caloriasConsumidas(r) })
	}
}

class Club {
	const property predios = #{}

	method agregarPredio(predio) {
		predios.add(predio)
	}

	method mejorPredio(persona) {
		return predios.max({ p => p.caloriasTotales(persona) })
	}

	method prediosTranquis(persona) {
		return predios.filter({ p => p.esTranqui(persona) })
	}

	method rutinasMasExigentes(persona) {
		return predios.map({ p => p.rutinaMasExigente(persona) }).asSet()
	}
}

