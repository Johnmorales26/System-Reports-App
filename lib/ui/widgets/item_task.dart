import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:system_reports_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../homeModule/home_view_model.dart';

class ItemTask extends StatefulWidget {
  const ItemTask({super.key, required this.taskEntity});

  final TaskEntity taskEntity;

  @override
  _ItemTaskState createState() => _ItemTaskState();
}

class _ItemTaskState extends State<ItemTask> {
  late final TaskEntity taskEntity;

  @override
  void initState() {
    super.initState();
    taskEntity = widget.taskEntity;
  }

  Future<void> downloadFile(String url, HomeViewModel viewModel, String typeFile) async {
    if (kIsWeb) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        showScaffoldMessage('Could not launch $url');
      }
    } else {
      try {
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory == null) {
          return;
        }
        // Llama a viewModel.downloadFile con el directorio seleccionado
        if (await viewModel.downloadFile(context, url, selectedDirectory, typeFile)) {
          showScaffoldMessage('File downloaded successfully');
        } else {
          showScaffoldMessage('Error downloading file');
        }
      } catch (e) {
        showScaffoldMessage('Error downloading file: $e');
      }
    }
  }

  void showScaffoldMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Expanded(
        child: Column(children: [
      const Divider(),
      Row(children: [
        Expanded(child: Text(taskEntity.name)),
        Expanded(
            child: Checkbox(
                value: taskEntity.status,
                onChanged: (bool? state) {
                  setState(() {
                    taskEntity.status = state ?? false;
                  });
                  viewModel.updateTaskStatus(
                      taskEntity.id.toString(), taskEntity.status);
                })),
        const SizedBox(width: Dimens.commonPaddingMin),
        Column(children: [
          IconButton(
              onPressed: () => downloadFile(taskEntity.url, viewModel, Constants.FILE_DOCUMENT),
              icon: const Icon(Icons.download_outlined)),
          IconButton(
              onPressed: () => viewModel.deleteTask(taskEntity.id.toString()),
              icon: const Icon(Icons.delete_outline))
        ]),
        Column(children: [
          IconButton(
              onPressed: () =>  downloadFile(taskEntity.image, viewModel, Constants.FILE_IMAGE),
              icon: const Icon(Icons.image))
        ])
      ])
    ]));
  }
}
