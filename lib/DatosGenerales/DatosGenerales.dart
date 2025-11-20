import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ContratoData/ContratoData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Direcciones/DireccionesView.dart';

// ==========================================
// ESTILOS VISUALES
// ==========================================
const Color kColorLabelRed = Color(0xFFA00000);
const Color kColorInputBg = Color(0xFFF5F0FA);
const Color kColorHeader = Color.fromRGBO(8, 12, 36, 1);

final TextStyle kLabelStyle = TextStyle(
  color: kColorLabelRed,
  fontWeight: FontWeight.bold,
  fontSize: 12,
);

final TextStyle kHintSmallStyle = TextStyle(
  color: kColorLabelRed,
  fontWeight: FontWeight.bold,
  fontSize: 10,
);

// ==========================================
// WIDGET PRINCIPAL
// ==========================================
class DatosGenerales extends StatefulWidget {
  final ContratoData datosContrato;

  const DatosGenerales({super.key, required this.datosContrato});

  @override
  State<DatosGenerales> createState() => _DatosGeneralesState();
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}

class _DatosGeneralesState extends State<DatosGenerales> {
  // CONTROLADORES
  final TextEditingController _nombreTitular = TextEditingController();
  final TextEditingController _paternoTitular = TextEditingController();
  final TextEditingController _maternoTitular = TextEditingController();
  final TextEditingController _ocupacionTitular = TextEditingController();
  final TextEditingController _cumpleTitular = TextEditingController();
  String? _parentescoTitular;
  // CAMBIO: Usamos Set para selección múltiple
  final Set<int> _selectedTitulares = {};

  final TextEditingController _nombreBenef = TextEditingController();
  final TextEditingController _paternoBenef = TextEditingController();
  final TextEditingController _maternoBenef = TextEditingController();
  final TextEditingController _ocupacionBenef = TextEditingController();
  final TextEditingController _cumpleBenef = TextEditingController();
  String? _parentescoBenef;
  // CAMBIO: Usamos Set para selección múltiple
  final Set<int> _selectedBeneficiarios = {};

  final List<Map<String, String>> _titulares = [];
  final List<Map<String, String>> _beneficiarios = [];

