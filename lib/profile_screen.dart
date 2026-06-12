import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isProfilePassHidden = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                ' Sign out',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String customName =
        user?.displayName != null && user!.displayName!.isNotEmpty
        ? user.displayName!
        : 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                Icons.person_rounded,
                size: 55,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              customName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.badge_outlined,
                        color: Colors.teal,
                      ),
                      title: const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      subtitle: Text(
                        customName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: Colors.teal,
                      ),
                      title: const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      subtitle: Text(
                        user?.email ?? 'No linked email',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.teal,
                      ),
                      title: const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      subtitle: Text(
                        _isProfilePassHidden ? '••••••••' : 'Pass@2026',
                        style: TextStyle(
                          fontSize: _isProfilePassHidden ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: _isProfilePassHidden ? 2 : 0,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _isProfilePassHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _isProfilePassHidden = !_isProfilePassHidden;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Sign out',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
