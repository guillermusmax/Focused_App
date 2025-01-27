import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import '../../api/api_service.dart';
import '../../api/models/auth_storage.dart';
import '../../generated/l10n.dart';

class ChangePasswordPopup extends StatefulWidget {
  @override
  _ChangePasswordPopupState createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends State<ChangePasswordPopup> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Para validaciones

  final AuthStorage _authStorage = AuthStorage();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage; // Para mostrar errores de API

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return; // Validar antes de enviar

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String? token = await _authStorage.getToken();
    if (token == null) {
      setState(() {
        _errorMessage = S.current.tokenUnavailable;
        _isLoading = false;
      });
      return;
    }

    final Map<String, String> requestData = {
      "old_password": _oldPasswordController.text,
      "password": _newPasswordController.text,
    };

    final String? apiError = await _apiService.changePassword(token, requestData);

    setState(() {
      _isLoading = false;
      _errorMessage = apiError; // Guardamos el error si la API falló
    });

    if (apiError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.passwordUpdated)),
      );
      Navigator.of(context).pop(); // Cerrar el diálogo si el cambio fue exitoso
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        S.current.changePassword,
        style: const TextStyle(color: textTertiaryColor),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: S.current.oldPassword,
                labelStyle: const TextStyle(color: primaryColor),
                border: const UnderlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.enterOldPassword;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: S.current.newPassword,
                labelStyle: const TextStyle(color: primaryColor),
                border: const UnderlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.enterNewPassword;
                } else if (value.length < 6) {
                  return S.current.passwordTooShort;
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: secondaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _changePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(S.current.confirm),
        ),
      ],
    );
  }
}
