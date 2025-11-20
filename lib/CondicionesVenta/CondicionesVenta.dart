import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ContratoData/ContratoData.dart';

// ==========================================
// ENUMS
// ==========================================
enum TipoVenta { nueva, upGrade, downGrade, sameGrade }

enum TipoPago { financiado, contado }

enum TipoTabla { predeterminada, modificada }

enum EngancheTipo { porcentaje, monto }

// ==========================================
// DATOS ESTÁTICOS
// ==========================================
class _Catalogos {
  static const List<String> unidades = [
    "Aqua Points",
    "Gold Small Luxury",
    "Imperial Aqua 2",
    "Junior Club",
    "Junior Sands",
    "Master Club",
    "Master Golf",
    "Master SPA",
    "Premium Points",
    "Senior Golf",
    "Senior SPA",
    "Premium Deluxe",
  ];
  static const List<String> temporadas = ["Plata", "Oro", "Platino"];
  static const List<String> proyectos = [
    "38 - PREMIUM POINTS D",
    "Proyecto B",
    "Proyecto C",
  ];
}

// ==========================================
// ESTILOS GLOBALES
// ==========================================
const Color kColorLabel = Color(0xFFA00000); // Rojo oscuro
const Color kColorHeader = Color.fromRGBO(8, 12, 36, 1); // Azul oscuro
final TextStyle kLabelStyle = TextStyle(
  color: kColorLabel,
  fontWeight: FontWeight.bold,
  fontSize: 12,
);
final TextStyle kSuffixStyle = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.bold,
  fontSize: 11,
);

// ==========================================
// WIDGET PRINCIPAL
// ==========================================
class CondicionesVenta extends StatelessWidget {
  final ContratoData datosContrato;
  const CondicionesVenta({super.key, required this.datosContrato});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: kColorHeader,
        title: const Text(
          "Condiciones de Venta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => _logout(context),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: const CondicionesVentaView(),
        ),
      ),
    );
  }
}

// ==========================================
// VISTA DE FORMULARIO
// ==========================================
class CondicionesVentaView extends StatefulWidget {
  const CondicionesVentaView({super.key});

  @override
  State<CondicionesVentaView> createState() => _CondicionesVentaViewState();
}

class _CondicionesVentaViewState extends State<CondicionesVentaView> {
  // --- VARIABLES DE ESTADO ---
  TipoVenta _tipoVenta = TipoVenta.upGrade;
  TipoPago _tipoPago = TipoPago.financiado;
  TipoTabla _tipoTabla = TipoTabla.predeterminada;
  EngancheTipo _engancheTipo = EngancheTipo.porcentaje;

  String _moneda = "MN";
  String? _unidadSeleccionada;
  String? _temporadaSeleccionada;
  String? _proyectoSeleccionado;
  String? _disponiblesSeleccionado;

  bool _tieneContratoComplemento = false;
  bool _sinCostoContrato = false;
  bool _ventaEnPaquete = false;

  // --- CONTROLADORES ---
  final _noContratoInventarioCtrl = TextEditingController();
  final _ctoBeneficioCtrl = TextEditingController();
  final _xrefCtrl = TextEditingController();
  final _noAniosCtrl = TextEditingController();
  final _anioUsoCtrl = TextEditingController();
  final _puntosAdquiridosCtrl = TextEditingController();

  final _tipoCambioCtrl = TextEditingController(text: "20.0000");
  final _precioBrutoCtrl = TextEditingController();
  final _montoCuentaCtrl = TextEditingController();
  final _noContratosVentaCtrl = TextEditingController();
  final _precioNetoCtrl = TextEditingController();

  final _enganchePorcCtrl = TextEditingController();
  final _engancheMontoCtrl = TextEditingController();
  final _engancheSalaCtrl = TextEditingController();
  final _porcentajeSalaCtrl = TextEditingController();
  final _variosDescCtrl = TextEditingController();
  final _noDescuentosCtrl = TextEditingController();
  final _engancheDiferidoCtrl = TextEditingController(text: "25,099.98");
  final _noPagosDiferidoCtrl = TextEditingController();
  final _saldoEngancheCtrl = TextEditingController();
  final _montoFinanciarCtrl = TextEditingController();
  final _costoContratoCtrl = TextEditingController();
  final _totalPagoSalaCtrl = TextEditingController();
  final _costoMembresiaCtrl = TextEditingController();

