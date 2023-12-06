import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfintro/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final nameTextController = TextEditingController();

  void signUp() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('not match')));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.signUp(emailTextController.text, passwordTextController.text,
          nameTextController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Image.asset('assets/logo.png'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                      hintText: 'name',
                    ),
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: passwordTextController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: confirmPasswordTextController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                    obscureText: true),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        'sign up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
                          style: TextStyle(
                              color: Colors.yellowAccent[700],
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
