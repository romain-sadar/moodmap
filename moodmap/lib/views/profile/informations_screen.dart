import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moodmap/core/constants.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String name = "";
  String email = "";
  int age = 0;
  String gender = "N";
  String password = "********";

  bool isLoading = true;

  Map<String, bool> isEditing = {
    "Name": false,
    "Age": false,
    "Gender": false,
    "Password": false,
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<Map<String, String>> genderChoices = [
    {"M": "Male"},
    {"F": "Female"},
    {"O": "Other"},
    {"N": "Prefer not to say"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      if (token == null) return;

      final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}/profile/me/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data["username"];
          email = data["email"];
          age = data["age"] ?? 0;
          gender = data["gender"] ?? "N";
          isLoading = false;
        });
      } else {
        _showSnackBar("Failed to fetch user info.");
      }
    } catch (e) {
      _showSnackBar("Error fetching user info.");
    }
  }

  void toggleEditing(String field) {
    setState(() {
      isEditing[field] = !isEditing[field]!;
      if (isEditing[field]!) {
        if (field == "Name") _nameController.text = name;
        if (field == "Age") _ageController.text = age.toString();
      }
    });
  }

  Future<void> saveChanges(String field) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");
      if (token == null) return;

      Map<String, dynamic> updatedData = {};
      if (field == "Name") updatedData["username"] = _nameController.text;
      if (field == "Age") updatedData["age"] = int.tryParse(_ageController.text) ?? age;
      if (field == "Gender") updatedData["gender"] = gender;
      if (field == "Password") {
        if (_passwordController.text.length < 6) {
          _showSnackBar("Password must be at least 6 characters long.");
          return;
        }
        updatedData["password"] = _passwordController.text;
      }

      final response = await http.patch(
        Uri.parse("${AppConstants.apiBaseUrl}/profile/me/"),
        body: jsonEncode(updatedData),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          if (field == "Name") name = _nameController.text;
          if (field == "Age") age = int.tryParse(_ageController.text) ?? age;
          if (field == "Gender") gender = gender;
          if (field == "Password") password = "********";
          isEditing[field] = false;
        });

        Map<String, dynamic> userData = {
          "username": name,
          "email": email,
          "age": age,
          "gender": gender,
        };
        prefs.setString("user", jsonEncode(userData));

        _showSnackBar("$field updated successfully!");
      } else {
        _showSnackBar("Failed to update $field.");
      }
    } catch (e) {
      _showSnackBar("Error updating $field.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Information")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildInfoTile("Name", name, _nameController),
                      buildInfoTile("Age", age.toString(), _ageController),
                      buildGenderDropdown(),
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
          title: Text(field, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: isEditing[field]!
              ? TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: "Enter new $field",
                    border: const OutlineInputBorder(),
                  ),
                )
              : Text(value, style: const TextStyle(fontSize: 16)),
          trailing: isEditing[field]!
              ? IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => saveChanges(field),
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => toggleEditing(field),
                ),
        ),
        const Divider(),
      ],
    );
  }

  Widget buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      items: genderChoices.map((choice) {
        String key = choice.keys.first;
        return DropdownMenuItem(value: key, child: Text(choice[key]!));
      }).toList(),
      onChanged: (newValue) => setState(() => gender = newValue!),
      decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
    );
  }
}
