import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfintro/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signIn(
          emailTextController.text, passwordTextController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Image.asset('assets/logo.png'),
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
                  height: 20,
                ),
                GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        'sign in',
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
                    const Text('Not a member?'),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                              color: Colors.yellowAccent[700],
                              fontWeight: FontWeight.w700),
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
