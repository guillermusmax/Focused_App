import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkResendView extends StatefulWidget {
  const LinkResendView({super.key});

  @override
  State<LinkResendView> createState() => _LinkResendViewState();
}

class _LinkResendViewState extends State<LinkResendView> {
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
                                'Link Resent',
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
