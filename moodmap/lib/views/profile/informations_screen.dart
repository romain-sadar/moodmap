import 'package:flutter/material.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String name = "Alice Mathey";
  String email = "alice.mathey@example.com";
  int age = 25;
  String gender = "Female";
  String password = "********";

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
      if (field == "Password") password = "********";
      isEditing[field] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Informations")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Permet de cacher le clavier en tapant ailleurs
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildInfoTile("Name", name, _nameController),
                buildInfoTile("Email", email, _emailController),
                buildInfoTile("Age", age.toString(), _ageController),
                buildInfoTile("Gender", gender, _genderController),
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
