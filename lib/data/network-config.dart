import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConfig {
  static String baseUrl =  dotenv.env['BASE_URL']!;
}