import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart';

import '../../models/change_password_popup.dart'; // Importación para traducciones

class EditProfilePopup extends StatefulWidget {
  const EditProfilePopup({super.key});

  @override
  _EditProfilePopupState createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final AuthStorage _authStorage = AuthStorage();

  String name = "";
  String lastname = "";
  String phone = "";
  String allergies = "";
  String condition = "";
  String birthdate = "";
  String password = "";
  String sex = "Male";

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final String? token = await _authStorage.getToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        final ApiService apiService = ApiService();
        final patientInfo = await apiService.getPatientInfo(token);

        if (patientInfo != null) {
          setState(() {
            name = patientInfo['name'] ?? "N/A";
            lastname = patientInfo['lastname'] ?? "N/A";
            phone = patientInfo['phone'] ?? "N/A";
            allergies = patientInfo['allergies'] ?? S.current.noAllergies;
            condition = patientInfo['condition'] ?? S.current.noCondition;
            password = patientInfo['password'] ?? S.current.encryptedPassword;
            birthdate =
                patientInfo['birthdate']?.substring(0, 10) ?? S.current.unknown;

            final String userSex = patientInfo['sex']?.toUpperCase() ?? "M";
            sex = (userSex == "M" || userSex == "MALE")
                ? S.current.male
                : S.current.female;

            _nameController.text = name;
            _lastnameController.text = lastname;
            _phoneController.text = phone;
            _passwordController.text = password;
            allergiesController.text = allergies;
          });
        }
      } else {
        print(S.current.invalidToken);
      }
    } catch (e) {
      print("${S.current.errorFetchingPatient}: $e");
    }
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _showChangePasswordPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangePasswordPopup();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: backgroundColor,
      child: SingleChildScrollView(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: secondaryColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: secondaryColor),
                    onPressed: _toggleEditing,
                  ),
                ],
              ),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: secondaryColor,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: S.current.name,
                  labelStyle: const TextStyle(color: primaryColor),
                  border: const UnderlineInputBorder(),
                ),
                enabled: isEditing,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: S.current.lastname,
                  labelStyle: const TextStyle(color: primaryColor),
                  border: const UnderlineInputBorder(),
                ),
                enabled: isEditing,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: S.current.phoneNumber,
                  labelStyle: const TextStyle(color: primaryColor),
                  border: const UnderlineInputBorder(),
                ),
                enabled: isEditing,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: TextEditingController(text: birthdate),
                decoration: InputDecoration(
                  labelText: S.current.birthdate,
                  labelStyle: const TextStyle(color: primaryColor),
                  border: const UnderlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: sex,
                decoration: InputDecoration(
                  labelText: S.current.sex,
                  labelStyle: const TextStyle(color: primaryColor),
                  border: const UnderlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                      value: S.current.male, child: Text(S.current.male)),
                  DropdownMenuItem(
                      value: S.current.female, child: Text(S.current.female)),
                ],
                onChanged: null,
              ),
              const SizedBox(height: 8.0),
              Center(
                child: TextButton(
                  onPressed: () => _showChangePasswordPopup(),
                  style: TextButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(S.current.changePassword),
                ),
              ),
              if (isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _nameController.text = name;
                          _lastnameController.text = lastname;
                          _phoneController.text = phone;
                          isEditing = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(S.current.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedData = {
                          "name": _nameController.text,
                          "lastname": _lastnameController.text,
                          "phone": _phoneController.text,
                        };

                        final String? token = await _authStorage.getToken();

                        if (token != null) {
                          final ApiService apiService = ApiService();
                          bool success = await apiService.updatePatientInfo(
                              token, updatedData);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(S.current.infoUpdated)),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(S.current.updateError)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.current.tokenUnavailable)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(S.current.confirm),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