  final List<String> _mesesValidos = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: kColorHeader,
          title: const Text(
            "Cotización de Venta",
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
            preferredSize: const Size.fromHeight(70),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    "Bienvenido, ${widget.datosContrato.nombre.isNotEmpty ? widget.datosContrato.nombre : 'Usuario'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "TITULARES / BENEFICIARIOS"),
                    Tab(text: "DIRECCIÓN / TELÉFONOS / E-MAIL"),
                    Tab(text: "DATOS FISCALES (RFC)"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTitularesBeneficiariosTab(),
            DireccionesView(),
            const Center(
              child: Text("Contenido de Datos Fiscales en desarrollo."),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitularesBeneficiariosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildSection(
            title: "TITULARES",
            dataList: _titulares,
            selectedIndexes: _selectedTitulares,
            nombre: _nombreTitular,
            paterno: _paternoTitular,
            materno: _maternoTitular,
            ocupacion: _ocupacionTitular,
            cumple: _cumpleTitular,
            parentesco: _parentescoTitular,
            onParentescoChanged: (v) => setState(() => _parentescoTitular = v),
            onSelectRow: (index, selected) => _handleRowSelection(
              _titulares,
              _selectedTitulares,
              index,
              selected,
              _nombreTitular,
              _paternoTitular,
              _maternoTitular,
              _ocupacionTitular,
              _cumpleTitular,
              (v) => setState(() => _parentescoTitular = v),
            ),
            onSelectAll: (val) => _handleSelectAll(
              _titulares,
              _selectedTitulares,
              val,
              _nombreTitular,
              _paternoTitular,
              _maternoTitular,
              _ocupacionTitular,
              _cumpleTitular,
              (v) => setState(() => _parentescoTitular = v),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: "BENEFICIARIOS",
            dataList: _beneficiarios,
            selectedIndexes: _selectedBeneficiarios,
            nombre: _nombreBenef,
            paterno: _paternoBenef,
            materno: _maternoBenef,
            ocupacion: _ocupacionBenef,
            cumple: _cumpleBenef,
            parentesco: _parentescoBenef,
            onParentescoChanged: (v) => setState(() => _parentescoBenef = v),
            onSelectRow: (index, selected) => _handleRowSelection(
              _beneficiarios,
              _selectedBeneficiarios,
              index,
              selected,
              _nombreBenef,
              _paternoBenef,
              _maternoBenef,
              _ocupacionBenef,
              _cumpleBenef,
              (v) => setState(() => _parentescoBenef = v),
            ),
            onSelectAll: (val) => _handleSelectAll(
              _beneficiarios,
              _selectedBeneficiarios,
              val,
              _nombreBenef,
              _paternoBenef,
              _maternoBenef,
              _ocupacionBenef,
              _cumpleBenef,
              (v) => setState(() => _parentescoBenef = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> dataList,
    required Set<int> selectedIndexes, // Ahora recibe un Set
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required String? parentesco,
    required ValueChanged<String?> onParentescoChanged,
    required Function(int, bool?) onSelectRow,
    required Function(bool?) onSelectAll,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: kColorHeader,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FILA 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text("Nombre:", style: kLabelStyle),
                          ),
                          Expanded(child: _purpleTextField(nombre)),
                          const SizedBox(width: 4),
                          Expanded(child: _purpleTextField(paterno)),
                          const SizedBox(width: 4),
                          Expanded(child: _purpleTextField(materno)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("ddmmyy", style: kHintSmallStyle),
                              Row(
                                children: [
                                  Text("Cumpleaños: ", style: kLabelStyle),
                                  SizedBox(
                                    width: 130,
                                    child: _purpleTextField(
                                      cumple,
                                      isDate: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // FILA 2
                      Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text("Ocupacion:", style: kLabelStyle),
                          ),
                          Expanded(flex: 1, child: _purpleTextField(ocupacion)),
                          const SizedBox(width: 15),
                          Text("Parentesco", style: kLabelStyle),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: _purpleDropdown(
                              parentesco,
                              onParentescoChanged,
                            ),
                          ),
                          const Spacer(flex: 1),
                          const SizedBox(width: 210),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // TABLA CON CHECKBOXES
                      _buildTable(
                        dataList: dataList,
                        selectedIndexes: selectedIndexes,
                        onSelectRow: onSelectRow,
                        onSelectAll: onSelectAll,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // BOTONES DERECHA
                Column(
                  children: [
                    _buttonCompacto(
                      "Nuevo",
                      Colors.green,
                      () => _agregarRegistro(
                        list: dataList,
                        nombre: nombre,
                        paterno: paterno,
                        materno: materno,
                        ocupacion: ocupacion,
                        cumple: cumple,
                        parentesco: parentesco,
                        resetParentesco: onParentescoChanged,
                        selectedIndexes: selectedIndexes,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buttonCompacto(
                      "Limpiar",
                      Colors.orange,
                      () => _limpiarCampos(
                        nombre,
                        paterno,
                        materno,
                        ocupacion,
                        cumple,
                        onParentescoChanged,
                        selectedIndexes,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buttonCompacto(
                      "Modificar",
                      Colors.blue,
                      () => _modificarRegistro(
                        list: dataList,
                        nombre: nombre,
                        paterno: paterno,
                        materno: materno,
                        ocupacion: ocupacion,
                        cumple: cumple,
                        parentesco: parentesco,
                        selectedIndexes: selectedIndexes,
                        resetParentesco: onParentescoChanged,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buttonCompacto(
                      "Borrar",
                      Colors.red,
                      () => _borrarRegistro(
                        list: dataList,
                        selectedIndexes: selectedIndexes,
                        // Al borrar, también limpiamos campos por si acaso
                        limpiarCampos: () => _limpiarCampos(
                          nombre,
                          paterno,
                          materno,
                          ocupacion,
                          cumple,
                          onParentescoChanged,
                          {},
                        ),
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
  }

  // ==========================================
  // WIDGETS AUXILIARES
  // ==========================================
  Widget _purpleTextField(TextEditingController ctrl, {bool isDate = false}) {
    return SizedBox(
      height: 24,
      child: TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: isDate ? TextInputType.number : TextInputType.text,
        inputFormatters: isDate
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z/]+')),
                LengthLimitingTextInputFormatter(11),
              ]
            : [],
        onChanged: isDate ? (val) => _handleDateLogic(val, ctrl) : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 0,
          ),
          fillColor: kColorInputBg,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.blue, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _purpleDropdown(String? selected, ValueChanged<String?> onChanged) {
    return SizedBox(
      height: 24,
      child: DropdownButtonFormField<String>(
        value: selected,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 0,
          ),
          fillColor: kColorInputBg,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        items:
            [
                  "Contacto",
                  "Cónyuge",
                  "Hermano(a)",
                  "Hijo(a)",
                  "Madre",
                  "Padre",
                  "Otro",
                ]
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p, style: const TextStyle(fontSize: 12)),
                  ),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buttonCompacto(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 90,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  // TABLA CON MULTI-SELECCIÓN
  Widget _buildTable({
    required List<Map<String, String>> dataList,
    required Set<int> selectedIndexes,
    required Function(int, bool?) onSelectRow,
    required Function(bool?) onSelectAll,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DataTable(
        headingRowHeight: 30,
        dataRowMinHeight: 25,
        dataRowMaxHeight: 30,
        headingRowColor: WidgetStateProperty.all(kColorHeader),
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected))
            return const Color.fromRGBO(14, 30, 197, 0.15);
          return Colors.white;
        }),
        showCheckboxColumn: true, // Mostrar checkbox
        // Lógica para el checkbox maestro del encabezado
        onSelectAll: (value) => onSelectAll(value),
        columns: const [
          DataColumn(label: Text("Nombre")),
          DataColumn(label: Text("A. Paterno")),
          DataColumn(label: Text("A. Materno")),
          DataColumn(label: Text("Cumpleaños")),
          DataColumn(label: Text("Ocupación")),
          DataColumn(label: Text("Parentesco")),
        ],
        rows: List.generate(dataList.length, (index) {
          final item = dataList[index];
          final isSelected = selectedIndexes.contains(index);

          return DataRow(
            selected: isSelected,
            onSelectChanged: (val) => onSelectRow(index, val),
            cells: [
              DataCell(
                Text(
                  item["nombre"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              DataCell(
                Text(
                  item["paterno"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              DataCell(
                Text(
                  item["materno"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              DataCell(
                Text(
                  item["cumple"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              DataCell(
                Text(
                  item["ocupacion"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              DataCell(
                Text(
                  item["parentesco"] ?? "",
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ==========================================
  // LÓGICA DE SELECCIÓN MÚLTIPLE
  // ==========================================

  // Seleccionar/Deseleccionar una fila
  void _handleRowSelection(
    List<Map<String, String>> list,
    Set<int> selectedSet,
    int index,
    bool? isSelected,
    TextEditingController n,
    TextEditingController p,
    TextEditingController m,
    TextEditingController o,
    TextEditingController c,
    ValueChanged<String?> setP,
  ) {
    setState(() {
      if (isSelected == true) {
        selectedSet.add(index);
      } else {
        selectedSet.remove(index);
      }

      // Lógica de llenado de campos:
      // Solo llenamos si hay EXACTAMENTE UN elemento seleccionado
      if (selectedSet.length == 1) {
        final singleIndex = selectedSet.first;
        final item = list[singleIndex];
        n.text = item["nombre"] ?? "";
        p.text = item["paterno"] ?? "";
        m.text = item["materno"] ?? "";
        o.text = item["ocupacion"] ?? "";
        c.text = item["cumple"] ?? "";
        setP(item["parentesco"]);
      } else {
        // Si hay 0 o >1 seleccionados, limpiamos los campos para evitar confusión
        n.clear();
        p.clear();
        m.clear();
        o.clear();
        c.clear();
        setP(null);
      }
    });
  }

  // Seleccionar/Deseleccionar TODO
  void _handleSelectAll(
    List<Map<String, String>> list,
    Set<int> selectedSet,
    bool? value,
    TextEditingController n,
    TextEditingController p,
    TextEditingController m,
    TextEditingController o,
    TextEditingController c,
    ValueChanged<String?> setP,
  ) {
    setState(() {
      if (value == true) {
        // Agregamos todos los índices
        selectedSet.addAll(List.generate(list.length, (index) => index));
      } else {
        // Limpiamos
        selectedSet.clear();
      }
      // Al seleccionar todo (o nada), limpiamos los campos de texto
      n.clear();
      p.clear();
      m.clear();
      o.clear();
      c.clear();
      setP(null);
    });
  }

  // ==========================================
  // CRUD HELPERS
  // ==========================================
  void _agregarRegistro({
    required List list,
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required String? parentesco,
    required ValueChanged<String?> resetParentesco,
    required Set<int> selectedIndexes,
  }) {
    if (nombre.text.isEmpty || parentesco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa Nombre y Parentesco")),
      );
      return;
    }
    setState(() {
      list.add({
        "nombre": nombre.text,
        "paterno": paterno.text,
        "materno": materno.text,
        "ocupacion": ocupacion.text,
        "parentesco": parentesco,
        "cumple": cumple.text,
      });
      _limpiarCampos(
        nombre,
        paterno,
        materno,
        ocupacion,
        cumple,
        resetParentesco,
        selectedIndexes,
      );
    });
  }

  void _limpiarCampos(
    TextEditingController n,
    TextEditingController p,
    TextEditingController m,
    TextEditingController o,
    TextEditingController c,
    ValueChanged<String?> r,
    Set<int> selectedSet,
  ) {
    n.clear();
    p.clear();
    m.clear();
    o.clear();
    c.clear();
    r(null);
    setState(() {
      selectedSet.clear();
    });
  }

  void _modificarRegistro({
    required List list,
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required String? parentesco,
    required Set<int> selectedIndexes,
    required ValueChanged<String?> resetParentesco,
  }) {
    // Solo permitir modificar si hay exactamente un elemento seleccionado
    if (selectedIndexes.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una sola fila para modificar"),
        ),
      );
      return;
    }
    final idx = selectedIndexes.first;

    setState(() {
      list[idx] = {
        "nombre": nombre.text,
        "paterno": paterno.text,
        "materno": materno.text,
        "ocupacion": ocupacion.text,
        "parentesco": parentesco ?? "",
        "cumple": cumple.text,
      };
      _limpiarCampos(
        nombre,
        paterno,
        materno,
        ocupacion,
        cumple,
        resetParentesco,
        selectedIndexes,
      );
    });
  }

  void _borrarRegistro({
    required List list,
    required Set<int> selectedIndexes,
    required VoidCallback limpiarCampos,
  }) {
    if (selectedIndexes.isEmpty) return;

    setState(() {
      // Convertimos a lista y ordenamos descendente para borrar sin alterar índices pendientes
      final List<int> indicesABorrar = selectedIndexes.toList()
        ..sort((a, b) => b.compareTo(a));

      for (int i in indicesABorrar) {
        if (i < list.length) {
          list.removeAt(i);
        }
      }
      // Limpiamos selección y campos
      selectedIndexes.clear();
      limpiarCampos();
    });
  }

  // Lógica fechas (sin cambios)
  void _handleDateLogic(String value, TextEditingController controller) {
    String raw = value.replaceAll('/', '');
    if (raw.length > 9) raw = raw.substring(0, 9);
    String formatted = raw.length <= 2
        ? raw
        : raw.length <= 5
        ? raw.substring(0, 2) + '/' + raw.substring(2)
        : raw.substring(0, 2) +
              '/' +
              raw.substring(2, 5) +
              '/' +
              raw.substring(5);
    final parts = formatted.split('/');
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      final mesNorm =
          parts[1][0].toUpperCase() +
          (parts[1].length > 1 ? parts[1].substring(1).toLowerCase() : '');
      formatted =
          parts[0] +
          '/' +
          (mesNorm.padRight(3)).substring(0, parts[1].length) +
          (parts.length == 3 ? '/' + parts[2] : '');
    }
    if (formatted != controller.text) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    if (formatted.length == 11) {
      final p = formatted.split('/');
      final d = int.tryParse(p[0]), y = int.tryParse(p[2]);
      final m = p[1][0].toUpperCase() + p[1].substring(1).toLowerCase();
      if (d == null ||
          d < 1 ||
          d > 31 ||
          !_mesesValidos.contains(m) ||
          y == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Fecha inválida")));
      }
    }
  }

  @override
  void dispose() {
    _nombreTitular.dispose();
    _paternoTitular.dispose();
    _maternoTitular.dispose();
    _ocupacionTitular.dispose();
    _cumpleTitular.dispose();
    _nombreBenef.dispose();
    _paternoBenef.dispose();
    _maternoBenef.dispose();
    _ocupacionBenef.dispose();
    _cumpleBenef.dispose();
    super.dispose();
  }
}
