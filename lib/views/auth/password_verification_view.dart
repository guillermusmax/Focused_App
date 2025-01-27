import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordVerificationView extends StatefulWidget {
  const PasswordVerificationView({super.key});

  @override
  State<PasswordVerificationView> createState() => _PasswordVerificationViewState();
}

class _PasswordVerificationViewState extends State<PasswordVerificationView> {
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
                            height: 200,
                          ),
                          Image.asset(
                            'assets/icons/Focused_Icon.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const LoginView();
                              },));
                            },
                            child: Text(
                                'Password Reset \n Confirmation Send',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                )
                            ),
                          ),
                        ],

                      )
                  )
              )
            ],
          )
      ),
    );
  }
}
