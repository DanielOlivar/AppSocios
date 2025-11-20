import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==========================================
// ESTILOS VISUALES (Globales)
// ==========================================
const Color kColorLabelRed = Color(0xFFA00000); // Rojo oscuro
const Color kColorInputBg = Color(0xFFF5F0FA); // Violeta muy claro
const Color kColorHeader = Color.fromRGBO(8, 12, 36, 1); // Azul oscuro
const Color kColorBorder = Color(0xFF9E9E9E); // Gris bordes

final TextStyle kLabelStyle = TextStyle(
  color: kColorLabelRed, 
  fontWeight: FontWeight.bold, 
  fontSize: 11
);

// ==========================================
// WIDGET PRINCIPAL
// ==========================================
class Financiamiento extends StatefulWidget {
  const Financiamiento({super.key});

  @override
  State<Financiamiento> createState() => _FinanciamientoState();
}

class _FinanciamientoState extends State<Financiamiento> {
  // --- CONTROLADORES ---
  String _tipoPeriodo = "Mensual";
  final _montoFinanciarCtrl = TextEditingController(text: "359677.5");
  final _mensualidadFijaCtrl = TextEditingController(text: "0");
  final _numPagosCtrl = TextEditingController(text: "60");
  final _tasaInteresCtrl = TextEditingController(text: "10");
  final _fechaPrimerPagoCtrl = TextEditingController(text: "20/ jul. /2023");

  // Checkboxes laterales
  bool _mostrarTablaCompleta = true;
  bool _imprimirCapitalInteres = false;

  // Datos Dummy para la tabla
  final List<Map<String, String>> _rows = [
    {"no": "0", "fecha": "", "monto": "", "capital": "", "interes": "", "acum": "", "saldo": "\$359,677.50", "extra": ""},
    {"no": "1", "fecha": "20/jul./2023", "monto": "\$7,642.08", "capital": "\$4,644.77", "interes": "\$2,997.31", "acum": "\$4,644.77", "saldo": "\$355,032.73", "extra": "\$0.00"},
    {"no": "2", "fecha": "20/ago./2023", "monto": "\$7,642.08", "capital": "\$4,683.47", "interes": "\$2,958.61", "acum": "\$9,328.24", "saldo": "\$350,349.26", "extra": "\$0.00"},
    {"no": "3", "fecha": "20/sep./2023", "monto": "\$7,642.08", "capital": "\$4,722.50", "interes": "\$2,919.58", "acum": "\$14,050.74", "saldo": "\$345,626.76", "extra": "\$0.00"},
    {"no": "4", "fecha": "20/oct./2023", "monto": "\$7,642.08", "capital": "\$4,761.86", "interes": "\$2,880.22", "acum": "\$18,812.60", "saldo": "\$340,864.90", "extra": "\$0.00"},
    {"no": "5", "fecha": "20/nov./2023", "monto": "\$7,642.08", "capital": "\$4,801.54", "interes": "\$2,840.54", "acum": "\$23,614.14", "saldo": "\$336,063.36", "extra": "\$0.00"},
    {"no": "6", "fecha": "20/dic./2023", "monto": "\$7,642.08", "capital": "\$4,841.55", "interes": "\$2,800.53", "acum": "\$28,455.69", "saldo": "\$331,221.81", "extra": "\$0.00"},
    {"no": "7", "fecha": "20/ene./2024", "monto": "\$7,642.08", "capital": "\$4,881.90", "interes": "\$2,760.18", "acum": "\$33,337.59", "saldo": "\$326,339.91", "extra": "\$0.00"},
    {"no": "8", "fecha": "20/feb./2024", "monto": "\$7,642.08", "capital": "\$4,922.58", "interes": "\$2,719.50", "acum": "\$38,260.17", "saldo": "\$321,417.33", "extra": "\$0.00"},
    {"no": "9", "fecha": "20/mar./2024", "monto": "\$7,642.08", "capital": "\$4,963.60", "interes": "\$2,678.48", "acum": "\$43,223.77", "saldo": "\$316,453.73", "extra": "\$0.00"},
    {"no": "10", "fecha": "20/abr./2024", "monto": "\$7,642.08", "capital": "\$5,004.97", "interes": "\$2,637.11", "acum": "\$48,228.74", "saldo": "\$311,448.76", "extra": "\$0.00"},
    {"no": "11", "fecha": "20/may./2024", "monto": "\$7,642.08", "capital": "\$5,046.67", "interes": "\$2,595.41", "acum": "\$53,275.41", "saldo": "\$306,402.09", "extra": "\$0.00"},
  ];

