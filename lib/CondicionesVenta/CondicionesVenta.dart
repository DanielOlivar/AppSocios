import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Asegúrate de que esta ruta sea correcta en tu proyecto
import '../ContratoData/ContratoData.dart'; 

enum TipoVenta { nueva, upGrade, downGrade, sameGrade }
enum TipoPago { financiado, contado }
enum TipoTabla { predeterminada, modificada }
enum EngancheTipo { porcentaje, monto }

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
}

// ==========================================
// WIDGET PRINCIPAL
// ==========================================
class CondicionesVenta extends StatelessWidget {
  final ContratoData datosContrato;
  const CondicionesVenta({super.key, required this.datosContrato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(8, 12, 36, 1),
        title: const Text(
          "Condiciones de Venta",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => _logout(context),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 12.0),
                child: Text(
                  "Bienvenido, ${datosContrato.nombre.isNotEmpty ? datosContrato.nombre : 'Usuario'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: CondicionesVentaView(),
        ),
      ),
    );
  }
}

// ==========================================
// VISTA DE FORMULARIO (STATEFUL)
// ==========================================
class CondicionesVentaView extends StatefulWidget {
  @override
  State<CondicionesVentaView> createState() => _CondicionesVentaViewState();
}

class _CondicionesVentaViewState extends State<CondicionesVentaView> {
  // Variables de Estado General
  TipoVenta _tipoVenta = TipoVenta.nueva;
  TipoPago _tipoPago = TipoPago.financiado;
  TipoTabla _tipoTabla = TipoTabla.predeterminada;
  EngancheTipo _engancheTipo = EngancheTipo.porcentaje;

  // --- VARIABLES PARA DROPDOWNS (NUEVO) ---
  final List<String> _opcionesUnidad = [
    "Senior Beach",
    "Senior Club",
    "Senior Golf",
    "Senior King",
    "Senior Queen Grand",
    "Senior Sands",
    "Senior Sands Penthouse",
    "Senior Sands Princess"
  ];

  final List<String> _opcionesTemporada = [
    "Plata",
    "Oro",
    "Platino"
  ];

