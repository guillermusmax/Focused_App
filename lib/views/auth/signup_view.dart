import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/signup_verification_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewViewState();
}

class _SignupViewViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _selectedSex;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  DateTime? _selectedDate;

  final ApiService apiService = ApiService();

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your birthdate',
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }

      final Map<String, dynamic> userData = {
        "usuario": {
          "nombre": _emailController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "id_rol": 1,
        },
        "patient": {
          "name": _nameController.text.trim(),
          "lastname": _lastnameController.text.trim(),
          "birthdate": "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
          "phone": _phoneController.text.trim(),
          "allergies": "",
          "condition": "",
          "sex": _selectedSex!.trim(),
        }
      };

      try {
        await apiService.signUp(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SignupVerificationView();
        }));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textSecondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/Focused_Icon.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField('Name', _nameController, Icons.person),
                  const SizedBox(height: 10),
                  _buildTextField('Last Name', _lastnameController, Icons.person),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today, color: textSecondaryColor),
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please select your birthdate';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Your Email', _emailController, Icons.email),
                  const SizedBox(height: 20),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _phoneController,
                    initialCountryCode: 'US',
                    validator: (value) {
                      if (value == null || value.completeNumber.trim().isEmpty) {
                        return 'Phone cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: textSecondaryColor),
                      labelText: 'Sex',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Male')),
                      DropdownMenuItem(value: 'F', child: Text('Female')),
                    ],
                    onChanged: (value) => _selectedSex = value,
                    validator: (value) => value == null ? 'Sex must be selected' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField('Password', _passwordController, true),
                  const SizedBox(height: 10),
                  _buildPasswordField('Confirm Password', _confirmPasswordController, false),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: _signup,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textSecondaryColor),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
      value == null || value.isEmpty ? '$label cannot be empty' : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : _obscureConfirmPassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: textSecondaryColor),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            isPassword
                ? (_obscurePassword ? Icons.visibility : Icons.visibility_off)
                : (_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
            color: textSecondaryColor,
          ),
          onPressed: () {
            setState(() {
              if (isPassword) {
                _obscurePassword = !_obscurePassword;
              } else {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }

        // Expresión regular para validar la contraseña
        final regex = RegExp(r'^(?=.*[A-Z])(?=.*[\W_]).{8,}$');

        if (!regex.hasMatch(value)) {
          return 'Password must contain at least one uppercase letter,\none special character, and be at least 8 characters long';
        }

        return null;
      },
    );
  }
}
