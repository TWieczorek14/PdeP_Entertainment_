import productora.*

class Entrada {
  const property banda
  const property fecha
  // El precio queda fijo al momento de emitir la entrada: si la productora
  // cambia el impuesto después, lo ya recaudado no cambia.
  const property precio = 1000 + productora.impuesto()
}
