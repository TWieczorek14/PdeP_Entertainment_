class Abono {
  method descuento()

  method bonificar()

  method precioFinal(precioEntrada) = precioEntrada * (100 - self.descuento()) / 100
}

class AbonoFan inherits Abono {
  override method descuento() = 0

  override method bonificar() { }
}

class AbonoVip inherits Abono {
  var descuento

  override method descuento() = descuento

  override method bonificar() {
    descuento = (descuento + 1).min(100)
  }
}
