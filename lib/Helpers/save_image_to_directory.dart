import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Helpers/permission_request_handler.dart';

saveFile(File? xFile, BuildContext context, String name) async {
  Directory? directory;
  try {
    if (Platform.isAndroid) {
      if (await requestPermission(Permission.storage) &&
          await requestPermission(Permission.manageExternalStorage) &&
          await requestPermission(Permission.accessMediaLocation)) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> folders = directory!.path.split('/');
        for (int i = 1; i < folders.length; i++) {
          String? folder = folders[i];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + '/EdgeBandInventory';
        directory = Directory(newPath);
      } else {
        return false;
      }
    }
    if (!await directory!.exists()) {
      await directory.create(recursive: true);
    }

    if (await directory.exists()) {
      String path = directory.path + "/${name}.xlsx";
      await xFile!.copy(path);
      return path;
    }
    showSnakeBar(context, "File Saved Successfully");
  } catch (e) {
    print(e);
    showSnakeBar(context, "Permission Not Allowed, File Not Saved");
  }
}
