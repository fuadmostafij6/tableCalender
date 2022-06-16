import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  bool changeBtn = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "images/login.png",
              fit: BoxFit.cover,
              //height: 900,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Welcome $name",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 32.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return "check gmail";
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter UserName or Email",
                        labelText: "Username",
                      ),
                      onChanged: (value) {
                        name = value;
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return "check password";
                        }
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            changeBtn = true;
                          });
                          print("Valid");
                        }

                        // await Future.delayed(Duration(seconds: 1));
                        // Navigator.pushNamed(context, MyRoute.homeRoute);
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: changeBtn ? 50 : 150,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          //shape: changeBtn ? BoxShape.circle : BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                            changeBtn ? 50 : 8,
                          ),
                        ),
                        //changeBtn ? Icons(Icons.done color: Colors.white) :
                        child: changeBtn
                            ? Icon(Icons.done, color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 250.0,
            ),
          ],
        ),
      ),
    );
  }
}
