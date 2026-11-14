import 'package:flutter/material.dart';

/// Dietary and allergy profiles management screen.
class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietary & Allergy Profiles')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('D')),
              title: Text('Dilshan (Self)'),
              subtitle: Text('Severe: Peanuts, Tree Nuts | Moderate: Gluten'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('C')),
              title: Text('Child'),
              subtitle: Text('Severe: Cow Milk (Lactose, Casein), Egg Whites'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('P')),
              title: Text('Partner'),
              subtitle: Text('No severe allergies. Vegetarian preference.'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
      ),
    );
  }
}
