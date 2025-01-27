import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/signup_verification_view.dart';
import 'package:google_fonts/google_fonts.dart';
class SignupPsicoCodeView extends StatefulWidget {
  const SignupPsicoCodeView({super.key});

  @override
  State<SignupPsicoCodeView> createState() => _SignupPsicoCodeViewState();
}

class _SignupPsicoCodeViewState extends State<SignupPsicoCodeView> {

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
                            height: 100,
                          ),
                          Image.asset(
                            'assets/icons/Focused_Icon.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                           Text(
                            'Psycologist\n or \n Psychiatrist \n Code',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 25,
                              color: textSecondaryColor,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                            height: 68,
                              width: 64,
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.headlineLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                            SizedBox(
                              height: 68,
                              width: 64,
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 64,
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 64,
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 64,
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return const SignupVerificationView();
                                      }));
                                },
                                child: Center(
                                  child: Text(
                                    'Sign Up',
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
