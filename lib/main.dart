import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/tabs.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: TabsScreen(),
      ),
    ),
  );
}
