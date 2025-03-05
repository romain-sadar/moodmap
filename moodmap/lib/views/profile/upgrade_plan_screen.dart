import 'package:flutter/material.dart';
import 'package:moodmap/core/services/auth_service.dart';
import 'package:moodmap/core/themes.dart';

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  /// ✅ Upgrade the user plan
  Future<void> _upgradePlan() async {
  setState(() {
    _isLoading = true;
  });

  bool success = await _authService.upgradeToPremium();

  setState(() {
    _isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(success ? "🎉 You are now a Premium user!" : "❌ Failed to upgrade. Try again!"),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upgrade Your Plan")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.blue,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "SGD 8.99 / month",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Unlock the full experience with Premium:\n",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        "✨ Unlimited access to exclusive content\n"
                        "📊 Advanced analytics & insights\n"
                        "⭐ Like & review places you've explored\n"
                        "⚡ Priority support for a seamless experience",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _upgradePlan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.black)
                            : Text(
                                "Upgrade",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
