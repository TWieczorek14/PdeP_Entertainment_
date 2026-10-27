# PDEP Entertainment – TP Individual de Objetos (Wollok)

Diagrama de clases: `diagrama_solucion_TOMAS_WIECZOREK.png`
Código: `src/` (`productora.wlk`, `entradas.wlk`, `bandas.wlk`, `abonos.wlk`, `asistentes.wlk`) ·

## Decisiones de diseño

**1. La productora es un objeto bien conocido (`object productora`).**
Hay una sola productora, y el impuesto es el mismo para todas las entradas y lo puede cambiar cuando quiera. Un objeto único evita pasar la productora por parámetro a todos lados. Concentra los reportes porque es quien conoce las bandas y las entradas vendidas.

**2. El precio de la entrada queda fijo al emitirla.**
`Entrada` calcula `1000 + productora.impuesto()` al crearse. Si el impuesto cambia después, lo recaudado no se altera. Es lo que pasaría en la realidad: lo que ya se cobró, ya se cobró.

**3. El abono es un objeto aparte (composición), no una subclase de `Asistente`.**
El asistente *tiene un* abono (`AbonoFan` o `AbonoVip`). Si `Asistente` tuviera subclases `AsistenteFan` y `AsistenteVip`, un asistente no podría pasar de fan a vip sin dejar de ser él mismo. Además `bonificar()` es solo delegación: `asistente.bonificar()` → `abono.bonificar()`. El descuento propio de cada vip queda guardado en su abono.

**4. `Banda` es una clase abstracta con método template.**
`presupuesto()` = `canon()` + `gastoExtra()` está escrito una sola vez en `Banda`. `gastoExtra()` y `popularidad()` son abstractos y cada subtipo (`Rock`, `Trap`, `Indie`) los implementa. `canon()` tiene un valor por defecto (1.000.000) que solo redefine `Trap`.

**5. Las reglas de negocio de la compra viven en el asistente.**
`comprarEntrada` valida primero (si falla, no se modifica nada: ni dinero, ni historial, ni ventas de la productora) y recién después descuenta, agrega al historial y registra la venta.

**6. Solo se exponen los accessors necesarios.**
`entradas()` devuelve una copia para que nadie pueda modificar el historial desde afuera. Las colecciones de la productora no se exponen.

**6. Decidi usar test con el fin de que encontrar errores y ver si todo esta correcto.**

## Conceptos de la materia usados

1. **Polimorfismo** – La productora le pide `presupuesto()` a cualquier banda y no le importa si es rock, trap o indie. El asistente le pide `precioFinal()` a su abono sin saber si es fan o vip. Todo esto permite agregar una banda o un abono nuevo sin tocar el código que los usa.
2. **Herencia, clase abstracta y redefinición** – `Banda` y `Abono` son abstractas (`gastoExtra()`, `popularidad()`, `descuento()`, `bonificar()` sin implementación). Se justifica porque el comportamiento común (`presupuesto()`, `precioFinal()`) se escribe una sola vez y no se repite lógica entre clases. `Trap` redefine `canon()` y usa **`super()`** para reutilizar el canon base: `self.popularidad() * super()`.
3. **Composición (herencia vs composición)** – `Asistente` → `Abono`. Se justifica en la decisión 3: el abono es un rol que puede cambiar, y la composición lo permite con `asistente.abono(nuevoAbono)`.
4. **Colecciones** – `filter` (entradas del año anterior), `map` + `asSet` (nombres de bandas sin repetidos), `sum` (recaudación y presupuesto total), `count` y `max` (banda más popular). Se justifica porque son mensajes de alto nivel que expresan *qué* se quiere, sin recorridos a mano. Se usa un `Set` para las bandas de la productora porque no tiene sentido tener repetidas.
5. **Manejo de errores (excepciones)** – Si el asistente no tiene saldo positivo se lanza `DomainException` con un mensaje claro. Se justifica porque notifica el error sin devolver valores "especiales", y el estado queda intacto porque se valida antes de modificar. Está testeado con `assert.throwsExceptionWithMessage`.
6. **Encapsulamiento y responsabilidad** – Cada objeto resuelve lo suyo: la banda sabe su presupuesto, la entrada su precio, el abono su descuento, y el asistente se encarga de su historial y su dinero. Nadie accede a atributos de otro para calcular por él.
7. **Objetos bien conocidos** – `productora` (decisión 1).
8. **Testing** – Tests por cada regla (bandas, compra, abonos, reportes), incluyendo casos borde: saldo cero, saldo que queda negativo, bandas sin ventas y cambio de impuesto posterior a la venta.

