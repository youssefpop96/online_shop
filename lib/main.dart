import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://luogcwqjclkbtcxrjynd.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1b2djd3FqY2xrYnRjeHJqeW5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzNTI3ODgsImV4cCI6MjA3NTkyODc4OH0._b4BaQhpVkjvH5-5ws8D9RE7qYt4EV2Tq6M2S_FWJDc",
  );

  runApp(MyApp());
}
