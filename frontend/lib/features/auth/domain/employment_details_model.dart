import 'package:flutter/foundation.dart';

@immutable
class EmploymentDetails {
  final String? companyName;
  final String? jobTitle;
  final String? department;
  final String? employeeId; // Optional

  const EmploymentDetails({
    this.companyName,
    this.jobTitle,
    this.department,
    this.employeeId,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'jobTitle': jobTitle,
        'department': department,
        'employeeId': employeeId,
      };

  factory EmploymentDetails.fromJson(Map<String, dynamic> json) => EmploymentDetails(
        companyName: json['companyName'] as String?,
        jobTitle: json['jobTitle'] as String?,
        department: json['department'] as String?,
        employeeId: json['employeeId'] as String?,
      );

  @override
  String toString() {
    return 'EmploymentDetails(companyName: $companyName, jobTitle: $jobTitle, department: $department, employeeId: $employeeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmploymentDetails &&
        other.companyName == companyName &&
        other.jobTitle == jobTitle &&
        other.department == department &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode =>
      companyName.hashCode ^
      jobTitle.hashCode ^
      department.hashCode ^
      employeeId.hashCode;
}
