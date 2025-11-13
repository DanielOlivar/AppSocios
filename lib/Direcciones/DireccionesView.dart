import 'package:flutter/material.dart';

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
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
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
    // Inicializar controladores de Domicilio (10)
    for (int i = 0; i < 10; i++) {
      _domicilioControllers.add(TextEditingController());
    }
    // Inicializar controladores de Teléfonos (7 tipos * 2 campos = 14)
    for (int i = 0; i < _tiposTelefono.length * 2; i++) {
      _telefonosControllers.add(TextEditingController());
    }
    // Inicializar controladores de Email (4)
    for (int i = 0; i < 4; i++) {
      _emailControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Limpiar controladores de Domicilio
    for (var controller in _domicilioControllers) {
      controller.dispose();
    }
    // Limpiar controladores de Teléfonos
    for (var controller in _telefonosControllers) {
      controller.dispose();
    }
    // Limpiar controladores de Email
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- Funciones de Limpieza ---
  void _limpiarDomicilio() {
    for (var controller in _domicilioControllers) {
      controller.clear();
    }
  }

  void _limpiarTelefonos() {
    for (var controller in _telefonosControllers) {
      controller.clear();
    }
    setState(() {
      _telefonoSeleccionado = null;
    });
  }

  void _limpiarEmail() {
    for (var controller in _emailControllers) {
      controller.clear();
    }
    // También reseteamos el checkbox y habilitamos los campos
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
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("DOMICILIO"),
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
                SizedBox(height: 6),
                Row(
                  children: [
                    SizedBox(width: 8),
                    ElevatedButton(onPressed: () {}, child: Text("Aceptar")),
                    SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: _limpiarDomicilio, child: Text("Limpiar")),
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

  Widget _buildRadioPais(String titulo, PaisSeleccionado valor) {
    return Expanded(
      child: RadioListTile<PaisSeleccionado>(
        title: Text(titulo, style: TextStyle(fontSize: 12)),
        value: valor,
        groupValue: _pais,
        dense: true,
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => setState(() => _pais = v!),
      ),
    );
  }

  // MODIFICADO: Se añaden Keys
  Widget _buildFormularioDinamico() {
    // Asignar una Key basada en el país seleccionado
    // Esto fuerza a Flutter a reconstruir completamente el formulario
    // cuando el país cambia, evitando que se conserve el estado
    // (como el valor fijo de "País") del formulario anterior.
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

  // MODIFICADO: Acepta Key
  Widget _buildFormMexico({Key? key}) => Column(
        key: key, // Se asigna la Key
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _campo("Calle", controllers: [_domicilioControllers[0]]),
          _campo(
            "N° Ext                                                                                         N° Int                                                          Código Postal",
            triple: true,
            controllers: [
              _domicilioControllers[1],
              _domicilioControllers[2],
              _domicilioControllers[3],
            ],
          ),
          _campo("Colonia", controllers: [_domicilioControllers[4]]),
          _campo("Delegación o Municipio",
              controllers: [_domicilioControllers[5]]),
          _campo("Ciudad", controllers: [_domicilioControllers[6]]),
          _campo("Estado", controllers: [_domicilioControllers[7]]),
          _campo("País", valorFijo: "México"),
        ],
      );

  // MODIFICADO: Acepta Key
  Widget _buildFormUSA({Key? key}) => Column(
        key: key, // Se asigna la Key
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Formato de Dirección"),
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

  // Widget que cambia el formulario de USA
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

  // Formulario Standard
  Widget _buildFormUSAStandard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _campo("Street", controllers: [_domicilioControllers[0]]),
          _campo("City", controllers: [_domicilioControllers[1]]),
          _campo(
            "State                                                                                                                   Zip Code",
            doble: true,
            controllers: [
              _domicilioControllers[2],
              _domicilioControllers[3],
            ],
          ),
        ],
      );

  // Formulario P.O. Box
  Widget _buildFormUSAPoBox() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _campo("Street", controllers: [_domicilioControllers[0]]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _campo("P. O. Box",
                    controllers: [_domicilioControllers[1]]),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _campo("ty", controllers: [_domicilioControllers[2]]),
              ),
            ],
          ),
          _campo(
            "Zip Code",
            doble: true,
            controllers: [
              _domicilioControllers[3],
              _domicilioControllers[4],
            ],
          ),
        ],
      );

  // Formulario CMR
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
            controllers: [
              _domicilioControllers[4],
              _domicilioControllers[5],
            ],
          ),
        ],
      );

  // MODIFICADO: Acepta Key
  Widget _buildFormCanada({Key? key}) => Column(
        key: key, // Se asigna la Key
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _campo("Street", controllers: [_domicilioControllers[0]]),
          _campo("City", controllers: [_domicilioControllers[1]]),
          _campo(
            "Province                                                                                                                   Zip Code",
            doble: true,
            controllers: [
              _domicilioControllers[2],
              _domicilioControllers[3],
            ],
          ),
          _campo("País", valorFijo: "Canada"),
        ],
      );

  // MODIFICADO: Acepta Key
  Widget _buildFormOtro({Key? key}) => Column(
        key: key, // Se asigna la Key
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 1; i <= 5; i++)
            _campo("Línea $i", controllers: [_domicilioControllers[i - 1]]),
          SizedBox(height: 8),
          Text("País"),
          DropdownButtonFormField(
            items: [
              "American",
              "Arabia Saudita",
              "Argentina",
              "Brasil",
              "Colombia",
              "Europa",
              "Inglaterra",
              "Otro País",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
        ],
      );

  Widget _buildRadioUSA(String titulo, FormatoDirUSA valor) {
    return Expanded(
      child: RadioListTile<FormatoDirUSA>(
        title: Text(titulo, style: TextStyle(fontSize: 12)),
        value: valor,
        groupValue: _formatoUSA,
        dense: true,
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => setState(() => _formatoUSA = v!),
      ),
    );
  }

  Widget _campo(
    String label, {
    bool doble = false,
    bool triple = false,
    String? valorFijo,
    List<TextEditingController>? controllers,
  }) {
    if (doble) assert(controllers == null || controllers.length == 2);
    if (triple) assert(controllers == null || controllers.length == 3);
    if (valorFijo == null && !doble && !triple)
      assert(controllers == null || controllers.length == 1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          if (valorFijo != null)
            TextFormField(initialValue: valorFijo, enabled: false),
          if (doble)
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controllers != null ? controllers[0] : null,
                )),
                SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: controllers != null ? controllers[1] : null,
                )),
              ],
            ),
          if (triple)
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controllers != null ? controllers[0] : null,
                )),
                SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: controllers != null ? controllers[1] : null,
                )),
                SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: controllers != null ? controllers[2] : null,
                )),
              ],
            ),
          if (valorFijo == null && !doble && !triple)
            TextFormField(
              controller: controllers != null ? controllers[0] : null,
            ),
        ],
      ),
    );
  }

  // ================= TELÉFONOS =================
  Widget _buildSeccionTelefonos() => Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("TELÉFONOS"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  for (int i = 0; i < _tiposTelefono.length; i++)
                    Row(
                      children: [
                        Radio<String>(
                          value: _tiposTelefono[i],
                          groupValue: _telefonoSeleccionado,
                          onChanged: (v) {
                            setState(() {
                              _telefonoSeleccionado = v;
                            });
                          },
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 2,
                          child: Text(_tiposTelefono[i],
                              style: TextStyle(fontSize: 12)),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _telefonosControllers[i * 2],
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _telefonosControllers[i * 2 + 1],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _limpiarTelefonos, child: Text("Limpiar")),
                  SizedBox(height: 6),
                  Text(
                    "Debe capturar los teléfonos a 10 dígitos entre la lada y el número de teléfono y seleccionar un teléfono por default.",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ================= EMAIL =================
  Widget _buildSeccionEmail() => Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("EMAIL"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email 1"),
                  TextFormField(
                      enabled: !_noTieneEmail,
                      controller: _emailControllers[0]),
                  SizedBox(height: 8),
                  Text("Email 2"),
                  TextFormField(
                      enabled: !_noTieneEmail,
                      controller: _emailControllers[1]),
                  Text("Email 3"),
                  TextFormField(
                      enabled: !_noTieneEmail,
                      controller: _emailControllers[2]),
                  Text("Email 4"),
                  TextFormField(
                      enabled: !_noTieneEmail,
                      controller: _emailControllers[3]),
                  CheckboxListTile(
                    title: Text("No Tiene Correo Electrónico"),
                    value: _noTieneEmail,
                    dense: true,
                    onChanged: (v) {
                      setState(() {
                        _noTieneEmail = v ?? false;
                        if (_noTieneEmail) {
                          for (var controller in _emailControllers) {
                            controller.clear();
                          }
                        }
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _limpiarEmail,
                      child: Text("Limpiar"),
                    ),
                  ),
                  SizedBox(height: 8), // Espacio
                  Text(
                    "En Caso de no tener ningún Correo Electrónico dejar los campos en blanco y seleccionar la casilla.",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ================= NACIONALIDAD =================
  Widget _buildSeccionNacionalidad() => Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nacionalidad"),
              SizedBox(height: 4),
              DropdownButtonFormField(
                value: "Seleccione",
                items: [
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
                ].map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {},
              ),
            ],
          ),
        ),
      );
}