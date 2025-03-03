import 'package:finia_app/models/my_files.dart';
import 'package:finia_app/responsive.dart';

import 'package:flutter/material.dart';
import 'file_info_card.dart';

class InfoCardsAmounts extends StatelessWidget {
  final List<CloudStorageInfo> fileInfo;

  const InfoCardsAmounts({
    super.key,
    required this.fileInfo,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Responsive(
      mobile: FileInfoCardGridView(
        files: fileInfo,
        crossAxisCount: size.width < 600 ? 2 : 4,
        childAspectRatio: size.width < 650 && size.width > 350 ? 1.3 : 1,
      ),
      tablet: FileInfoCardGridView(
        files: fileInfo,
        crossAxisCount: 3, // Default to 3 columns on tablets
      ),
      desktop: FileInfoCardGridView(
        files: fileInfo,
        crossAxisCount: 4, // Default to 4 columns on desktop
        childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
      ),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  final List<CloudStorageInfo> files;
  final int crossAxisCount;
  final double childAspectRatio;

  const FileInfoCardGridView({
    super.key,
    required this.files,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: files.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(left: 5, right: 16),
          child: FileInfoCard(info: files[index])),
    );
  }
}
