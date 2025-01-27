import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa traducciones
import 'package:provider/provider.dart'; // Importa Provider
import '../../../api/state_models.dart';
import 'widget_pop_up.dart';

class EditableButton extends StatefulWidget {
  final String initialText;
  final int categoryId; // ID de la categoría
  final String token;   // Token del usuario
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;

  const EditableButton({
    super.key,
    required this.initialText,
    required this.categoryId,
    required this.token,
    this.backgroundColor = primaryColor,
    this.iconColor = textPrimaryColor,
    this.textColor = textPrimaryColor,
    this.onTap,
  });

  @override
  _EditableButtonState createState() => _EditableButtonState();
}

class _EditableButtonState extends State<EditableButton> {
  late String displayText;

  @override
  void initState() {
    super.initState();
    displayText = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.edit, color: widget.iconColor),
                onPressed: () => _editCategory(context),
              ),
            ),
            Center(
              child: Text(
                displayText,
                style: TextStyle(color: widget.textColor, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editCategory(BuildContext context) {
    final textController = TextEditingController(text: displayText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          controller: textController,
          title: S.current.editCategory,
          buttonText: S.current.save,
          isEditing: true,
          onSave: () async {
            if (textController.text.isNotEmpty) {
              await _updateCategory(context, textController.text);
              Navigator.of(context).pop();
            }
          },
          onDelete: () async {
            await _deleteCategory(context);
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> _updateCategory(BuildContext context, String newName) async {
    final success = await _handleProviderOperation<bool>(
      context,
          (provider) => provider.updateCategory(widget.token, widget.categoryId, newName),
    );
    if (success == true) {
      setState(() {
        displayText = newName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.flashcardUpdated)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorUpdatingMedication)),
      );
    }
  }

  Future<void> _deleteCategory(BuildContext context) async {
    final success = await _handleProviderOperation<bool>(
      context,
          (provider) => provider.deleteCategory(widget.token, widget.categoryId),
    );
    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.deleteFlashcard)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorDeletingFlashcard)),
      );
    }
  }

  Future<T?> _handleProviderOperation<T>(
      BuildContext context,
      Future<T> Function(dynamic provider) operation,
      ) async {
    final flashcardProvider = Provider.of<FlashcardCategoryState>(context, listen: false);
    final taskProvider = Provider.of<TaskCategoryState>(context, listen: false);

    try {
      if (taskProvider.categories.isNotEmpty) {
        return await operation(taskProvider);
      } else if (flashcardProvider.categories.isNotEmpty) {
        return await operation(flashcardProvider);
      }
    } catch (e) {
      print('Error in provider operation: $e');
    }
    return null;
  }
}