  String? _unidadSeleccionada;
  String? _temporadaSeleccionada;
  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInventarioAdquirido(),
        SizedBox(height: 16),
        _buildDatosVenta(),
      ],
    );
  }

  // SECCIÓN 1: INVENTARIO ADQUIRIDO
  Widget _buildInventarioAdquirido() {
    bool isWide = MediaQuery.of(context).size.width > 900;

    return Card(
      child: Column(
        children: [
          _buildHeader("INVENTARIO ADQUIRIDO"),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Fila 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tipo Venta:"),
                    Expanded(
                      flex: 1,
                      child: _buildRadioTipo("Nueva", TipoVenta.nueva),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRadioTipo("Up Grade", TipoVenta.upGrade),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRadioTipo("Down Grade", TipoVenta.downGrade),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRadioTipo("Same Grade", TipoVenta.sameGrade),
                    ),
                    SizedBox(width: 16),
                    Expanded(flex: 2, child: _campo("No. Contrato")),
                    SizedBox(width: 8),
                    Expanded(flex: 2, child: _campo("Cto Beneficio")),
                  ],
                ),
                SizedBox(height: 8),
                
                // Fila 2 (AQUÍ ESTÁN LOS CAMBIOS)
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _campo(
                        "Unidad", 
                        esDropdown: true,
                        items: _opcionesUnidad,
                        valorSeleccionado: _unidadSeleccionada,
                        onDropdownChanged: (val) => setState(() => _unidadSeleccionada = val),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1, 
                      child: _campo(
                        "Temporada",
                        esDropdown: true,
                        items: _opcionesTemporada,
                        valorSeleccionado: _temporadaSeleccionada,
                        onDropdownChanged: (val) => setState(() => _temporadaSeleccionada = val),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(flex: 2, child: _campo("Xref")),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: _campo("Proyecto", esDropdown: true), // Este sigue genérico si no tienes lista
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // Fila 3
                Row(
                  children: [
                    Expanded(flex: 1, child: _campo("No. de Años")),
                    SizedBox(width: 8),
                    Expanded(flex: 1, child: _campo("Año 1er Uso")),
                    Spacer(flex: 3),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _unidadSeleccionada = null;
                          _temporadaSeleccionada = null;
                        });
                      },
                      child: Text("Limpiar Inventario"),
                    ),
                  ],
                ),
                Divider(height: 24),
                // Fila 4
                isWide ? _buildTablaPuntosWide() : _buildTablaPuntosNarrow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTipo(String titulo, TipoVenta valor) {
    return RadioListTile<TipoVenta>(
      title: Text(titulo, style: TextStyle(fontSize: 12)),
      value: valor,
      groupValue: _tipoVenta,
      dense: true,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => setState(() => _tipoVenta = v!),
    );
  }

  // ... (Resto de métodos de tablas sin cambios mayores, solo visualización)

  Widget _buildTablaPuntosWide() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text("Tablas de Puntos", style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            ElevatedButton(onPressed: () {}, child: Text("1er Tabla")),
          ],
        ),
        SizedBox(width: 8),
        Expanded(flex: 3, child: _buildDataTablePuntos()),
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _campo("Disponibles", esDropdown: true),
              _campo("Puntos Adquiridos"),
              SizedBox(height: 4),
              ElevatedButton(onPressed: () {}, child: Text("Editar Tabla")),
              Text("Tipo de Tabla", style: TextStyle(fontSize: 12)),
              Row(
                children: [
                  Expanded(
                    child: _buildRadioTabla("Predeterminada", TipoTabla.predeterminada),
                  ),
                  Expanded(
                    child: _buildRadioTabla("Modificada", TipoTabla.modificada),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTablaPuntosNarrow() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Text("Tablas de Puntos", style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                ElevatedButton(onPressed: () {}, child: Text("1er Tabla")),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _campo("Disponibles", esDropdown: true),
                  _campo("Puntos Adquiridos"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildDataTablePuntos(),
        SizedBox(height: 8),
        ElevatedButton(onPressed: () {}, child: Text("Editar Tabla")),
        Text("Tipo de Tabla", style: TextStyle(fontSize: 12)),
        Row(
          children: [
            Expanded(
              child: _buildRadioTabla("Predeterminada", TipoTabla.predeterminada),
            ),
            Expanded(
              child: _buildRadioTabla("Modificada", TipoTabla.modificada),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioTabla(String titulo, TipoTabla valor) {
    return RadioListTile<TipoTabla>(
      title: Text(titulo, style: TextStyle(fontSize: 12)),
      value: valor,
      groupValue: _tipoTabla,
      dense: true,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => setState(() => _tipoTabla = v!),
    );
  }

  Widget _buildDataTablePuntos() {
    final rows = [
      DataRow(cells: [
        DataCell(Text("ENTRE SEMANA")), DataCell(Text("100")), DataCell(Text("100")), DataCell(Text("100")), DataCell(Text("135")),
      ]),
      DataRow(cells: [
        DataCell(Text("FIN DE SEMANA")), DataCell(Text("200")), DataCell(Text("200")), DataCell(Text("200")), DataCell(Text("270")),
      ]),
      DataRow(cells: [
        DataCell(Text("SEMANA COMPLETA")), DataCell(Text("1000")), DataCell(Text("1000")), DataCell(Text("1000")), DataCell(Text("1350")),
      ]),
    ];

    final columns = [
      DataColumn(label: Text("Periodo")),
      DataColumn(label: Text("JUNIOR CLUB")),
      DataColumn(label: Text("SENIOR GOLF")),
      DataColumn(label: Text("SENIOR SPA")),
      DataColumn(label: Text("JR SANDS PLUS")),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: columns, rows: rows),
    );
  }

  // SECCIÓN 2: DATOS DE LA VENTA
  Widget _buildDatosVenta() {
    bool isWide = MediaQuery.of(context).size.width > 1000;

    return Card(
      child: Column(
        children: [
          _buildHeader("DATOS DE LA VENTA"),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildDatosVentaColIzquierda()),
                          SizedBox(width: 16),
                          Expanded(flex: 2, child: _buildDatosVentaColMedio()),
                          SizedBox(width: 16),
                          Expanded(flex: 2, child: _buildDatosVentaColDerecha()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDatosVentaColIzquierda(),
                          Divider(height: 24),
                          _buildDatosVentaColMedio(),
                          Divider(height: 24),
                          _buildDatosVentaColDerecha(),
                        ],
                      ),
                Divider(height: 24),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (v) {}),
                    Text("Venta en Paquete"),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Limpiar Datos Venta"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatosVentaColIzquierda() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _campo("Moneda", esDropdown: true)),
            SizedBox(width: 8),
            Expanded(child: _campo("Tipo Cambio")),
          ],
        ),
        _campo("Precio Bruto"),
        _campo("Monto a Cuenta"),
        _campo("Precio Neto"),

        Row(
          children: [
            Text("Tipo de Pago:"),
            Expanded(
              child: RadioListTile<TipoPago>(
                title: Text("Financiado", style: TextStyle(fontSize: 12)),
                value: TipoPago.financiado,
                groupValue: _tipoPago,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _tipoPago = v!),
              ),
            ),
            Expanded(
              child: RadioListTile<TipoPago>(
                title: Text("Contado", style: TextStyle(fontSize: 12)),
                value: TipoPago.contado,
                groupValue: _tipoPago,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _tipoPago = v!),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 3, child: _campo("Enganche")),
            Expanded(
              flex: 2,
              child: RadioListTile<EngancheTipo>(
                title: Text("%", style: TextStyle(fontSize: 12)),
                value: EngancheTipo.porcentaje,
                groupValue: _engancheTipo,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _engancheTipo = v!),
              ),
            ),
            Expanded(
              flex: 2,
              child: RadioListTile<EngancheTipo>(
                title: Text("\$", style: TextStyle(fontSize: 12)),
                value: EngancheTipo.monto,
                groupValue: _engancheTipo,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _engancheTipo = v!),
              ),
            ),
            Expanded(flex: 3, child: _campo("Contrato Complemento")),
          ],
        ),

        _campo("Enganche a Pagar en Sala"),
        _campo("Varios (Desc)"),
        _campo("Enganche Diferido"),
        _campo("Saldo Enganche"),
        _campo("Monto a Financiar"),

        Row(
          children: [
            Expanded(child: _campo("Costo de Contrato")),
            SizedBox(width: 8),
            Checkbox(value: false, onChanged: (v) {}),
            Text("Sin Costo Contrato", style: TextStyle(fontSize: 12)),
          ],
        ),

        _campo("Total Pago en Sala"),
        _campo("Costo membresía"),
      ],
    );
  }

  Widget _buildDatosVentaColMedio() {
    final rows = [
      DataRow(cells: [DataCell(Text("JR SANDS PLUS")), DataCell(Text("19,300.00"))]),
      DataRow(cells: [DataCell(Text("JUNIOR CLUB")), DataCell(Text("17,700.00"))]),
      DataRow(cells: [DataCell(Text("MASTER CLUB")), DataCell(Text("22,900.00"))]),
      DataRow(cells: [DataCell(Text("MASTER GOLF")), DataCell(Text("20,600.00"))]),
      DataRow(cells: [DataCell(Text("MASTER SPA")), DataCell(Text("19,300.00"))]),
    ];

    final columns = [
      DataColumn(label: Text("Unidad")),
      DataColumn(label: Text("Tarifa")),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarifa de Mantenimiento de Unidades",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DataTable(columns: columns, rows: rows),
      ],
    );
  }

  Widget _buildDatosVentaColDerecha() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Resumen de pagos", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("24 pagos de", style: TextStyle(fontSize: 12)),
              Text(
                "\$6,250.00",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        _campo("Tasa %"),
        _campo("Periodo", esDropdown: true),
        _campo("No Pagos"),
        _campo("Pago Fijo"),
      ],
    );
  }

  // ==========================================
  // WIDGETS AUXILIARES MEJORADOS
  // ==========================================
  Widget _buildHeader(String text) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(8),
    color: const Color.fromRGBO(8, 12, 36, 1),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Widget _campo(
    String label, {
    bool doble = false,
    bool triple = false,
    String? valorFijo,
    bool esDropdown = false,
    // Nuevos parámetros para Dropdown dinámico
    List<String>? items, 
    String? valorSeleccionado,
    ValueChanged<String?>? onDropdownChanged,
    List<TextEditingController>? controllers,
  }) {
    if (doble) assert(controllers == null || controllers.length == 2);
    if (triple) assert(controllers == null || controllers.length == 3);
    if (valorFijo == null && !doble && !triple && !esDropdown)
      assert(controllers == null || controllers.length == 1);

    Widget inputWidget;

    // 1. Lógica de Dropdown
    if (esDropdown) {
      final listaOpciones = items ?? ["Opción Genérica"]; 
      
      inputWidget = DropdownButtonFormField<String>(
        value: valorSeleccionado,
        isExpanded: true, // Evita overflow con textos largos
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(),
        ),
        items: listaOpciones.map((String opcion) {
          return DropdownMenuItem<String>(
            value: opcion,
            child: Text(opcion, style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onDropdownChanged ?? (v) {},
      );
    } 
    // 2. Lógica de Texto Fijo
    else if (valorFijo != null) {
      inputWidget = TextFormField(initialValue: valorFijo, enabled: false);
    } 
    // 3. Lógica de Campo Doble
    else if (doble) {
      inputWidget = Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controllers != null ? controllers[0] : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controllers != null ? controllers[1] : null,
            ),
          ),
        ],
      );
    } 
    // 4. Lógica de Campo Triple
    else if (triple) {
      inputWidget = Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controllers != null ? controllers[0] : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controllers != null ? controllers[1] : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controllers != null ? controllers[2] : null,
            ),
          ),
        ],
      );
    } 
    // 5. Lógica de Campo Simple (Default)
    else {
      inputWidget = TextFormField(
        controller: controllers != null ? controllers[0] : null,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          inputWidget,
        ],
      ),
    );
  }
}