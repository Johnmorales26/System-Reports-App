import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/reportModule/widgets/data_travel_widget.dart';
import 'package:system_reports_app/ui/reportModule/widgets/general_data_widget.dart';
import 'package:system_reports_app/ui/reportModule/widgets/record_times_widget.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:toastification/toastification.dart';
import '../appModule/assets.dart';
import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import 'package:image/image.dart' as img;

class ReportScreen extends StatelessWidget {
  static const String route = '/ReportScreen';
  final DataEntry dataEntry;

  const ReportScreen({super.key, required this.dataEntry});

  Future<File> _getSignatureFile(ReportViewModel viewModel) async {
    final imageBytes = await viewModel.signatureController.toPngBytes();
    if (imageBytes != null) {
      final image = img.decodeImage(imageBytes)!;
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/signature.png');
      await file.writeAsBytes(img.encodePng(image));
      return file;
    }
    throw Exception('Failed to convert signature to image file');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReportViewModel>(context);
    viewModel.initData(dataEntry);
    final screenWidth = MediaQuery.of(context).size.width;
    Widget view = Container();
    if (screenWidth >= 600) {
      view = Center(
          child: Row(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.commonPaddingDefault),
                child: SingleChildScrollView(child: _Form())),
          ),
          Expanded(
            child: Lottie.asset(Assets.documentAnim),
          ),
        ],
      ));
    } else {
      view = Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.commonPaddingDefault),
          child: SingleChildScrollView(child: _Form()));
    }

    Widget button = Container();
    if (viewModel.validateControllers()) {
      button = FloatingActionButton(
          onPressed: () async {
            if (kIsWeb) {
              toastification.show(
                  context: context,
                  title:
                      const Text('Esta opción no está disponible en la web.'),
                  autoCloseDuration: const Duration(seconds: 5),
                  type: ToastificationType.info);
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.route, (Route<dynamic> route) => false);
            } else {
              final signature = await _getSignatureFile(viewModel);
              var response = await viewModel.generatePDF(signature);
              if (response) {
                viewModel.clearControllers();
                viewModel.deletePendingTask(dataEntry);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (route) => false);
              } else {
                toastification.show(
                    context: context,
                    title: const Text('Error al subir el archivo'),
                    autoCloseDuration: const Duration(seconds: 5),
                    type: ToastificationType.error);
              }
            }
          },
          child: const Icon(Icons.file_open));
    } else {
      button = Container();
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Report'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (Route<dynamic> route) => false),
                icon: const Icon(Icons.arrow_back))),
        body: view,
        floatingActionButton: button);
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportViewModel>(context);

    Widget isSelectedImage = Container();
    if (provider.urlController.text.isEmpty) {
      isSelectedImage = FloatingActionButton.extended(
          onPressed: () async {
            var result = await getImageFromGallery(context, provider);
            provider.updateSelectedImage(result);
          },
          label: const Text('Subir Imagen'),
          icon: const Icon(Icons.add_a_photo_outlined));
    } else {
      _ImagePreview(picture: provider.urlController.text);
    }

    return Column(children: [
      GeneralDataWidget(provider: provider),
      const SizedBox(height: Dimens.commonPaddingMin),
      DataTravelWidget(provider: provider),
      const SizedBox(height: Dimens.commonPaddingMin),
      RecordTimesWidget(provider: provider),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.urlController,
          decoration: const InputDecoration(
            labelText: 'Url Image',
            enabled: false,
            prefixIcon: Icon(Icons.file_copy_outlined),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      Signature(
        controller: provider.signatureController,
        height: 150,
      ),
      const SizedBox(height: Dimens.commonPaddingMin),
      isSelectedImage
    ]);
  }
}

class _ImagePreview extends StatelessWidget {
  final String picture;

  const _ImagePreview({required this.picture});

  @override
  Widget build(BuildContext context) {
    return Image.network(picture, width: 100, height: 200);
  }
}
