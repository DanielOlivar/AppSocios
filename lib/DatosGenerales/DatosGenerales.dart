import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ContratoData/ContratoData.dart'; 
import 'package:shared_preferences/shared_preferences.dart';


class DatosGenerales extends StatefulWidget {
  final ContratoData datosContrato;

  const DatosGenerales({super.key, required this.datosContrato});

  @override
  State<DatosGenerales> createState() => _DatosGeneralesState();
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
}


class _DatosGeneralesState extends State<DatosGenerales> {
  // === CONTROLADORES TITULARES ===
  final TextEditingController _nombreTitular = TextEditingController();
  final TextEditingController _paternoTitular = TextEditingController();
  final TextEditingController _maternoTitular = TextEditingController();
  final TextEditingController _ocupacionTitular = TextEditingController();
  final TextEditingController _cumpleTitular = TextEditingController();
  String? _parentescoTitular;
  int? _selectedIndexTitular;

  // === CONTROLADORES BENEFICIARIOS ===
  final TextEditingController _nombreBenef = TextEditingController();
  final TextEditingController _paternoBenef = TextEditingController();
  final TextEditingController _maternoBenef = TextEditingController();
  final TextEditingController _ocupacionBenef = TextEditingController();
  final TextEditingController _cumpleBenef = TextEditingController();
  String? _parentescoBenef;
  int? _selectedIndexBenef;

  // === LISTAS ===
  final List<Map<String, String>> _titulares = [];
  final List<Map<String, String>> _beneficiarios = [];

