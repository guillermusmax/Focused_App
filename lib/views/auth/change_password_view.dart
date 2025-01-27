import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/password_verification_view.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 120,
                          ),
                          Image.asset(
                            'assets/icons/Focused_Icon.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: textSecondaryColor,
                                ),
                                labelText: 'Password',
                                hintText: 'password',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                fillColor: Colors.white,
                                filled: true
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: textSecondaryColor,
                                ),
                                labelText: 'Confirm Password',
                                hintText: 'confirm password',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                fillColor: Colors.white,
                                filled: true
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const PasswordVerificationView();
                                  },) );
                                },
                                child: Center(
                                  child: Text(
                                    'Change Password',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                  )
              )
            ],
          )
      ),
    );
  }
}
