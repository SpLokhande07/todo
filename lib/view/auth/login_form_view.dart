import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_noorisys/view/auth/registration_view.dart';
import '../../pod/auth_pod.dart';

class LoginScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: authState.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).loginUser(
                            _emailController.text,
                            _passwordController.text,
                          );
                      if (ref.read(authProvider).user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).googleSignIn();
                      if (authState.user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text('Sign in with Google'),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Reset Password'),
                          content: TextField(
                            controller: _resetEmailController,
                            decoration:
                                InputDecoration(labelText: 'Enter your email'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await ref
                                    .read(authProvider.notifier)
                                    .resetPassword(
                                      _resetEmailController.text,
                                    );
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Password reset email sent')),
                                );
                              },
                              child: Text('Send Reset Email'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                  if (authState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        authState.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                      );
                    },
                    child: Text('Don\'t have an account? Register'),
                  ),
                ],
              ),
      ),
    );
  }
}
