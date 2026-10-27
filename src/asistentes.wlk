import entradas.*
import productora.*

class Asistente {
  var property abono
  var property dinero
  const entradas = []

  method entradas() = entradas.copy()

  method comprarEntrada(banda, fecha) {
    self.validarSaldoPositivo()
    const entrada = new Entrada(banda = banda, fecha = fecha)
    dinero -= abono.precioFinal(entrada.precio())
    entradas.add(entrada)
    productora.registrarVenta(entrada)
  }

  method validarSaldoPositivo() {
    if (dinero <= 0) {
      throw new DomainException(message = "Saldo insuficiente: el asistente no tiene dinero positivo para comprar una entrada")
    }
  }

  method entradasDelAnioAnterior() = entradas.filter({ entrada => entrada.fecha().year() == new Date().year() - 1 })

  method nombresDeBandas() = entradas.map({ entrada => entrada.banda().nombre() }).asSet()

  method bonificar() {
    abono.bonificar()
  }
}