  final _tasaCtrl = TextEditingController();
  final _noPagosResumenCtrl = TextEditingController();
  final _pagoFijoCtrl = TextEditingController();

  @override
  void dispose() {
    _noContratoInventarioCtrl.dispose();
    _ctoBeneficioCtrl.dispose();
    _xrefCtrl.dispose();
    _noAniosCtrl.dispose();
    _anioUsoCtrl.dispose();
    _puntosAdquiridosCtrl.dispose();
    _tipoCambioCtrl.dispose();
    _precioBrutoCtrl.dispose();
    _montoCuentaCtrl.dispose();
    _noContratosVentaCtrl.dispose();
    _precioNetoCtrl.dispose();
    _enganchePorcCtrl.dispose();
    _engancheMontoCtrl.dispose();
    _engancheSalaCtrl.dispose();
    _porcentajeSalaCtrl.dispose();
    _variosDescCtrl.dispose();
    _noDescuentosCtrl.dispose();
    _engancheDiferidoCtrl.dispose();
    _noPagosDiferidoCtrl.dispose();
    _saldoEngancheCtrl.dispose();
    _montoFinanciarCtrl.dispose();
    _costoContratoCtrl.dispose();
    _totalPagoSalaCtrl.dispose();
    _costoMembresiaCtrl.dispose();
    _tasaCtrl.dispose();
    _noPagosResumenCtrl.dispose();
    _pagoFijoCtrl.dispose();
    super.dispose();
  }

  void _limpiarDatosVenta() {
    setState(() {
      _moneda = "MN";
      _tipoPago = TipoPago.financiado;
      _engancheTipo = EngancheTipo.porcentaje;
      _tieneContratoComplemento = false;
      _sinCostoContrato = false;
      _ventaEnPaquete = false;

      _tipoCambioCtrl.text = "20.0000";
      _precioBrutoCtrl.clear();
      _montoCuentaCtrl.clear();
      _noContratosVentaCtrl.clear();
      _precioNetoCtrl.clear();
      _enganchePorcCtrl.clear();
      _engancheMontoCtrl.clear();
      _engancheSalaCtrl.clear();
      _porcentajeSalaCtrl.clear();
      _variosDescCtrl.clear();
      _noDescuentosCtrl.clear();
      _engancheDiferidoCtrl.clear();
      _noPagosDiferidoCtrl.clear();
      _saldoEngancheCtrl.clear();
      _montoFinanciarCtrl.clear();
      _costoContratoCtrl.clear();
      _totalPagoSalaCtrl.clear();
      _costoMembresiaCtrl.clear();
      _tasaCtrl.clear();
      _noPagosResumenCtrl.clear();
      _pagoFijoCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInventarioAdquirido(),
        const SizedBox(height: 15),
        _buildDatosVenta(),
      ],
    );
  }

