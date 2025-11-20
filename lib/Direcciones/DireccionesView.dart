import 'package:flutter/material.dart';

// ==========================================
// ESTILOS VISUALES (Globales)
// ==========================================
const Color kColorLabelRed = Color(0xFFA00000); // Rojo oscuro
const Color kColorInputBg = Color(0xFFF5F0FA); // Violeta muy claro
const Color kColorHeader = Color.fromRGBO(8, 12, 36, 1); // Azul oscuro

final TextStyle kLabelStyle = TextStyle(
  color: kColorLabelRed,
  fontWeight: FontWeight.bold,
  fontSize: 11,
);

final TextStyle kWarningStyle = TextStyle(
  color: Colors.red,
  fontSize: 10,
  fontStyle: FontStyle.italic,
);

//ENUMS para control de estado
enum PaisSeleccionado { mexico, usa, canada, otro }

enum FormatoDirUSA { standard, poBox, cmr }

void main() {
  runApp(DireccionesView());
}

class DireccionesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // Quitamos el tema global de input para usar el personalizado
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: VistaDireccionEmail(),
          ),
        ),
      ),
    );
  }
}

class VistaDireccionEmail extends StatefulWidget {
  @override
  State<VistaDireccionEmail> createState() => _VistaDireccionEmailState();
}

class _VistaDireccionEmailState extends State<VistaDireccionEmail> {
  PaisSeleccionado _pais = PaisSeleccionado.mexico;
  FormatoDirUSA _formatoUSA = FormatoDirUSA.standard;

  // --- Controladores Domicilio ---
  final List<TextEditingController> _domicilioControllers = [];

  // --- Controladores Teléfonos ---
  final List<String> _tiposTelefono = [
    "Casa 1",
    "Casa 2",
    "Oficina 1",
    "Oficina 2",
    "Celular 1",
    "Celular 2",
    "Mensajes",
  ];
  final List<TextEditingController> _telefonosControllers = [];
  String? _telefonoSeleccionado = "Casa 1";

