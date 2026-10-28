
import 'package:flutter/material.dart';

void main() {
  runApp(const QuickRideApp());
}

class QuickRideApp extends StatelessWidget {
  const QuickRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickRide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _rides = [
    'QuickBike',
    'QuickAuto',
    'QuickCab',
    'QuickPremium',
  ];

  final List<int> _fares = [45, 75, 120, 180];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickRide'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _selectedIndex == 0
          ? _buildHome()
          : _selectedIndex == 3
              ? _buildProfile()
              : Center(
                  child: Text(
                    _selectedIndex == 1
                        ? 'Your rides will appear here.'
                        : 'No new notifications.',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Rides',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to QuickRide!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Book your ride quickly and easily.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Where are you going?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Enter destination',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Available Rides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_rides.length, (index) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.directions_car,
                color: Colors.blue,
              ),
              title: Text(_rides[index]),
              subtitle: const Text('Estimated fare'),
              trailing: Text(
                '₹${_fares[index]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _showRideDetails(
                  _rides[index],
                  _fares[index],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProfile() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            child: Icon(Icons.person, size: 40),
          ),
          SizedBox(height: 16),
          Text(
            'User Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your account and preferences.',
          ),
        ],
      ),
    );
  }

  void _showRideDetails(String ride, int fare) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ride),
          content: Text('Estimated fare: ₹$fare'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$ride selected successfully',
                    ),
                  ),
                );
              },
              child: const Text('Select Ride'),
            ),
          ],
        );
      },
    );
  }
}
