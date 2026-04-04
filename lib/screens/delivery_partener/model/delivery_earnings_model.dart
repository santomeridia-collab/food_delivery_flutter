class DeliveryEarnings {
  final double todayEarnings;
  final double thisWeekEarnings;
  final double thisMonthEarnings;
  final double totalEarnings;
  final int totalDeliveries;
  final double averagePerDelivery;
  final int activeHours;
  final double rating;

  DeliveryEarnings({
    required this.todayEarnings,
    required this.thisWeekEarnings,
    required this.thisMonthEarnings,
    required this.totalEarnings,
    required this.totalDeliveries,
    required this.averagePerDelivery,
    required this.activeHours,
    required this.rating,
  });
}

class Incentive {
  final String id;
  final String title;
  final String description;
  final double amount;
  final bool isCompleted;
  final int progress;
  final int target;
  final String type; // bonus, peak, referral

  Incentive({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.isCompleted,
    required this.progress,
    required this.target,
    required this.type,
  });

  double get progressPercentage => progress / target;
}

class VehicleDetails {
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleModel;
  final String vehicleColor;
  final String? insuranceExpiry;
  final String? permitNumber;
  final String? rcNumber;

  VehicleDetails({
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    this.insuranceExpiry,
    this.permitNumber,
    this.rcNumber,
  });
}

class BankAccount {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;
  final bool isVerified;

  BankAccount({
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
    this.isVerified = false,
  });
}

class Document {
  final String id;
  final String name;
  final String? fileUrl;
  final bool isUploaded;
  final bool isVerified;
  final String? expiryDate;

  Document({
    required this.id,
    required this.name,
    this.fileUrl,
    this.isUploaded = false,
    this.isVerified = false,
    this.expiryDate,
  });
}

// Add this class to the existing file
class DeliveryPartner {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final double rating;
  final int completedDeliveries;
  final String joinDate;

  DeliveryPartner({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.rating,
    required this.completedDeliveries,
    required this.joinDate,
  });
}