  // meses válidos (abreviados en español)
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
       appBar: AppBar(
  backgroundColor: const Color.fromRGBO(8, 12, 36, 1),
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
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
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
            const Center(
              child: Text("Contenido de Dirección / Teléfonos / E-Mail"),
            ),
            const Center(child: Text("Contenido de Datos Fiscales (RFC)")),
          ],
        ),
      ),
    );
  }

  Widget _buildTitularesBeneficiariosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Sección Titulares (pasa controladores y funciones específicas)
          _buildSection(
            title: "TITULARES",
            dataList: _titulares,
            nombre: _nombreTitular,
            paterno: _paternoTitular,
            materno: _maternoTitular,
            ocupacion: _ocupacionTitular,
            cumple: _cumpleTitular,
            parentesco: _parentescoTitular,
            onParentescoChanged: (v) => setState(() => _parentescoTitular = v),
            getSelectedIndex: () => _selectedIndexTitular,
            setSelectedIndex: (i) => setState(() => _selectedIndexTitular = i),
            onSelectRow: (index) => _selectRow(
              list: _titulares,
              index: index,
              nombre: _nombreTitular,
              paterno: _paternoTitular,
              materno: _maternoTitular,
              ocupacion: _ocupacionTitular,
              cumple: _cumpleTitular,
              setParentesco: (v) => setState(() => _parentescoTitular = v),
            ),
          ),
          const SizedBox(height: 24),
          // Sección Beneficiarios
          _buildSection(
            title: "BENEFICIARIOS",
            dataList: _beneficiarios,
            nombre: _nombreBenef,
            paterno: _paternoBenef,
            materno: _maternoBenef,
            ocupacion: _ocupacionBenef,
            cumple: _cumpleBenef,
            parentesco: _parentescoBenef,
            onParentescoChanged: (v) => setState(() => _parentescoBenef = v),
            getSelectedIndex: () => _selectedIndexBenef,
            setSelectedIndex: (i) => setState(() => _selectedIndexBenef = i),
            onSelectRow: (index) => _selectRow(
              list: _beneficiarios,
              index: index,
              nombre: _nombreBenef,
              paterno: _paternoBenef,
              materno: _maternoBenef,
              ocupacion: _ocupacionBenef,
              cumple: _cumpleBenef,
              setParentesco: (v) => setState(() => _parentescoBenef = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
  required String title,
  required List<Map<String, String>> dataList,
  required TextEditingController nombre,
  required TextEditingController paterno,
  required TextEditingController materno,
  required TextEditingController ocupacion,
  required TextEditingController cumple,
  required String? parentesco,
  required ValueChanged<String?> onParentescoChanged,
  required int? Function() getSelectedIndex,
  required void Function(int?) setSelectedIndex,
  required void Function(int) onSelectRow,
}) {
  return Card(
    elevation: 4,
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color.fromRGBO(8, 12, 36, 1),
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // formulario (2 filas + tabla)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // fila 1: Nombre | A. Paterno | A. Materno | Cumpleaños
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabeledField("Nombre(s):", nombre),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildLabeledField("A. Paterno:", paterno),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildLabeledField("A. Materno:", materno),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Cumpleaños (dd/Mes/yyyy):"),
                              _cumpleTextFieldController(cumple),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // fila 2: Ocupación | Parentesco
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabeledField("Ocupación:", ocupacion),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Parentesco:"),
                              _parentescoDropdown(
                                parentesco,
                                onParentescoChanged,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // tabla colocada debajo del formulario
                    _buildTable(
                      dataList: dataList,
                      selectedIndex: getSelectedIndex(),
                      onSelect: (index) {
                        setSelectedIndex(index);
                        onSelectRow(index);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // botones
              Column(
                children: [
                  _button(
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  _button(
                    "Limpiar",
                    Colors.orange,
                    () => _limpiarCampos(
                      nombre: nombre,
                      paterno: paterno,
                      materno: materno,
                      ocupacion: ocupacion,
                      cumple: cumple,
                      resetParentesco: onParentescoChanged,
                      clearSelection: () => setSelectedIndex(null),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _button(
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
                      getSelectedIndex: getSelectedIndex,
                      resetParentesco: onParentescoChanged,
                      clearSelection: () => setSelectedIndex(null),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _button(
                    "Borrar",
                    Colors.red,
                    () => _borrarRegistro(
                      list: dataList,
                      getSelectedIndex: getSelectedIndex,
                      clearSelection: () => setSelectedIndex(null),
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


  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
    );
  }

  Widget _cumpleTextFieldController(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        hintText: "01/Ene/2000",
        contentPadding: EdgeInsets.all(10),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z/]+')),
        LengthLimitingTextInputFormatter(11),
      ],
      onChanged: (value) {
        // 1) Eliminamos todos los '/' para reconstruir ordenadamente
        String raw = value.replaceAll('/', '');

        // 2) Limitar raw a máximo 9 caracteres (2 dia + 3 mes + 4 año = 9)
        if (raw.length > 9) raw = raw.substring(0, 9);

        // 3) Construir el texto con los '/' en posiciones correctas
        String formatted = '';
        if (raw.length <= 2) {
          // sólo día parcial o completo
          formatted = raw;
        } else if (raw.length <= 5) {
          // día + mes parcial (mes hasta 3 letras)
          formatted = raw.substring(0, 2) + '/' + raw.substring(2);
        } else {
          // día + mes (3) + año parcial o completo
          formatted =
              raw.substring(0, 2) +
              '/' +
              raw.substring(2, 5) +
              '/' +
              raw.substring(5);
        }

        // 4) Normalizar capitalización del mes cuando esté parcial o completo
        final partes = formatted.split('/');
        if (partes.length >= 2 && partes[1].isNotEmpty) {
          final mesRaw = partes[1];
          final mesNorm =
              mesRaw[0].toUpperCase() +
              (mesRaw.length > 1 ? mesRaw.substring(1).toLowerCase() : '');
          if (partes.length == 3) {
            // dd/Mes/yyyy (mes puede ser menor a 3 si user aún no lo completa)
            formatted =
                partes[0] +
                '/' +
                (mesNorm.padRight(3)).substring(0, partes[1].length) +
                '/' +
                partes[2];
          } else {
            // dd/Mes(parcial)
            formatted =
                partes[0] +
                '/' +
                (mesNorm.padRight(3)).substring(0, partes[1].length);
          }
        }

        // 5) Actualizar controlador sólo si cambió para no crear loops
        if (formatted != controller.text) {
          controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }

        // 6) Validaciones sólo cuando la entrada está completa (11 chars)
        if (formatted.length == 11) {
          final p = formatted.split('/');
          final dia = int.tryParse(p[0]);
          final mes = p[1];
          final anio = int.tryParse(p[2]);

          final mesNorm = mes[0].toUpperCase() + mes.substring(1).toLowerCase();

          String? error;
          if (dia == null || dia < 1 || dia > 31) {
            error = "Día inválido (01-31).";
          } else if (!_mesesValidos.contains(mesNorm)) {
            error = "Mes inválido. Use Ene, Feb, Mar, etc.";
          } else if (anio == null ||
              anio < 1900 ||
              anio > DateTime.now().year) {
            error = "Año inválido.";
          } else {
            final monthIndex = _mesesValidos.indexOf(mesNorm) + 1; // 1..12
            final maxDia = _daysInMonth(monthIndex, anio);
            if (dia > maxDia) {
              error = "El mes $mesNorm tiene máximo $maxDia días.";
            }
          }

          if (error != null) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
          } else {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }
        }
      },
    );
  }

  int _daysInMonth(int month, int year) {
    if (month == 2) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const meses31 = {1, 3, 5, 7, 8, 10, 12};
    return meses31.contains(month) ? 31 : 30;
  }

  Widget _parentescoDropdown(
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      hint: const Text("Seleccionar..."),
      items: [
        "Contacto",
        "Cónyuge",
        "Hermano(a)",
        "Hijo(a)",
        "Madre",
        "Padre",
        "Otro",
      ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _button(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 110,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTable({
  required List<Map<String, String>> dataList,
  required int? selectedIndex,
  required void Function(int) onSelect,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color.fromRGBO(8, 12, 36, 1), width: 1.5),
    ),
    child: DataTable(
      headingRowColor: WidgetStateProperty.all(
        const Color.fromRGBO(8, 12, 36, 1),
      ),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      dataRowColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromRGBO(14, 30, 197, 0.2); // azul claro al seleccionar
          }
          return Colors.white; // color normal
        },
      ),
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
        final isSelected = index == selectedIndex;

        return DataRow(
          selected: isSelected,
          onSelectChanged: (_) => onSelect(index),
          color: WidgetStateProperty.resolveWith<Color?>(
            (states) => isSelected
                ? const Color.fromRGBO(14, 30, 197, 0.15)
                : (index % 2 == 0
                    ? Colors.grey.shade100
                    : Colors.grey.shade200),
          ),
          cells: [
            DataCell(Text(item["nombre"] ?? "")),
            DataCell(Text(item["paterno"] ?? "")),
            DataCell(Text(item["materno"] ?? "")),
            DataCell(Text(item["cumple"] ?? "")),
            DataCell(Text(item["ocupacion"] ?? "")),
            DataCell(Text(item["parentesco"] ?? "")),
          ],
        );
      }),
    ),
  );
}


  // ---------- CRUD helpers para sección genérica ----------
  void _agregarRegistro({
    required List<Map<String, String>> list,
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required String? parentesco,
    required ValueChanged<String?> resetParentesco,
  }) {
    if (nombre.text.isEmpty || parentesco == null) {
      // no agregar si faltan campos obligatorios
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
        nombre: nombre,
        paterno: paterno,
        materno: materno,
        ocupacion: ocupacion,
        cumple: cumple,
        resetParentesco: resetParentesco,
        clearSelection: () {},
      );
    });
  }

  void _limpiarCampos({
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required ValueChanged<String?> resetParentesco,
    required VoidCallback clearSelection,
  }) {
    nombre.clear();
    paterno.clear();
    materno.clear();
    ocupacion.clear();
    cumple.clear();
    resetParentesco(null);
    clearSelection();
    setState(() {});
  }

  void _modificarRegistro({
    required List<Map<String, String>> list,
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required String? parentesco,
    required int? Function() getSelectedIndex,
    required ValueChanged<String?> resetParentesco,
    required VoidCallback clearSelection,
  }) {
    final idx = getSelectedIndex();
    if (idx == null || idx < 0) return;
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
        nombre: nombre,
        paterno: paterno,
        materno: materno,
        ocupacion: ocupacion,
        cumple: cumple,
        resetParentesco: resetParentesco,
        clearSelection: clearSelection,
      );
    });
  }

  void _borrarRegistro({
    required List<Map<String, String>> list,
    required int? Function() getSelectedIndex,
    required VoidCallback clearSelection,
  }) {
    final idx = getSelectedIndex();
    if (idx == null || idx < 0) return;
    setState(() {
      list.removeAt(idx);
      clearSelection();
    });
  }

  // al seleccionar fila, cargamos los controllers de esa sección
  void _selectRow({
    required List<Map<String, String>> list,
    required int index,
    required TextEditingController nombre,
    required TextEditingController paterno,
    required TextEditingController materno,
    required TextEditingController ocupacion,
    required TextEditingController cumple,
    required ValueChanged<String?> setParentesco,
  }) {
    if (index < 0 || index >= list.length) {
      // deseleccion
      nombre.clear();
      paterno.clear();
      materno.clear();
      ocupacion.clear();
      cumple.clear();
      setParentesco(null);
      setState(() {});
      return;
    }
    final item = list[index];
    nombre.text = item["nombre"] ?? "";
    paterno.text = item["paterno"] ?? "";
    materno.text = item["materno"] ?? "";
    ocupacion.text = item["ocupacion"] ?? "";
    cumple.text = item["cumple"] ?? "";
    setParentesco(item["parentesco"]);
    setState(() {});
  }

  @override
  void dispose() {
    // titulares
    _nombreTitular.dispose();
    _paternoTitular.dispose();
    _maternoTitular.dispose();
    _ocupacionTitular.dispose();
    _cumpleTitular.dispose();
    // beneficiarios
    _nombreBenef.dispose();
    _paternoBenef.dispose();
    _maternoBenef.dispose();
    _ocupacionBenef.dispose();
    _cumpleBenef.dispose();
    super.dispose();
  }
}
