import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final Widget? icon;
  final String? title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.icon,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List<CloudStorageInfo> demoMyFiles = [
  CloudStorageInfo(
    title: "Gastado:",
    numOfFiles: 1328,
    icon: const Icon(Icons.credit_card, color: Colors.blue),
    totalStorage: "\$1.9",
    color: primaryColor,
    percentage: 50,
  ),
  CloudStorageInfo(
    title: "Ingresado",
    numOfFiles: 1328,
    icon: const Icon(Icons.account_balance, color: Color(0xFFFFA113)),
    totalStorage: "\$2.9",
    color: const Color(0xFFFFA113),
    percentage: 35,
  ),
/*   CloudStorageInfo(
    title: "One Drive",
    numOfFiles: 1328,
    svgSrc: "assets/icons/one_drive.svg",
    totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "Documents",
    numOfFiles: 5328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
  ), */
];
