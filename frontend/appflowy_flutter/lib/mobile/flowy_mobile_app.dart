import 'package:flutter/material.dart';

class FlowyMobileApp extends StatefulWidget {
  const FlowyMobileApp({super.key});

  @override
  State<FlowyMobileApp> createState() => _FlowyMobileAppState();
}

class _FlowyMobileAppState extends State<FlowyMobileApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlowyMobileHomePage(),
    );
  }
}

class FlowyMobileHomePage extends StatelessWidget {
  const FlowyMobileHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlowyMobile'),
      ),
      body: const Center(
        child: Text(
          'FlowyMobile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
