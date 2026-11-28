import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:servixo/core/error/exceptions.dart';

class ImageUploadService {
  ImageUploadService(this._client);
  final http.Client _client;

  // flutter run --dart-define=IMGBB_API_KEY=your_new_key
  static const _apiKey = String.fromEnvironment('IMGBB_API_KEY');
  static const _url = 'https://api.imgbb.com/1/upload';

  Future<String> upload(Uint8List bytes) async {
    if (_apiKey.isEmpty) {
      throw const UploadException('Missing IMGBB_API_KEY');
    }
    try {
      final res = await _client.post(
        Uri.parse(_url),
        body: {'key': _apiKey, 'image': base64Encode(bytes)},
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode != 200) {
        throw UploadException('Upload failed (${res.statusCode})');
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (json['data'] as Map<String, dynamic>)['url'] as String;
    } on UploadException {
      rethrow;
    } catch (_) {
      throw const UploadException('Could not upload the photo. Try again.');
    }
  }
}