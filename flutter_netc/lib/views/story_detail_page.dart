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

// StoryDetailPage allows the user to view, edit, or delete a specific story
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

    // Retrieve the story from the provider using its ID
    final data = ref.read(storyProvider.notifier).getById(widget.storyId);
    story = data!;

    // Initialize text controllers with existing story values
    titleCtrl = TextEditingController(text: story.title);
    responsibleCtrl = TextEditingController(text: story.responsible);
    dateTime = null;

    // Initialize dropdowns with existing values
    priority = story.priority;
    severity = story.severity;
    itPhase = story.itPhase;
  }

  // Updates the story using the current values from the form
  void _update() {
    // Added Validator if statement to check if all fields have values
    if (_formKey.currentState!.validate()) {
      final updated = story.copyWith(
        title: titleCtrl.text,
        responsible: responsibleCtrl.text,
        dateTime: DateTime.now(), // ✅ Update to current time
        priority: priority,
        severity: severity,
        itPhase: itPhase,
        imagePath: _imageFile?.path ?? story.imagePath,
      );
      // Snackbar to show updated
      showSuccessTopSnackBar(context, "Successfully Updated #${story.id}");
      ref.read(storyProvider.notifier).update(updated);
      Navigator.pop(context);
    }
  }

  // Deletes the story
  void _delete() {
    ref.read(storyProvider.notifier).delete(story.id);
    //snackbar to show deleted
    showDeleteTopSnackBar(context, "Successfully Deleted #${story.id}");
    Navigator.pop(context); // Close the page
  }

  // Opens date & time pickers to select a new datetime
  void _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;

    final t = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay.fromDateTime(dateTime!)
          : TimeOfDay.now(),
    );
    if (t == null) return;

    // Update local state with new datetime
    setState(() {
      dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with story ID
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
                // Text field to edit the story title
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                ),

                // Text field to edit the responsible person
                TextFormField(
                  controller: responsibleCtrl,
                  decoration: const InputDecoration(labelText: "Responsible"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Required" : null,
                ),

                // Date/time picker button
                Container(
                  width: double.infinity, // Takes full width of the parent
                  alignment: Alignment.centerLeft, // Align content to the left
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
                // --- Story Image Picker below I/T Phase ---
                const SizedBox(height: 10),

                // Row with upload icon, file name, and preview icon
                Row(
                  children: [
                    // Upload icon
                    IconButton(
                      icon: const Icon(Icons.upload_file, size: 32),
                      onPressed: _pickImage,
                    ),

                    // Show file name if image is picked
                    if (_imageFile != null)
                      Expanded(
                        child: Text(
                          _imageFile!.path.split('/').last, // Just the filename
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else if (story.imagePath.isNotEmpty)
                      Expanded(
                        child: Text(
                          File(story.imagePath).path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      const Expanded(child: Text("No image selected")),

                    // Preview icon
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
                // Action buttons row: Update and Delete
                Row(
                  children: [
                    // Update button
                    ElevatedButton.icon(
                      onPressed: _update,
                      icon: const Icon(
                        Icons.save,
                        color: Colors.green,
                      ), // 🔴 Icon only
                      label: const Text("Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // Optional: to match the "Update" style
                        foregroundColor: Colors
                            .black, // Optional: controls text/icon color unless overridden
                        side: const BorderSide(
                          color: Colors.green,
                        ), // Optional: add border if you want emphasis
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0, // Optional: flat style
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Delete button
                    ElevatedButton.icon(
                      onPressed: _delete,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ), // 🔴 Icon only
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // Optional: to match the "Update" style
                        foregroundColor: Colors
                            .black, // Optional: controls text/icon color unless overridden
                        side: const BorderSide(
                          color: Colors.red,
                        ), // Optional: add border if you want emphasis
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0, // Optional: flat style
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
