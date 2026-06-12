import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _isPasswordHidden = true;

  void _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (password.isEmpty || (!_isLogin && name.isEmpty) || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields',
            textAlign: TextAlign.right,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(name);
          await userCredential.user!.reload();
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred, please try again later';
      if (e.code == 'weak-password') message = 'Password is too weak';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use';
      }
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      }
      if (e.code == 'wrong-password') message = 'Incorrect password';

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, textAlign: TextAlign.right)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLogin ? 'Log In' : 'Create New Account',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (!_isLogin) ...[
                    TextField(
                      controller: _nameController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.teal)
                      : ElevatedButton(
                          onPressed: _submitAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isLogin ? ' Log In' : 'Sign Up',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                            ),
                          ),
                        ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Dont have an account? Sign up now'
                          : 'Already have an account? Log in',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
