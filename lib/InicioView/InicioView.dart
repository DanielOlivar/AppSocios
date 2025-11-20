import 'package:flutter/material.dart';
import '../ContratoData/ContratoData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioView extends StatelessWidget {
  final ContratoData datosContrato;

  const InicioView({super.key, required this.datosContrato});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 12, 36, 1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logoBlanco.png', width: 35, height: 35),
            const SizedBox(width: 8),
            const Text(
              "Pacífica Resorts",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Bienvenida
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '¡Bienvenido ${datosContrato.nombre.isNotEmpty ? datosContrato.nombre : "Empleado de Pacífica Resorts"}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _logout(context),
                  child: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: Color.fromRGBO(18, 12, 36, 1),
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 15),

            // Número de empleado
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.credit_card,
                  color: Color.fromRGBO(18, 12, 36, 1),
                ),
                title: const Text('Número de empleado'),
                subtitle: Text(
                  datosContrato.idUsuario?.toString() ?? 'No disponible',
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Nivel
            if (datosContrato.nivel != null && datosContrato.nivel!.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Color.fromRGBO(18, 12, 36, 1),
                  ),
                  title: const Text('Nivel'),
                  subtitle: Text(datosContrato.nivel!),
                ),
              ),

            const SizedBox(height: 10),

            // Segmento
            if (datosContrato.segmento != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.layers,
                    color: Color.fromRGBO(18, 12, 36, 1),
                  ),
                  title: const Text('Segmento'),
                  subtitle: Text(datosContrato.segmento!.toString()),
                ),
              ),

            const SizedBox(height: 10),

            // Grupo
            if (datosContrato.grupo != null && datosContrato.grupo!.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    color: Color.fromRGBO(18, 12, 36, 1),
                  ),
                  title: const Text('Grupo'),
                  subtitle: Text(datosContrato.grupo!),
                ),
              ),

            const SizedBox(height: 10),

            // Contrato (si existe)
            if (datosContrato.urlContrato != null &&
                datosContrato.urlContrato!.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.insert_drive_file,
                    color: Color.fromRGBO(18, 12, 36, 1),
                  ),
                  title: const Text('Ver contrato'),
                  subtitle: Text(datosContrato.urlContrato!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abrir contrato (no implementado)'),
                      ),
                    );
                  },
                ),
              ),

            // Reglamento (si existe)
            if (datosContrato.urlReglamento != null &&
                datosContrato.urlReglamento!.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.book_outlined,
                    color: Color.fromRGBO(18, 12, 36, 1),
                  ),
                  title: const Text('Ver reglamento'),
                  subtitle: Text(datosContrato.urlReglamento!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Abrir reglamento (no implementado)'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
