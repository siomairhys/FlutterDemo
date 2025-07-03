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

  // Changed to handle multiple images
  List<File> _imageFiles = [];

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

    // Added to ensure _imageFiles has the same image from story_model
    _imageFiles = story.imagePaths.map((path) => File(path)).toList();
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
        imagePaths: _imageFiles.map((file) => file.path).toList(),
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
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  // Added Delete Image function for X icon
  void _deleteImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  // Added PreviewImage function for eye icon
  void _previewImage(File file) {
    showImageViewer(
      context,
      FileImage(file),
      swipeDismissible: true,
      doubleTapZoomable: true,
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

                const SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  isExpanded: true, // Ensures dropdown takes full width
                  items: ['High', 'Medium', 'Low']
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('priority', val), // Colored tag
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selectedItemBuilder: (context) => ['High', 'Medium', 'Low']
                      .map(
                        (val) => Row(
                          children: [
                            buildTag(
                              'priority',
                              val,
                            ), // Colored tag in the field
                            const SizedBox(width: 8),
                            Text(val),
                          ],
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => priority = val!),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200, // Limit dropdown height
                    // You can further customize here
                  ),
                ),

                const SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  value: severity,
                  decoration: const InputDecoration(labelText: 'Severity'),
                  isExpanded: true, // Ensures dropdown takes full width
                  items: ['High', 'Medium', 'Low']
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('severity', val), // Colored tag
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selectedItemBuilder: (context) => ['High', 'Medium', 'Low']
                      .map(
                        (val) => Row(
                          children: [
                            buildTag(
                              'severity',
                              val,
                            ), // Colored tag in the field
                            const SizedBox(width: 8),
                            Text(val),
                          ],
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => severity = val!),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200, // Limit dropdown height
                    // You can further customize here
                  ),
                ),

                const SizedBox(height: 5),
                DropdownButtonFormField2<String>(
                  value: itPhase,
                  decoration: const InputDecoration(labelText: 'I/T Phase'),
                  isExpanded: true, // Ensures dropdown takes full width
                  items: ['Analysis', 'Design', 'I/T']
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Row(
                            children: [
                              buildTag('itPhase', val), // Colored tag
                              const SizedBox(width: 8),
                              Text(val),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selectedItemBuilder: (context) =>
                      ['Analysis', 'Design', 'I/T']
                          .map(
                            (val) => Row(
                              children: [
                                buildTag(
                                  'itPhase',
                                  val,
                                ), // Colored tag in the field
                                const SizedBox(width: 8),
                                Text(val),
                              ],
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => itPhase = val!),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200, // Limit dropdown height
                    // You can further customize here
                  ),
                ),

                const SizedBox(height: 10),

                // Wrapped image preview portion in Column so it can be displayed as a list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.upload_file, size: 32),
                          onPressed: _pickImage,
                        ),
                        const Text("Upload Images"),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (_imageFiles.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          SizedBox(
                            height: _imageFiles.length > 5 ? 200 : null,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: _imageFiles.length > 5
                                  ? const ScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              itemCount: _imageFiles.length,
                              itemBuilder: (context, index) {
                                final file = _imageFiles[index];
                                final filename = file.path.split('/').last;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          filename,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _previewImage(file),
                                            icon: const Icon(
                                              Icons.remove_red_eye,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _deleteImage(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
