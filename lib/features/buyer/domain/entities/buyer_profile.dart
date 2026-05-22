class BuyerProfile {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String role;
  final bool isVerified;
  final String? faydaId;
  final String? faydaImageUrl;
  final String? faydaStatus; // PENDING, VERIFIED, REJECTED
  
  // Buyer-specific attributes
  final double? budget;
  final String? preferredPropertyType;
  final List<String>? preferredLocations;

  BuyerProfile({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    required this.role,
    required this.isVerified,
    this.faydaId,
    this.faydaImageUrl,
    this.faydaStatus,
    this.budget,
    this.preferredPropertyType,
    this.preferredLocations,
  });

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    // Safely extract buyer sub-object if available
    final buyerData = json['buyer'] as Map<String, dynamic>?;

    return BuyerProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      faydaId: json['faydaId'] as String?,
      faydaImageUrl: json['faydaImageUrl'] as String?,
      faydaStatus: json['faydaStatus'] as String?,
      budget: buyerData != null && buyerData['budget'] != null 
          ? (buyerData['budget'] as num).toDouble() 
          : null,
      preferredPropertyType: buyerData?['preferredPropertyType'] as String?,
      preferredLocations: buyerData?['preferredLocations'] != null 
          ? List<String>.from(buyerData!['preferredLocations']) 
          : null,
    );
  }
}
