import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/document_upload_card.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DeliveryProfileProvider>(context);
    final documents = profileProvider.documents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return DocumentUploadCard(
            document: document,
            onUpload: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                profileProvider.uploadDocument(
                  document.id,
                  File(pickedFile.path),
                );
              }
            },
            onView: () {
              if (document.fileUrl != null) {
                // Show document preview
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document preview coming soon')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
