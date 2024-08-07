class KimikoResponse {
  final  dynamic data;
  final String? error;
  final int? statusCode;

  KimikoResponse( {this.data, this.error, this.statusCode});

  bool get isSuccess => error == null;
}
