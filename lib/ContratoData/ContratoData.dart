class ContratoData {
  final String nombre;
  final int? idUsuario;
  final String? nivel;
  final int? segmento;
  final int? area;
  final String? grupo;
  final String? urlContrato;
  final String? urlReglamento;

  ContratoData({
    required this.nombre,
    this.idUsuario,
    this.nivel,
    this.segmento,
    this.area,
    this.grupo,
    this.urlContrato,
    this.urlReglamento,
  });

  factory ContratoData.fromJson(Map<String, dynamic> json) {
    return ContratoData(
      nombre: json['Nombre'] ?? '',
      idUsuario: int.tryParse(json['IdUsuario']?.toString() ?? ''),
      nivel: json['Nivel'],
      segmento: int.tryParse(json['Segmento']?.toString() ?? ''),
      area: int.tryParse(json['Area']?.toString() ?? ''),
      grupo: json['Grupo'],
      urlContrato: json['UrlContrato'],
      urlReglamento: json['UrlReglamento'],
    );
  }
}
