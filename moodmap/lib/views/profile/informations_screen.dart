import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String name = "";
  String email = "";
  int age = 0;
  String gender = "";
  String password = "********"; // Default masked password

  Map<String, bool> isEditing = {
    "Name": false,
    "Email": false,
    "Age": false,
    "Gender": false,
    "Password": false,
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load the user data when the screen is initialized
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user'); // Assuming the full user data is saved in SharedPreferences

    if (userJson != null) {
      // Assuming the user data is saved as a JSON string and we can parse it
      Map<String, dynamic> userData = json.decode(userJson);

      setState(() {
        name = userData['username'] ?? "Unknown";
        email = userData['email'] ?? "Unknown";
        age = userData['age'] ?? 0;
        gender = userData['gender'] ?? "";
      });

      // Initialize controllers with the fetched values
      _nameController.text = name;
      _emailController.text = email;
      _ageController.text = age == 0 ? "" : age.toString(); // If age is not set, leave it empty
      _genderController.text = gender.isEmpty ? "" : gender; // If gender is not set, leave it empty
    }
  }

  void toggleEditing(String field) {
    setState(() {
      isEditing[field] = !isEditing[field]!;
      if (isEditing[field]!) {
        if (field == "Name") _nameController.text = name;
        if (field == "Email") _emailController.text = email;
        if (field == "Age") _ageController.text = age.toString();
        if (field == "Gender") _genderController.text = gender;
        if (field == "Password") _passwordController.text = "";
      }
    });
  }

  void saveChanges(String field) {
    setState(() {
      if (field == "Name") name = _nameController.text;
      if (field == "Email") email = _emailController.text;
      if (field == "Age") age = int.tryParse(_ageController.text) ?? age;
      if (field == "Gender") gender = _genderController.text;
      if (field == "Password") password = "********"; // Mask password after saving
      isEditing[field] = false;
    });

    // You may want to save the updated data back to SharedPreferences
    SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    prefs.setString('user', json.encode({
      'username': name,
      'email': email,
      'age': age,
      'gender': gender,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Information")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard when tapping outside
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildInfoTile("Name", name, _nameController),
                buildInfoTile("Email", email, _emailController),
                buildInfoTile("Age", age == 0 ? "Not set" : age.toString(), _ageController),
                buildInfoTile("Gender", gender.isEmpty ? "Not set" : gender, _genderController),
                buildInfoTile("Password", password, _passwordController, obscureText: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile(String field, String value, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      children: [
        ListTile(
          title: Text(field, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: isEditing[field]!
              ? TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: "Enter new $field",
              border: OutlineInputBorder(),
            ),
          )
              : Text(value, style: TextStyle(fontSize: 16)),
          trailing: isEditing[field]!
              ? IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () => saveChanges(field),
          )
              : IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => toggleEditing(field),
          ),
        ),
        Divider(),
      ],
    );
  }
}
