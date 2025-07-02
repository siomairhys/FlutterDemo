import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:netcfluttermvvm/models/story_model.dart';
import 'package:netcfluttermvvm/viewmodels/story_provider.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';
import 'package:netcfluttermvvm/widgets/snackbar_status.dart';

/// View and edit details of a single story
class StoryDetailPage extends ConsumerStatefulWidget {
  final int storyId;

  const StoryDetailPage({super.key, required this.storyId});

  @override
  ConsumerState<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends ConsumerState<StoryDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late StoryModel story;
  late TextEditingController titleCtrl;
  late TextEditingController responsibleCtrl;
  late DateTime? dateTime;
  late String priority;
  late String severity;
  late String itPhase;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    // Get the story by ID from the provider
    final data = ref.read(storyProvider.notifier).getById(widget.storyId);
    story = data!;

    // Initialize form field values from the story
    titleCtrl = TextEditingController(text: story.title);
    responsibleCtrl = TextEditingController(text: story.responsible);
    dateTime = null;
    priority = story.priority;
    severity = story.severity;
    itPhase = story.itPhase;
  }

  /// Update story data and show success feedback
  void _update() {
    if (_formKey.currentState!.validate()) {
      final updated = story.copyWith(
        title: titleCtrl.text,
        responsible: responsibleCtrl.text,
        dateTime: DateTime.now(),
        priority: priority,
        severity: severity,
        itPhase: itPhase,
        imagePath: _imageFile?.path ?? story.imagePath,
      );

      showSuccessTopSnackBar(context, "Successfully Updated #${story.id}");
      ref.read(storyProvider.notifier).update(updated);
      Navigator.pop(context);
    }
  }

  /// Delete the story and show confirmation
  void _delete() {
    ref.read(storyProvider.notifier).delete(story.id);
    showDeleteTopSnackBar(context, "Successfully Deleted #${story.id}");
    Navigator.pop(context);
  }

  /// DateTime picker handler for setting completion date
  void _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay.fromDateTime(dateTime!)
          : TimeOfDay.now(),
    );
    if (t == null) return;

    setState(() {
      dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  /// Image picker to choose a file from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// 🔁 Reusable dropdown field for Priority, Severity, and I/T Phase
  Widget buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required String tagType,
    required void Function(String?) onChanged,
  }) {
    return Column(
      children: [
        const SizedBox(height: 5),
        DropdownButtonFormField2<String>(
          value: value,
          decoration: InputDecoration(labelText: label),
          isExpanded: true,
          items: options.map((val) {
            return DropdownMenuItem(
              value: val,
              child: Row(
                children: [
                  buildTag(tagType, val),
                  const SizedBox(width: 8),
                  Text(val),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) => options.map((val) {
            return Row(
              children: [
                buildTag(tagType, val),
                const SizedBox(width: 8),
                Text(val),
              ],
            );
          }).toList(),
          onChanged: onChanged,
          dropdownStyleData: const DropdownStyleData(maxHeight: 200),
        ),
      ],
    );
  }

  /// 🧱 UI layout starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Story #${story.id}")),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // 📝 Title field
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                ),

                // 👤 Responsible field
                TextFormField(
                  controller: responsibleCtrl,
                  decoration: const InputDecoration(labelText: "Responsible"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                ),

                // 📅 Completion Date Picker
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _pickDateTime,
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      dateTime == null
                          ? "Pick Completion Date"
                          : "Completion Date: ${DateFormat('MMM-dd-yyyy HH:mm').format(dateTime!.toLocal())}",
                    ),
                  ),
                ),

                // 🔽 Priority Dropdown
                buildDropdownField(
                  label: 'Priority',
                  value: priority,
                  options: ['High', 'Medium', 'Low'],
                  tagType: 'priority',
                  onChanged: (val) => setState(() => priority = val!),
                ),

                // 🔽 Severity Dropdown
                buildDropdownField(
                  label: 'Severity',
                  value: severity,
                  options: ['High', 'Medium', 'Low'],
                  tagType: 'severity',
                  onChanged: (val) => setState(() => severity = val!),
                ),

                // 🔽 I/T Phase Dropdown
                buildDropdownField(
                  label: 'I/T Phase',
                  value: itPhase,
                  options: ['Analysis', 'Design', 'I/T'],
                  tagType: 'itPhase',
                  onChanged: (val) => setState(() => itPhase = val!),
                ),

                const SizedBox(height: 10),

                // 🖼 Image Upload and Preview
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload_file, size: 32),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: Text(
                        _imageFile?.path.split('/').last ??
                            (story.imagePath.isNotEmpty
                                ? File(story.imagePath).path.split('/').last
                                : "No image selected"),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image_search, size: 32),
                      onPressed: () {
                        final fileToPreview =
                            _imageFile ??
                            (story.imagePath.isNotEmpty
                                ? File(story.imagePath)
                                : null);
                        if (fileToPreview != null) {
                          showImageViewer(
                            context,
                            FileImage(fileToPreview),
                            swipeDismissible: true,
                            doubleTapZoomable: true,
                          );
                        } else {
                          showNoImageSnackBar(context, "Upload an Image first");
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 💾 Update & 🗑 Delete buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _update,
                      icon: const Icon(Icons.save, color: Colors.green),
                      label: const Text("Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
