import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netcfluttermvvm/Models/story_model.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';
import 'package:netcfluttermvvm/views/story_detail_page.dart';

Widget buildStoryTable(BuildContext context, List<StoryModel> stories) {
  final isTablet = MediaQuery.of(context).size.width >= 600;

  return isTablet
      ? _buildTabletTable(context, stories)
      : _buildMobileCards(context, stories);
}

Widget _buildTabletTable(BuildContext context, List<StoryModel> stories) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: const [
            _HeaderCell('#'),
            _HeaderCell('Priority'),
            _HeaderCell('Severity'),
            _HeaderCell('Phase'),
            _HeaderCell('Title'),
            _HeaderCell('Responsible'),
            _HeaderCell('Modified On'),
            _HeaderCell('Project'),
          ],
        ),
        const Divider(height: 1),

        // Body Rows
        ...stories.map((s) {
          final formattedDate = DateFormat('dd MMM yyyy – HH:mm').format(s.dateTime.toLocal());

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryDetailPage(storyId: s.id),
                ),
              );
            },
            hoverColor: Colors.grey[100],
            child: Row(
              children: [
                _BodyCell(Text('${s.id}')),
                _BodyCell(buildTag('priority', s.priority)),
                _BodyCell(buildTag('severity', s.severity)),
                _BodyCell(buildTag('itPhase', s.itPhase)),
                _BodyCell(Text(s.title, style: const TextStyle(color: Colors.blue))),
                _BodyCell(Text(s.responsible)),
                _BodyCell(Text(formattedDate)),
                _BodyCell(const Chip(
                  label: Text("FORTREA"),
                  backgroundColor: Colors.purple,
                  labelStyle: TextStyle(color: Colors.white),
                )),
              ],
            ),
          );
        })
      ],
    ),
  );
}

Widget _buildMobileCards(BuildContext context, List<StoryModel> stories) {
  return ListView.builder(
    itemCount: stories.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return _MobileStoryCard(story: stories[index]);
    },
  );
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final Widget child;
  const _BodyCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _MobileStoryCard extends StatelessWidget {
  final StoryModel story;
  const _MobileStoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy – HH:mm').format(story.dateTime.toLocal());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryDetailPage(storyId: story.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${story.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Title: ${story.title}', style: const TextStyle(color: Colors.blue)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  buildTag('priority', story.priority),
                  buildTag('severity', story.severity),
                  buildTag('itPhase', story.itPhase),
                  const Chip(
                    label: Text("FORTREA"),
                    backgroundColor: Colors.purple,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Responsible: ${story.responsible}'),
              Text('Modified: $formattedDate'),
            ],
          ),
        ),
      ),
    );
  }
}
