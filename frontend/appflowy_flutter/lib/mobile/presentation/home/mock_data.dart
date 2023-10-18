import 'package:flutter/material.dart';

class Document {
  Document({
    required this.title,
    required this.level,
    this.icon = Icons.description,
    this.documentList = const [],
  });
  final String title;
  final IconData icon;
  final List<Document> documentList;
  final int level;
}

final nestedDocumentList = <Document>[
  Document(
    level: 1,
    icon: Icons.folder,
    title: 'Projects',
    documentList: [
      Document(
        level: 2,
        title: 'Project A loooooooooooooooooooog title',
        documentList: [
          Document(level: 3, title: 'Design', documentList: [
            Document(
              level: 4,
              title: 'Design A',
              documentList: [
                Document(level: 5, title: 'Design A1'),
                Document(level: 5, title: 'Design A2'),
                Document(level: 5, title: 'Design A3'),
                Document(level: 5, title: 'Design A4'),
              ],
            ),
            Document(level: 4, title: 'Design B'),
            Document(level: 4, title: 'Design C'),
            Document(level: 4, title: 'Design D'),
          ]),
          Document(level: 3, title: 'Development'),
          Document(level: 3, title: 'Testing'),
          Document(level: 3, title: 'Deployment'),
        ],
      ),
      Document(
        level: 2,
        title: 'Project B',
        documentList: [
          Document(level: 3, title: 'Design'),
          Document(level: 3, title: 'Development'),
          Document(level: 3, title: 'Testing'),
          Document(level: 3, title: 'Deployment'),
        ],
      ),
      Document(
        level: 2,
        title: 'Project C',
        documentList: [
          Document(level: 3, title: 'Design'),
          Document(level: 3, title: 'Development'),
          Document(level: 3, title: 'Testing'),
          Document(level: 3, title: 'Deployment'),
        ],
      ),
    ],
  ),
  Document(
    level: 1,
    icon: Icons.folder,
    title: 'Tasks',
    documentList: [
      Document(level: 2, title: 'Task A'),
      Document(level: 2, title: 'Task B'),
      Document(level: 2, title: 'Task C'),
      Document(level: 2, title: 'Task D'),
    ],
  ),
  Document(
    level: 1,
    icon: Icons.folder,
    title: 'Notes',
    documentList: [
      Document(level: 2, title: 'Note A'),
      Document(level: 2, title: 'Note B'),
      Document(level: 2, title: 'Note C'),
      Document(level: 2, title: 'Note D'),
    ],
  ),
];
