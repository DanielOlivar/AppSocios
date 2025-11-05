class ContratoData {
  final String error;
  final int? idVenta;
  final String? xref;
  final String? owner;
  final int? proyectoId;
  final String? nombre1;
  final String? nombre2;
  final String? nombre3;
  final String? nombre4;
  final String? urlContrato;
  final String? urlReglamento;

  ContratoData({
    required this.error,
    this.idVenta,
    this.xref,
    this.owner,
    this.proyectoId,
    this.nombre1,
    this.nombre2,
    this.nombre3,
    this.nombre4,
    this.urlContrato,
    this.urlReglamento,
  });

  factory ContratoData.fromJson(Map<String, dynamic> json) {
    return ContratoData(
      error: json['Error'] ?? '',
      idVenta: json['IdVenta'],
      xref: json['Xref'],
      owner: json['Owner'],
      proyectoId: json['ProyectoId'],
      nombre1: json['Nombre1'],
      nombre2: json['Nombre2'],
      nombre3: json['Nombre3'],
      nombre4: json['Nombre4'],
      urlContrato: json['URLContrato'],
      urlReglamento: json['URLReglamento'],
    );
  }
}
