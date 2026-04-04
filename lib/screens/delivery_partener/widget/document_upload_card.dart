import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_earnings_model.dart';

class DocumentUploadCard extends StatelessWidget {
  final Document document;
  final VoidCallback onUpload;
  final VoidCallback onView;

  const DocumentUploadCard({
    super.key,
    required this.document,
    required this.onUpload,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color:
                  document.isVerified
                      ? Colors.green.withOpacity(0.1)
                      : document.isUploaded
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              document.isVerified
                  ? Icons.verified
                  : document.isUploaded
                  ? Icons.cloud_done
                  : Icons.cloud_upload,
              color:
                  document.isVerified
                      ? Colors.green
                      : document.isUploaded
                      ? Colors.orange
                      : Colors.grey,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  document.isVerified
                      ? 'Verified'
                      : document.isUploaded
                      ? 'Pending Verification'
                      : 'Not uploaded',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        document.isVerified
                            ? Colors.green
                            : document.isUploaded
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
                if (document.expiryDate != null)
                  Text(
                    'Expires: ${document.expiryDate}',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (document.isUploaded)
            IconButton(icon: const Icon(Icons.visibility), onPressed: onView),
          IconButton(
            icon: Icon(
              document.isUploaded ? Icons.refresh : Icons.cloud_upload,
              color: AppTheme.primaryColor,
            ),
            onPressed: onUpload,
          ),
        ],
      ),
    );
  }
}