  // ============================================================
  // SECCIÓN 1: INVENTARIO ADQUIRIDO
  // ============================================================
  Widget _buildInventarioAdquirido() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const AppHeader(text: "INVENTARIO ADQUIRIDO"),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // FILA 1
                Row(
                  children: [
                    Text("Tipo Venta:", style: kLabelStyle),
                    const SizedBox(width: 8),
                    _radioCompacto(
                      "Nueva",
                      TipoVenta.nueva,
                      (v) => _tipoVenta = v,
                    ),
                    const SizedBox(width: 4),
                    _radioCompacto(
                      "Up Grade",
                      TipoVenta.upGrade,
                      (v) => _tipoVenta = v,
                    ),
                    const SizedBox(width: 4),
                    _radioCompacto(
                      "Down Grade",
                      TipoVenta.downGrade,
                      (v) => _tipoVenta = v,
                    ),
                    const SizedBox(width: 4),
                    _radioCompacto(
                      "Same Grade",
                      TipoVenta.sameGrade,
                      (v) => _tipoVenta = v,
                    ),
                    const Spacer(),
                    Text("No. Contrato:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 80,
                      child: _inputDirecto(_noContratoInventarioCtrl),
                    ),
                    const SizedBox(width: 10),
                    Text("Cto Beneficio:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 60,
                      child: _inputDirecto(_ctoBeneficioCtrl),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // FILA 2: Unidad y Temporada
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text("Unidad:", style: kLabelStyle),
                    ),
                    SizedBox(
                      width: 220,
                      child: _dropdownDirecto(
                        items: _Catalogos.unidades,
                        value: _unidadSeleccionada,
                        onChanged: (v) =>
                            setState(() => _unidadSeleccionada = v),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text("Temporada:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 130,
                      child: _dropdownDirecto(
                        items: _Catalogos.temporadas,
                        value: _temporadaSeleccionada,
                        onChanged: (v) =>
                            setState(() => _temporadaSeleccionada = v),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),

                // FILA 3: Xref y Proyecto
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text("Xref:", style: kLabelStyle),
                    ),
                    SizedBox(width: 150, child: _inputDirecto(_xrefCtrl)),
                    const SizedBox(width: 20),
                    Text("Proyecto:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 150,
                      child: _dropdownDirecto(
                        items: _Catalogos.proyectos,
                        value: _proyectoSeleccionado,
                        onChanged: (v) =>
                            setState(() => _proyectoSeleccionado = v),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 12),

                // FILA 4: Años, Año Uso (Izquierda), Botón Limpiar
                Row(
                  children: [
                    Text("No. de Años:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(width: 40, child: _inputDirecto(_noAniosCtrl)),

                    const SizedBox(width: 20),

                    Text("Año 1er Uso:", style: kLabelStyle),
                    const SizedBox(width: 5),
                    SizedBox(width: 50, child: _inputDirecto(_anioUsoCtrl)),

                    const Spacer(),

                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cleaning_services, size: 16),
                      label: const Text("Limpiar Inventario"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // FILA 5: FIELDSET TABLAS
                _buildFieldset(
                  label: "Tablas de Puntos",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Columna Izquierda (Tabla)
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                "1er Tabla",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Columna Derecha (Controles)
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Disponibles:",
                              style: TextStyle(
                                color: kColorLabel,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: _dropdownDirecto(
                                    items: [],
                                    value: _disponiblesSeleccionado,
                                    onChanged: (v) {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  "Puntos Adquiridos:",
                                  style: TextStyle(
                                    color: kColorLabel,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 80,
                                  child: _inputDirecto(_puntosAdquiridosCtrl),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_note, size: 16),
                                    label: const Text(
                                      "Editar Tabla",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // AQUI ESTABA EL FIELDSET "TIPO DE TABLA", AHORA SOLO ROW
                            Row(
                              children: [
                                _radioCompacto(
                                  "Predeterminada",
                                  TipoTabla.predeterminada,
                                  (v) => _tipoTabla = v,
                                ),
                                const SizedBox(width: 8),
                                _radioCompacto(
                                  "Modificada",
                                  TipoTabla.modificada,
                                  (v) => _tipoTabla = v,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECCIÓN 2: DATOS DE LA VENTA
  // ============================================================
  Widget _buildDatosVenta() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 950;

        Widget contenido = isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildColumnaIzquierda()),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: _buildColumnaDerecha()),
                ],
              )
            : Column(
                children: [
                  _buildColumnaIzquierda(),
                  const SizedBox(height: 20),
                  _buildColumnaDerecha(),
                ],
              );

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              const AppHeader(text: "DATOS DE LA VENTA"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    contenido,
                    const Divider(height: 30, thickness: 1),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _ventaEnPaquete,
                            onChanged: (v) =>
                                setState(() => _ventaEnPaquete = v!),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Venta en Paquete",
                          style: kLabelStyle.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _limpiarDatosVenta,
                          icon: const Icon(Icons.cleaning_services, size: 16),
                          label: const Text("Limpiar Datos Venta"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColumnaIzquierda() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 60, child: Text("Moneda:", style: kLabelStyle)),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 30,
                child: DropdownButtonFormField<String>(
                  value: _moneda,
                  decoration: _inputDeco(),
                  items: ["MN", "USD"]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _moneda = v!),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text("Tipo Cambio:", style: kLabelStyle),
            const SizedBox(width: 5),
            Expanded(flex: 2, child: _inputDirecto(_tipoCambioCtrl)),
            const Spacer(flex: 3),
          ],
        ),
        const SizedBox(height: 8),
        _rowLabelInput(
          "Precio Bruto:",
          _precioBrutoCtrl,
          suffix: "MN",
          prefix: "\$",
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text("- Monto a Cuenta:", style: kLabelStyle),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: _inputDirecto(_montoCuentaCtrl, prefix: "\$"),
            ),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 10),
            _smallButton("..."),
            const SizedBox(width: 10),
            Text(
              "No. Contratos:",
              style: kLabelStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(width: 5),
            SizedBox(width: 50, child: _inputDirecto(_noContratosVentaCtrl)),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        _rowLabelInput(
          "Precio Neto:",
          _precioNetoCtrl,
          suffix: "MN",
          prefix: "\$",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text("Tipo de Pago:", style: kLabelStyle),
              const SizedBox(width: 10),
              Row(
                children: [
                  _radioPago("Financiado", TipoPago.financiado),
                  const SizedBox(width: 10),
                  _radioPago("Contado", TipoPago.contado),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: 100, child: Text("Enganche:", style: kLabelStyle)),
            const SizedBox(width: 5),
            SizedBox(width: 90, child: _inputDirecto(_enganchePorcCtrl)),
            const SizedBox(width: 5),
            Text("%  ó", style: kSuffixStyle),
            const SizedBox(width: 5),
            SizedBox(
              width: 90,
              child: _inputDirecto(_engancheMontoCtrl, prefix: "\$"),
            ),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 15),
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _tieneContratoComplemento,
                onChanged: (v) =>
                    setState(() => _tieneContratoComplemento = v!),
              ),
            ),
            Text("Contrato Complemento", style: kLabelStyle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 20),
            Text("Enganche a Pagar en Sala:", style: kLabelStyle),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_engancheSalaCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 15),
            SizedBox(width: 60, child: _inputDirecto(_porcentajeSalaCtrl)),
            const SizedBox(width: 5),
            Text("%", style: kSuffixStyle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 50),
            Text("- Varios (Desc):", style: kLabelStyle),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_variosDescCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 10),
            _smallButton("..."),
            const SizedBox(width: 5),
            Text(
              "No.Descuentos:",
              style: kLabelStyle.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(width: 5),
            SizedBox(width: 40, child: _inputDirecto(_noDescuentosCtrl)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 50),
            Text(
              "Enganche Diferido:",
              style: kLabelStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_engancheDiferidoCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 10),
            Text("No. Pagos:", style: kLabelStyle),
            const SizedBox(width: 5),
            SizedBox(width: 40, child: _inputDirecto(_noPagosDiferidoCtrl)),
            const SizedBox(width: 5),
            _smallButton("..."),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 50),
            Text(
              "Saldo Enganche:",
              style: kLabelStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_saldoEngancheCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
          ],
        ),
        const Divider(height: 20),
        _rowLabelInput(
          "Monto a Financiar:",
          _montoFinanciarCtrl,
          suffix: "MN",
          prefix: "\$",
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text("Costo de Contrato:", style: kLabelStyle),
            ),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_costoContratoCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 10),
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _sinCostoContrato,
                onChanged: (v) => setState(() => _sinCostoContrato = v!),
              ),
            ),
            Text("Sin Costo Contrato", style: kLabelStyle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "Total Pago en Sala:",
              style: kLabelStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_totalPagoSalaCtrl, prefix: "\$")),
            const SizedBox(width: 5),
            Text("MN", style: kSuffixStyle),
            const SizedBox(width: 10),
            Text(
              "Costo membresía:",
              style: kLabelStyle.copyWith(color: Colors.black87),
            ),
            const SizedBox(width: 5),
            Expanded(child: _inputDirecto(_costoMembresiaCtrl, prefix: "\$")),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnaDerecha() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TABLA TARIFA
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
          height: 150,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "Tarifa de Mantenimiento de Unidades",
                  style: kLabelStyle.copyWith(fontSize: 11),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowHeight: 30,
                    dataRowMinHeight: 25,
                    dataRowMaxHeight: 30,
                    headingRowColor: MaterialStateProperty.all(kColorHeader),
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Unidad",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Tarifa",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                    rows: const [
                      DataRow(
                        cells: [
                          DataCell(Text("JR SANDS PLUS")),
                          DataCell(Text("19,300.00")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("JUNIOR CLUB")),
                          DataCell(Text("17,700.00")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("MASTER CLUB")),
                          DataCell(Text("22,900.00")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // RESUMEN DE PAGOS
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade600, width: 1),
                  left: BorderSide(color: Colors.grey.shade600, width: 1),
                  right: BorderSide(color: Colors.white, width: 1),
                  bottom: BorderSide(color: Colors.white, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _textoResumen("59 pagos de", "\$4,828.03"),
                        _textoResumen("1 pagos de", "\$4,828.43"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _rowResumenInput("Tasa %", _tasaCtrl),
                        const SizedBox(height: 4),
                        _rowResumenInput("Periodo:", null, isDropdown: true),
                        const SizedBox(height: 4),
                        _rowResumenInput("No Pagos:", _noPagosResumenCtrl),
                        const SizedBox(height: 4),
                        _rowResumenInput("Pago Fijo:", _pagoFijoCtrl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: const Color(0xFFE0E0E0),
                child: Text("Resumen de pagos", style: kLabelStyle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // WIDGETS AUXILIARES GENERALES
  // ============================================================

  Widget _buildFieldset({
    required String label,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: padding ?? const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: child,
        ),
        Positioned(
          left: 10,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowLabelInput(
    String label,
    TextEditingController ctrl, {
    String? suffix,
    String? prefix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: kLabelStyle)),
          const SizedBox(width: 5),
          Expanded(child: _inputDirecto(ctrl, prefix: prefix)),
          if (suffix != null) ...[
            const SizedBox(width: 5),
            Text(suffix, style: kSuffixStyle),
          ],
        ],
      ),
    );
  }

  Widget _inputDirecto(
    TextEditingController ctrl, {
    String? prefix,
    Color? fillColor,
  }) {
    return SizedBox(
      height: 24,
      child: TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          prefixText: prefix,
          prefixStyle: const TextStyle(color: Colors.black, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _dropdownDirecto({
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    Color? fillColor,
  }) {
    return SizedBox(
      height: 24,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDeco() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget _smallButton(String text) {
    return SizedBox(
      width: 30,
      height: 24,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[200],
          side: const BorderSide(color: Colors.grey),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      ),
    );
  }

  Widget _radioPago(String text, TipoPago val) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Radio<TipoPago>(
            value: val,
            groupValue: _tipoPago,
            onChanged: (v) => setState(() => _tipoPago = v!),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _radioCompacto(String txt, dynamic val, Function(dynamic) onC) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Radio(
            value: val,
            groupValue: val is TipoVenta ? _tipoVenta : _tipoTabla,
            onChanged: (v) => setState(() => onC(v)),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Text(
          txt,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _textoResumen(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            right,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowResumenInput(
    String label,
    TextEditingController? ctrl, {
    bool isDropdown = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: kLabelStyle.copyWith(color: kColorHeader, fontSize: 11),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 70,
          height: 22,
          child: isDropdown
              ? DropdownButtonFormField(
                  items: const [],
                  onChanged: null,
                  decoration: _inputDeco(),
                )
              : TextField(
                  controller: ctrl,
                  decoration: _inputDeco(),
                  style: const TextStyle(fontSize: 11),
                ),
        ),
      ],
    );
  }
}

// ==========================================
// HEADER AZUL
// ==========================================
class AppHeader extends StatelessWidget {
  final String text;
  const AppHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: kColorHeader,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