  @override
  void dispose() {
    _montoFinanciarCtrl.dispose(); _mensualidadFijaCtrl.dispose();
    _numPagosCtrl.dispose();
    _tasaInteresCtrl.dispose(); _fechaPrimerPagoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: kColorHeader,
        title: const Text("DATOS DEL FINANCIAMIENTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // SECCIÓN SUPERIOR: DATOS GENERALES Y RESUMEN
              SizedBox(
                height: 230, // CORREGIDO: Altura aumentada para evitar overflow
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IZQUIERDA: Datos Generales (Fieldset)
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              children: [
                                // Versión flotante
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: Text("ver 1.0.0.8.1", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                ),
                                const SizedBox(height: 5),
                                // Fila 1
                                Row(
                                  children: [
                                    _labelInput("Tipo de Periodo", width: 100),
                                    Expanded(child: _compactDropdown(["Mensual", "Anual"], _tipoPeriodo, (v) => setState(()=>_tipoPeriodo=v!))),
                                    const Spacer(), 
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Fila 2
                                Row(
                                  children: [
                                    _labelInput("Monto a Financiar", width: 100),
                                    Expanded(child: _compactInput(_montoFinanciarCtrl, alignRight: true)),
                                    const SizedBox(width: 15),
                                    _labelInput("Mensualidad Fija", width: 90),
                                    Expanded(child: _compactInput(_mensualidadFijaCtrl, alignRight: true)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Fila 3
                                Row(
                                  children: [
                                    _labelInput("Número de Pagos", width: 100),
                                    Expanded(child: _compactInput(_numPagosCtrl, alignRight: true)),
                                    const SizedBox(width: 15),
                                    _labelInput("Fecha Pago Adic.", width: 90),
                                    Expanded(child: _compactDropdown([], null, (v){})), 
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Fila 4
                                Row(
                                  children: [
                                    _labelInput("Tasa de Interés", width: 100),
                                    SizedBox(width: 60, child: _compactInput(_tasaInteresCtrl, alignRight: true)),
                                    const SizedBox(width: 5),
                                    Text("%", style: kLabelStyle),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Fila 5
                                Row(
                                  children: [
                                    _labelInput("Fecha primer pago", width: 100),
                                    Expanded(
                                      flex: 2,
                                      child: _compactInput(_fechaPrimerPagoCtrl, isDate: true)
                                    ),
                                    const Spacer(flex: 3),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 10, top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.grey[100],
                              child: const Text("Datos Generales", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // DERECHA: Resumen de pagos
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            width: double.infinity,
                            height: 220, // Ajustado para coincidir con la izquierda
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                _resumenRow("59", "pagos de", "\$7,642.08"),
                                _resumenRow(" 1", "pagos de", "\$7,642.37"),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 10, top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.grey[100], // Match fondo
                              child: Text("Resumen de pagos", style: kLabelStyle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              // HEADER TABLA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: kColorHeader,
                child: const Text(
                  "TABLA DE AMORTIZACION CALCULADA",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),

              // SECCIÓN INFERIOR: TABLA + CONTROLES
              SizedBox(
                height: 400, // Altura fija para esta sección
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TABLA
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            // Encabezado Manual de la Tabla
                            Container(
                              color: kColorHeader,
                              height: 25,
                              child: Row(
                                children: [
                                  _th("No", 30),
                                  _th("Fecha Pago", 80),
                                  _th("Monto", 70),
                                  _th("Capital", 70),
                                  _th("Interes", 70),
                                  _th("Capital Acumulado", 110),
                                  _th("Saldo", 80),
                                  _th("Pago Extraordinario", 110),
                                ],
                              ),
                            ),
                            // Contenido Scrollable
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: _rows.map((row) {
                                    final bool isEven = int.parse(row["no"]!) % 2 == 0;
                                    final bool isRedDate = row["no"] != "0"; 
                                    return Container(
                                      height: 20,
                                      color: isEven ? Colors.grey[100] : Colors.white,
                                      child: Row(
                                        children: [
                                          _td(row["no"]!, 30, alignRight: true),
                                          _td(row["fecha"]!, 80, color: isRedDate ? const Color(0xFFA00000) : Colors.black),
                                          _td(row["monto"]!, 70, alignRight: true),
                                          _td(row["capital"]!, 70, alignRight: true),
                                          _td(row["interes"]!, 70, alignRight: true),
                                          _td(row["acum"]!, 110, alignRight: true),
                                          _td(row["saldo"]!, 80, alignRight: true),
                                          _td(row["extra"]!, 110, alignRight: true),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),

                    // CONTROLES LATERALES
                    SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _bigButton("Calcular", Icons.flag),
                          const SizedBox(height: 40),
                          
                          // Checkbox 1
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24, width: 24,
                                child: Checkbox(value: _mostrarTablaCompleta, onChanged: (v)=>setState(()=>_mostrarTablaCompleta=v!)),
                              ),
                              const Expanded(
                                child: Text("Mostrar tabla\namortizacion\ncompleta", 
                                  style: TextStyle(color: kColorHeader, fontWeight: FontWeight.bold, fontSize: 11)),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Checkbox 2
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24, width: 24,
                                child: Checkbox(value: _imprimirCapitalInteres, onChanged: (v)=>setState(()=>_imprimirCapitalInteres=v!)),
                              ),
                              const Expanded(
                                child: Text("Al imprimir\nContrato desea\nMostrar Capital /\nInteres", 
                                  style: TextStyle(color: kColorHeader, fontWeight: FontWeight.bold, fontSize: 11)),
                              )
                            ],
                          ),
                          
                          const Spacer(),
                          _bigButton("Limpiar", Icons.cleaning_services),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WIDGETS AUXILIARES DE DISEÑO
  // ============================================================

  Widget _labelInput(String text, {double width = 100}) {
    return SizedBox(
      width: width,
      child: Text(text, style: kLabelStyle),
    );
  }

  Widget _compactInput(TextEditingController ctrl, {bool alignRight = false, bool isDate = false}) {
    return SizedBox(
      height: 22,
      child: TextField(
        controller: ctrl,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: const TextStyle(fontSize: 11, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          fillColor: kColorInputBg,
          filled: true,
          // Icono de calendario si es fecha, simulado a la derecha
          suffixIcon: isDate ? const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
        ),
      ),
    );
  }

  Widget _compactDropdown(List<String> items, String? value, Function(String?) onChanged) {
    return SizedBox(
      height: 22,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          fillColor: kColorInputBg,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _resumenRow(String count, String text, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          const Spacer(),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: kColorHeader)),
        ],
      ),
    );
  }

  // Table Header Cell
  Widget _th(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white, width: 0.5)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  // Table Data Cell
  Widget _td(String text, double width, {bool alignRight = false, Color color = Colors.black}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
    );
  }

  Widget _bigButton(String text, IconData icon) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.grey.shade300],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [const BoxShadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1)]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.orange.shade800), 
              const SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}