import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import '../utils.dart';

Future<String?> uploadImage(File imageFile) async {
  try {
    var uri = Uri.parse(url + '/api/stocks');
    var request = http.MultipartRequest('POST', uri);

    String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    var multipartFile = http.MultipartFile(
      'image',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: path.basename(imageFile.path),
    );
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}
