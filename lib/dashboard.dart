import 'package:flutter/material.dart';
import 'sensor_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Slightly off-white background
      appBar: AppBar(
        title: const Text(
            'AquaSense Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Reservoir Data',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: Device Online (Battery: 85%)',
              style: TextStyle(fontSize: 14, color: Colors.green[700]),
            ),
            const SizedBox(height: 24),

            // Your GridView goes here
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: const [
                  SensorCard(title: 'pH Level', value: '7.2', unit: 'pH', icon: Icons.science, color: Colors.purple),
                  SensorCard(title: 'TDS', value: '450', unit: 'ppm', icon: Icons.water_drop, color: Colors.blue),
                  SensorCard(title: 'Turbidity', value: '12', unit: 'NTU', icon: Icons.blur_on, color: Colors.brown),
                  SensorCard(title: 'Temp', value: '28.5', unit: '°C', icon: Icons.thermostat, color: Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button for Manual Trigger
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add Firebase "manual_trigger = true" logic here later
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Manual reading requested from ESP32...')),
          );
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Take Reading Now'), // This fixes the red line in your code!
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}