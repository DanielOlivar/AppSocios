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
  bool _noTieneEmail = false;

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
                    ElevatedButton(onPressed: () {}, child: Text("Limpiar")),
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

  Widget _buildFormularioDinamico() {
    switch (_pais) {
      case PaisSeleccionado.mexico:
        return _buildFormMexico();
      case PaisSeleccionado.usa:
        return _buildFormUSA();
      case PaisSeleccionado.canada:
        return _buildFormCanada();
      case PaisSeleccionado.otro:
        return _buildFormOtro();
    }
  }

  Widget _buildFormMexico() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Calle"),
      _campo(
        "N° Ext                                                                                         N° Int                                                          Código Postal",
        triple: true,
      ),
      _campo("Colonia"),
      _campo("Delegación o Municipio"),
      _campo("Ciudad"),
      _campo("Estado"),
      _campo("País", valorFijo: "México"),
    ],
  );

  Widget _buildFormUSA() => Column(
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
      _campo("Street"),
      _campo("City"),
      _campo("State                                                                                                                   Zip Code", doble: true),
      _campo("País", valorFijo: "USA"),
    ],
  );

  Widget _buildFormCanada() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _campo("Street"),
      _campo("City"),
      _campo("Province                                                                                                                   Zip Code", doble: true),
      _campo("País", valorFijo: "Canada"),
    ],
  );

  Widget _buildFormOtro() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int i = 1; i <= 5; i++) _campo("Línea $i"),
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
  }) {
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
                Expanded(child: TextFormField()),
                SizedBox(width: 8),
                Expanded(child: TextFormField()),
              ],
            ),
          if (triple)
            Row(
              children: [
                Expanded(child: TextFormField()),
                SizedBox(width: 8),
                Expanded(child: TextFormField()),
                SizedBox(width: 8),
                Expanded(child: TextFormField()),
              ],
            ),
          if (valorFijo == null && !doble && !triple) TextFormField(),
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
              for (var tel in [
                "Casa 1",
                "Casa 2",
                "Oficina 1",
                "Oficina 2",
                "Celular 1",
                "Celular 2",
                "Mensajes",
              ])
                Row(
                  children: [
                    Radio(value: tel, groupValue: "Casa 1", onChanged: (v) {}),
                    SizedBox(width: 4),
                    Expanded(
                      flex: 2,
                      child: Text(tel, style: TextStyle(fontSize: 12)),
                    ),
                    SizedBox(width: 4),
                    Expanded(flex: 1, child: TextFormField()),
                    SizedBox(width: 4),
                    Expanded(flex: 3, child: TextFormField()),
                  ],
                ),
              SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text("Limpiar")),
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
              TextFormField(enabled: !_noTieneEmail),
              SizedBox(height: 8),
              Text("Email 2"),
              TextFormField(enabled: !_noTieneEmail),
              Text("Email 3"),
              TextFormField(enabled: !_noTieneEmail),
              Text("Email 4"),
              TextFormField(enabled: !_noTieneEmail),
              CheckboxListTile(
                title: Text("No Tiene Correo Electrónico"),
                value: _noTieneEmail,
                dense: true,
                onChanged: (v) => setState(() => _noTieneEmail = v ?? false),
                contentPadding: EdgeInsets.zero,
              ),
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
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
        ],
      ),
    ),
  );
}
