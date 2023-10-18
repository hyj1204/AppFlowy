import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/user/application/auth/auth_service.dart';
import 'package:appflowy_backend/dispatch/dispatch.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/workspace.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-user/protobuf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'mock_data.dart';

// create a future to return the sub document list after 2 seconds
Future<List<Document>?> getSubDocumentList(Document document) async {
  await Future.delayed(const Duration(seconds: 1), () {});
  return document.documentList;
}

// TODO(yijing): This is just a placeholder for now.
class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  static const routeName = "/MobileHomeScreen";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        FolderEventGetCurrentWorkspace().send(),
        getIt<AuthService>().getUser(),
      ]),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final workspaceSetting = snapshots.data?[0].fold(
          (workspaceSettingPB) {
            return workspaceSettingPB as WorkspaceSettingPB?;
          },
          (error) => null,
        );
        final userProfile =
            snapshots.data?[1].fold((error) => null, (userProfilePB) {
          return userProfilePB as UserProfilePB?;
        });
        // TODO(yijing): implement home page later
        return Scaffold(
          key: ValueKey(userProfile?.id),
          // TODO(yijing):Need to change to workspace when it is ready
          appBar: AppBar(
            title: Text(
              userProfile?.email.toString() ?? 'No email found',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO(yijing): Navigate to setting page
                },
                icon: const FlowySvg(
                  FlowySvgs.m_setting_m,
                ),
              )
            ],
          ),
          // Here is just an example for the expanded nested list
          // body: SingleChildScrollView(
          //   child: Column(
          //     children: nestedDocumentList.map(DocumentListTile.new).toList(),
          //   ),
          // ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              return DocumentListTile(nestedDocumentList[index]);
            },
            itemCount: nestedDocumentList.length,
          ),
          // body: Center(
          //   child: Column(
          //     children: [
          //       const Text(
          //         'User',
          //       ),
          //       Text(
          //         userProfile.toString(),
          //       ),
          //       Text('Workspace name: ${workspaceSetting?.workspace.name}'),
          //       ElevatedButton(
          //         onPressed: () async {
          //           await getIt<AuthService>().signOut();
          //           runAppFlowy();
          //         },
          //         child: const Text('Logout'),
          //       )
          //     ],
          //   ),
          // ),
        );
      },
    );
  }
}

// every Header and its documents
class DocumentListTile extends StatefulWidget {
  const DocumentListTile(this.document, {super.key});
  final Document document;

  @override
  State<DocumentListTile> createState() => _DocumentListTileState();
}

class _DocumentListTileState extends State<DocumentListTile>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation;

  late final Tween<double> _sizeTween;

  bool _isExpanded = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _sizeTween = Tween(begin: 0, end: 1);
    super.initState();
  }

  void expandOnChanged() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.document.title;
    final icon = widget.document.icon;
    final level = widget.document.level;

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.6,
            dragDismissible: false,
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (context) => showSnackBar(context, 'Add a new Page'),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.add,
                label: 'Add',
              ),
              SlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (context) => showSnackBar(context, 'Favorite Page'),
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                icon: Icons.star,
                label: 'Favorite',
              ),
              // SlidableAction(
              //   padding: EdgeInsets.zero,
              //   onPressed: (context) => showSnackBar(context, 'Rename Page'),
              //   backgroundColor: Color(0xFF0392CF),
              //   foregroundColor: Colors.white,
              //   icon: Icons.edit,
              //   label: 'Rename',
              // ),
              // SlidableAction(
              //   padding: EdgeInsets.zero,
              //   onPressed: (context) => showSnackBar(context, 'Delete Page'),
              //   backgroundColor: Colors.red,
              //   foregroundColor: Colors.white,
              //   icon: Icons.delete,
              //   label: 'Delete',
              // ),
              SlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (context) => showSnackBar(context, 'Show More menu'),
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                icon: Icons.more_horiz,
                label: 'More',
              ),
            ],
          ),
          child: ListTile(
            //TODO(yijing): add maximum padding condition based on screen size
            contentPadding: EdgeInsets.only(left: 8 * level.toDouble()),
            horizontalTitleGap: 0,
            leading: _isExpanded
                ? IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: expandOnChanged,
                  )
                : IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: expandOnChanged,
                  ),
            title: Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 8,
                ),
                // Use Flexible to avoid text overflow
                Flexible(
                  child: Text(
                    title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          SubDocumentsWidget(
            document: widget.document,
            sizeTween: _sizeTween,
            animation: _animation,
          ),
      ],
    );
  }
}

class SubDocumentsWidget extends StatelessWidget {
  const SubDocumentsWidget({
    super.key,
    required this.document,
    required Tween<double> sizeTween,
    required Animation<double> animation,
  })  : _sizeTween = sizeTween,
        _animation = animation;

  final Tween<double> _sizeTween;
  final Animation<double> _animation;

  final Document document;

  @override
  Widget build(BuildContext context) {
    final level = document.level;
    return FutureBuilder(
      future: getSubDocumentList(document),
      builder: (context, snapshot) {
        // default subDocumentList is empty[]
        if (snapshot.hasData) {
          final subDocumentList = snapshot.data;

          return SizeTransition(
            sizeFactor: _sizeTween.animate(_animation),
            child: subDocumentList!.isEmpty
                ? ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 64 + 8 * level.toDouble()),
                    leading: const Text(
                      'No page inside',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Column(
                    children: [
                      ...subDocumentList.map(DocumentListTile.new),
                      Divider(
                        color: Colors.grey,
                        indent: level.toDouble() * 16,
                      ),
                    ],
                  ),
          );
        }
        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 500),
    ),
  );
}
