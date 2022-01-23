import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rfl_furniture/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'User Login',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: mailController,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'User mail',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                suffixIcon: IconButton(
                  onPressed: () {
                    mailController.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.clear),
                ),
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              obscureText: isVisible,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'User password',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                suffixIcon: InkWell(
                    onTap: () {
                      isVisible = !isVisible;
                      setState(() {});
                    },
                    child: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off)),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            MaterialButton(
              color: Colors.blue,
              minWidth: double.infinity,
              height: 50,
              shape: const StadiumBorder(),
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: mailController.text,
                          password: passwordController.text);
                  var user = userCredential.user;
                  if (user != null) {
                    print(user.uid);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              },
              child: const Text('Log in'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    'Create one',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
