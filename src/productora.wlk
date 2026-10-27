object productora {
  var property impuesto = 100
  const bandas = #{}
  const entradasVendidas = []

  method contratar(banda) {
    bandas.add(banda)
  }

  method registrarVenta(entrada) {
    entradasVendidas.add(entrada)
  }

  method recaudacion() = entradasVendidas.sum({ entrada => entrada.precio() })

  method presupuestoTotal() = bandas.sum({ banda => banda.presupuesto() })

  method gananciaTotal() = self.recaudacion() - self.presupuestoTotal()

  method cantidadEntradasVendidas() = entradasVendidas.size()

  method entradasVendidasDe(banda) = entradasVendidas.count({ entrada => entrada.banda() == banda })

  method bandaMasPopular() = bandas.max({ banda => self.entradasVendidasDe(banda) })
}
