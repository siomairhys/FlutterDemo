import 'package:flutter/material.dart';
import 'snackbar_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netcfluttermvvm/models/story_model.dart';
import 'package:netcfluttermvvm/viewmodels/story_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:netcfluttermvvm/Widgets/build_tag.dart'; // Make sure this import is present

class StoryFormDialog extends ConsumerStatefulWidget {
  const StoryFormDialog({super.key});

  @override
  ConsumerState<StoryFormDialog> createState() => _StoryFormDialogState();
}

class _StoryFormDialogState extends ConsumerState<StoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _responsibleCtrl = TextEditingController();
  String _priority = 'Medium';
  String _severity = 'Medium';
  String _itPhase = 'Analysis';
  

  // Submit the form and create the story with current DateTime
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now(); // Automatically assign current timestamp
      final idStr = now.millisecondsSinceEpoch.toString();
      final id = int.parse(idStr.substring(idStr.length - 10)); // Use last 10 digits for ID

      ref.read(storyProvider.notifier).add(
        StoryModel(
          id: id,
          title: _titleCtrl.text,
          responsible: _responsibleCtrl.text,
          dateTime: now,
          priority: _priority,
          severity: _severity,
          itPhase: _itPhase,
          imagePath: '', // Use empty string if no image
        ),
      );
      showSuccessTopSnackBar(context, "Successfully Created #$id");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Add Story"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title input field
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
          
              // Responsible input field
              TextFormField(
                controller: _responsibleCtrl,
                decoration: const InputDecoration(labelText: "Responsible"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 5),
              DropdownButtonFormField2<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                isExpanded: true,
                items: ['High', 'Medium', 'Low']
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('priority', val), // Colored tag
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ))
                    .toList(),
                selectedItemBuilder: (context) => ['High', 'Medium', 'Low']
                    .map((val) => Row(
                          children: [
                            buildTag('priority', val), // Colored tag in the field
                            const SizedBox(width: 8),
                            Text(val),
                          ],
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  // direction: DropdownDirection.down,
                ),
              ),
          
              const SizedBox(height: 5),
              DropdownButtonFormField2<String>(
                value: _severity,
                decoration: const InputDecoration(labelText: 'Severity'),
                isExpanded: true,
                items: ['High', 'Medium', 'Low']
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('severity', val), // Colored tag
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ))
                    .toList(),
                selectedItemBuilder: (context) => ['High', 'Medium', 'Low']
                    .map((val) => Row(
                          children: [
                            buildTag('severity', val), // Colored tag in the field
                            const SizedBox(width: 8),
                            Text(val),
                          ],
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _severity = val!),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  // You can further customize here
                ),
              ),

              const SizedBox(height: 5),
              DropdownButtonFormField2<String>(
                value: _itPhase,
                decoration: const InputDecoration(labelText: 'I/T Phase'),
                isExpanded: true,
                items: ['Analysis', 'Design', 'I/T']
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('itPhase', val),
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ))
                    .toList(),
                selectedItemBuilder: (context) => ['Analysis', 'Design', 'I/T']
                    .map((val) => Row(
                          children: [
                            buildTag('itPhase', val),
                            const SizedBox(width: 8),
                            Text(val),
                          ],
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _itPhase = val!),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                ),
              ),              
            ],
          ),
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        // Submit button
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