  // --- Controladores Email ---
  final List<TextEditingController> _emailControllers = [];
  bool _noTieneEmail = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++)
      _domicilioControllers.add(TextEditingController());
    for (int i = 0; i < _tiposTelefono.length * 2; i++)
      _telefonosControllers.add(TextEditingController());
    for (int i = 0; i < 4; i++) _emailControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _domicilioControllers) controller.dispose();
    for (var controller in _telefonosControllers) controller.dispose();
    for (var controller in _emailControllers) controller.dispose();
    super.dispose();
  }

  // --- Funciones de Limpieza ---
  void _limpiarDomicilio() {
    for (var controller in _domicilioControllers) controller.clear();
  }

  void _limpiarTelefonos() {
    for (var controller in _telefonosControllers) controller.clear();
    setState(() {
      _telefonoSeleccionado = null;
    });
  }

  void _limpiarEmail() {
    for (var controller in _emailControllers) controller.clear();
    setState(() {
      _noTieneEmail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 900;

    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildSeccionDomicilio()),
              SizedBox(width: 16),
              Expanded(flex: 2, child: _buildDerecha()),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSeccionDomicilio(),
              SizedBox(height: 16),
              _buildDerecha(),
            ],
          );
  }

  Widget _buildDerecha() => Column(
    children: [
      _buildSeccionTelefonos(),
      SizedBox(height: 16),
      _buildSeccionEmail(),
      SizedBox(height: 16),
      _buildSeccionNacionalidad(),
    ],
  );

  // ================= DOMICILIO =================
  Widget _buildSeccionDomicilio() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(text: "DOMICILIO"),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildRadioPais("México", PaisSeleccionado.mexico),
                    _buildRadioPais("USA", PaisSeleccionado.usa),
                    _buildRadioPais("Canadá", PaisSeleccionado.canada),
                    _buildRadioPais("Otro", PaisSeleccionado.otro),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buttonCompacto(
                      "Aceptar",
                      Colors.white,
                      Colors.black,
                      () {},
                    ),
                    SizedBox(width: 8),
                    _buttonCompacto(
                      "Limpiar",
                      Colors.white,
                      Colors.black,
                      _limpiarDomicilio,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildFormularioDinamico(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioPais(String titulo, PaisSeleccionado valor) {
    return Expanded(
      child: Row(
        children: [
          Radio<PaisSeleccionado>(
            value: valor,
            groupValue: _pais,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => _pais = v!),
          ),
          Text(
            titulo,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioDinamico() {
    switch (_pais) {
      case PaisSeleccionado.mexico:
        return _buildFormMexico(key: ValueKey('mexico'));
      case PaisSeleccionado.usa:
        return _buildFormUSA(key: ValueKey('usa'));
      case PaisSeleccionado.canada:
        return _buildFormCanada(key: ValueKey('canada'));
      case PaisSeleccionado.otro:
        return _buildFormOtro(key: ValueKey('otro'));
    }
  }

  Widget _buildFormMexico({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Calle", controllers: [_domicilioControllers[0]]),
      _campo(
        "N° Ext                                  N° Int                                  Código Postal",
        triple: true,
        controllers: [
          _domicilioControllers[1],
          _domicilioControllers[2],
          _domicilioControllers[3],
        ],
      ),
      _campo("Colonia", controllers: [_domicilioControllers[4]]),
      _campo("Delegación o Municipio", controllers: [_domicilioControllers[5]]),
      _campo("Ciudad", controllers: [_domicilioControllers[6]]),
      _campo("Estado", controllers: [_domicilioControllers[7]]),
      _campo("País", valorFijo: "México"),
    ],
  );

  Widget _buildFormUSA({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Formato de Dirección", style: kLabelStyle),
      Row(
        children: [
          _buildRadioUSA("Standard", FormatoDirUSA.standard),
          _buildRadioUSA("P.O. Box", FormatoDirUSA.poBox),
          _buildRadioUSA("CMR", FormatoDirUSA.cmr),
        ],
      ),
      SizedBox(height: 8),
      _buildFormularioDinamicoUSA(),
      _campo("País", valorFijo: "USA"),
    ],
  );

  Widget _buildFormularioDinamicoUSA() {
    switch (_formatoUSA) {
      case FormatoDirUSA.standard:
        return _buildFormUSAStandard();
      case FormatoDirUSA.poBox:
        return _buildFormUSAPoBox();
      case FormatoDirUSA.cmr:
        return _buildFormUSACMR();
    }
  }

  Widget _buildFormUSAStandard() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Street", controllers: [_domicilioControllers[0]]),
      _campo("City", controllers: [_domicilioControllers[1]]),
      _campo(
        "State                                                            Zip Code",
        doble: true,
        controllers: [_domicilioControllers[2], _domicilioControllers[3]],
      ),
    ],
  );

  Widget _buildFormUSAPoBox() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Street", controllers: [_domicilioControllers[0]]),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: _campo("P. O. Box", controllers: [_domicilioControllers[1]]),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _campo("City", controllers: [_domicilioControllers[2]]),
          ),
        ],
      ),
      _campo(
        "Zip Code",
        doble: true,
        controllers: [_domicilioControllers[3], _domicilioControllers[4]],
      ), // Ajustado lógica visual
    ],
  );

  Widget _buildFormUSACMR() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo(
        "CMR / Box / APO",
        triple: true,
        controllers: [
          _domicilioControllers[0],
          _domicilioControllers[1],
          _domicilioControllers[2],
        ],
      ),
      _campo("City", controllers: [_domicilioControllers[3]]),
      _campo(
        "State / Zip Code",
        doble: true,
        controllers: [_domicilioControllers[4], _domicilioControllers[5]],
      ),
    ],
  );

  Widget _buildFormCanada({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Street", controllers: [_domicilioControllers[0]]),
      _campo("City", controllers: [_domicilioControllers[1]]),
      _campo(
        "Province                                                        Zip Code",
        doble: true,
        controllers: [_domicilioControllers[2], _domicilioControllers[3]],
      ),
      _campo("País", valorFijo: "Canada"),
    ],
  );

  Widget _buildFormOtro({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int i = 1; i <= 5; i++)
        _campo("Línea $i", controllers: [_domicilioControllers[i - 1]]),
      SizedBox(height: 8),
      Text("País", style: kLabelStyle),
      SizedBox(height: 4),
      _purpleDropdown(
        [
          "American",
          "Arabia Saudita",
          "Argentina",
          "Brasil",
          "Colombia",
          "Europa",
          "Inglaterra",
          "Otro País",
        ],
        null,
        (v) {},
      ),
    ],
  );

  Widget _buildRadioUSA(String titulo, FormatoDirUSA valor) {
    return Expanded(
      child: Row(
        children: [
          Radio<FormatoDirUSA>(
            value: valor,
            groupValue: _formatoUSA,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => _formatoUSA = v!),
          ),
          Text(titulo, style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  // Helper para construir campos con el nuevo estilo
  Widget _campo(
    String label, {
    bool doble = false,
    bool triple = false,
    String? valorFijo,
    List<TextEditingController>? controllers,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kLabelStyle),
          SizedBox(height: 4),
          if (valorFijo != null)
            _purpleTextField(null, initialValue: valorFijo, enabled: false),
          if (doble)
            Row(
              children: [
                Expanded(child: _purpleTextField(controllers![0])),
                SizedBox(width: 8),
                Expanded(child: _purpleTextField(controllers[1])),
              ],
            ),
          if (triple)
            Row(
              children: [
                Expanded(child: _purpleTextField(controllers![0])),
                SizedBox(width: 8),
                Expanded(child: _purpleTextField(controllers[1])),
                SizedBox(width: 8),
                Expanded(child: _purpleTextField(controllers[2])),
              ],
            ),
          if (valorFijo == null && !doble && !triple)
            _purpleTextField(controllers![0]),
        ],
      ),
    );
  }

  // ================= TELÉFONOS =================
  Widget _buildSeccionTelefonos() => Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(text: "TELÉFONOS"),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              for (int i = 0; i < _tiposTelefono.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio<String>(
                          value: _tiposTelefono[i],
                          groupValue: _telefonoSeleccionado,
                          visualDensity: VisualDensity.compact,
                          onChanged: (v) =>
                              setState(() => _telefonoSeleccionado = v),
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _tiposTelefono[i],
                          style: kLabelStyle.copyWith(color: Colors.black87),
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: _purpleTextField(_telefonosControllers[i * 2]),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        flex: 3,
                        child: _purpleTextField(
                          _telefonosControllers[i * 2 + 1],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: _buttonCompacto(
                  "Limpiar",
                  Colors.white,
                  Colors.black,
                  _limpiarTelefonos,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Debe capturar los teléfonos a 10 dígitos entre la lada y el número de teléfono y seleccionar un teléfono por default.",
                style: kWarningStyle,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ================= EMAIL =================
  Widget _buildSeccionEmail() => Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(text: "EMAIL"),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rowLabelInput(
                "Email 1:",
                _emailControllers[0],
                enabled: !_noTieneEmail,
              ),
              _rowLabelInput(
                "Email 2:",
                _emailControllers[1],
                enabled: !_noTieneEmail,
              ),
              _rowLabelInput(
                "Email 3:",
                _emailControllers[2],
                enabled: !_noTieneEmail,
              ),
              _rowLabelInput(
                "Email 4:",
                _emailControllers[3],
                enabled: !_noTieneEmail,
              ),

              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _noTieneEmail,
                      onChanged: (v) {
                        setState(() {
                          _noTieneEmail = v ?? false;
                          if (_noTieneEmail) {
                            for (var controller in _emailControllers)
                              controller.clear();
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "No Tiene Correo Electrónico",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Center(
                child: _buttonCompacto(
                  "Limpiar",
                  Colors.white,
                  Colors.black,
                  _limpiarEmail,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "En Caso de no tener ningún Correo Electrónico dejar los campos en blanco y seleccionar la casilla.",
                style: kWarningStyle,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ================= NACIONALIDAD =================
  Widget _buildSeccionNacionalidad() => Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nacionalidad", style: kLabelStyle),
          SizedBox(height: 4),
          _purpleDropdown(
            [
              "MEXICANA",
              "AMERICANA",
              "CANADIENSE",
              "ITALIANA",
              "PERUANA",
              "RUSO",
              "Seleccione",
              "SIL",
              "VENEZOLANA",
              "OTRA",
            ],
            "Seleccione",
            (v) {},
          ),
        ],
      ),
    ),
  );

  // ============================================================
  // WIDGETS AUXILIARES (Estilo Windows Forms)
  // ============================================================

  Widget _purpleTextField(
    TextEditingController? ctrl, {
    bool enabled = true,
    String? initialValue,
  }) {
    return SizedBox(
      height: 24,
      child: TextFormField(
        controller: ctrl,
        initialValue: initialValue,
        enabled: enabled,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 0,
          ),
          fillColor: enabled ? kColorInputBg : Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _purpleDropdown(
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return SizedBox(
      height: 24,
      child: DropdownButtonFormField<String>(
        value: value,
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
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _rowLabelInput(
    String label,
    TextEditingController ctrl, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: kLabelStyle)),
          Expanded(child: _purpleTextField(ctrl, enabled: enabled)),
        ],
      ),
    );
  }

  Widget _buttonCompacto(
    String text,
    Color bg,
    Color fg,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final String text;
  const AppHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: kColorHeader,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
