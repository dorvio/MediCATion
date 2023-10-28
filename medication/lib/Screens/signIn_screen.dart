import 'package:flutter/material.dart';
import 'package:medication/Services/authorization.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'profile_screen.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final AuthorizationService _authorizationService = AuthorizationService();
  final _formKey =GlobalKey<FormState>();
  bool showErrorEmail = false;
  bool showErrorPassword = false;
  String email = '';
  String password = '';
  bool hidePassword = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MediCATion'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Form (
          key: _formKey,
          child: Column (
            children: [
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Zaloguj się",
                      style: GoogleFonts.cinzel(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 174, 199, 255),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Podaj email',
                  labelStyle: const TextStyle(color: Colors.white),
                  counterStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 174, 199, 255)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorText: showErrorEmail ? 'Pole nie może być puste!' : null,
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Colors.white,
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    setState(() {
                      showErrorEmail = true;
                    });
                    return 'Pole nie może być puste!';
                  }
                  if(!EmailValidator.validate(text)){
                    setState(() {
                      showErrorEmail = true;
                    });
                    return 'Niepoprawna forma adresu email';
                  }
                  setState(() {
                    showErrorEmail = false;
                  });
                  return null;
                },
                onChanged: (text) => setState(() => email = text),
              ),
              const SizedBox(height: 40),
              TextFormField(
                obscureText: hidePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Podaj hasło',
                  labelStyle: const TextStyle(color: Colors.white),
                  counterStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 174, 199, 255)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  errorText: showErrorPassword ? 'Pole nie może być puste!' : null,
                  prefixIcon: const Icon(Icons.key),
                  prefixIconColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: hidePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                  suffixIconColor: Colors.grey[600],
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    setState(() {
                      showErrorPassword = true;
                    });
                    return 'Pole nie może być puste!';
                  }
                  setState(() {
                    showErrorPassword = false;
                  });
                  return null;
                },
                onChanged: (text) => setState(() => password = text),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 115),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: const Text('Brak konta? Zarejestruj się!'),
                    onPressed: () {
                      _goToRegisterScreen(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  )
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _authorizationService.signInEmail(email, password);
                      if(result == null) {
                        errorMessage = "Email lub hasło jest nieprawidłowe. Spróbuj ponownie lub zarejestruj się.";
                      } else {
                        errorMessage = '';
                      }
                    }
                  },
                  child: const Text(
                    "Zaloguj",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )
                  )
              ),
            ]
          )
        )
      )
    );
  }
}

void _goToRegisterScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegisterView()),
  );
}




