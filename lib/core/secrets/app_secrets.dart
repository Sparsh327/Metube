import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final anonKey = dotenv.env['ANON_KEY'] ?? '';
}
