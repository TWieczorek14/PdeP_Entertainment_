class Banda {
  const property nombre

  method canon() = 1000000

  method presupuesto() = self.canon() + self.gastoExtra()

  method gastoExtra()

  method popularidad()
}

class Rock inherits Banda {
  const solosDeGuitarra

  override method gastoExtra() = 10000

  override method popularidad() = 100 * solosDeGuitarra
}

class Trap inherits Banda {
  const tieneHielo

  override method canon() = self.popularidad() * super()

  override method gastoExtra() = 0

  override method popularidad() = if (tieneHielo) 1000 else 0
}

class Indie inherits Banda {
  const instrumentos

  override method gastoExtra() = 500 * instrumentos.size()

  // "largo de la banda" lo interprete como la cantidad de letras del nombre
  override method popularidad() = 3.14 * nombre.size()
}
