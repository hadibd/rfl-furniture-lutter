import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
              'User Sign Up',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: nameController,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'User Name',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                suffixIcon: IconButton(
                  onPressed: () {
                    nameController.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.clear),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: phoneController,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'User phone',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                suffixIcon: IconButton(
                  onPressed: () {
                    phoneController.clear();
                    setState(() {});
                  },
                  icon: Icon(Icons.clear),
                ),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(
              height: 16,
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
              onPressed: () {
                userSignUp();
              },
              child: const Text('Sign up'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sign in',
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

  void userSignUp() async {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        mailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: mailController.text, password: passwordController.text);
        saveUserData();
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          showErrorDialog('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showErrorDialog('The account already exists for that email.');
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      showErrorDialog('Please fill all the fields');
    }
  }

  saveUserData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(mailController.text).set({
      'name': nameController.text,
      'phone': phoneController.text,
      'email': mailController.text
    });
  }

  showErrorDialog(String errorMsg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Warning!!!'.toUpperCase(),
              style: TextStyle(color: Colors.red),
            ),
            content: Text(errorMsg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
