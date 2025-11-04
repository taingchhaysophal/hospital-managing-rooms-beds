import 'patient_status.dart';
import 'room_type.dart';

class Patient {
  // Basic Information
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String contactInfo;
  
  // Medical Information
  PatientStatus status;
  String medicalCondition;
  DateTime admissionDate;
  DateTime? dischargeDate;
  
  // Room Assignment (using simple strings instead of Room objects)
  String? assignedRoomId;
  String? assignedBedId;
  RoomType preferredRoomType;
  
  // ICU Preference
  ICUType? preferredICUType;
  
  // Constructor
  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contactInfo,
    required this.status,
    required this.medicalCondition,
    required this.admissionDate,
    this.assignedRoomId,
    this.assignedBedId,
    this.preferredRoomType = RoomType.general,
    this.preferredICUType,
  });

  // Business Methods
  void updateStatus(PatientStatus newStatus) {
    status = newStatus;
    print('✅ Patient status updated to: $statusColor');
  }
  
  void assignToRoom(String roomId, String bedId) {
    assignedRoomId = roomId;
    assignedBedId = bedId;
    print('✅ Patient assigned to Room: $roomId, Bed: $bedId');
  }
  
  void discharge() {
    dischargeDate = DateTime.now();
    assignedRoomId = null;
    assignedBedId = null;
    print('✅ Patient discharged on: $dischargeDate');
  }
  
  bool get isDischarged => dischargeDate != null;
  
  int get lengthOfStay {
    final endDate = dischargeDate ?? DateTime.now();
    return endDate.difference(admissionDate).inDays;
  }

  // Room recommendation based on medical status
  RoomType get recommendedRoomType {
    switch (status) {
      case PatientStatus.black:
      case PatientStatus.red:
        return RoomType.emergency;
      case PatientStatus.yellow:
        return RoomType.icu;
      case PatientStatus.green:
        return RoomType.general;
    }
  }

  // Display methods
  String get statusColor {
    switch (status) {
      case PatientStatus.black: return '⬛ BLACK';
      case PatientStatus.red: return '🟥 RED';
      case PatientStatus.yellow: return '🟨 YELLOW';
      case PatientStatus.green: return '🟩 GREEN';
    }
  }

  String get recommendedRoomTypeText {
    switch (recommendedRoomType) {
      case RoomType.emergency: return 'Emergency Room';
      case RoomType.icu: return 'ICU';
      case RoomType.general: return 'General Ward';
    }
  }

  String get preferredICUTypeText {
    if (preferredICUType == null) return 'Not specified';
    switch (preferredICUType!) {
      case ICUType.normal: return 'Normal ICU';
      case ICUType.private: return 'Private ICU';
      case ICUType.vip: return 'VIP ICU';
    }
  }

  @override
  String toString() {
    return 'Patient: $name (ID: $id) | Status: $statusColor | Room: ${assignedRoomId ?? "Not assigned"}';
  }
  
  String getDetails() {
    return '''
Patient Details:
---------------
ID: $id
Name: $name
Age: $age
Gender: $gender
Status: $statusColor
Condition: $medicalCondition
Admission Date: ${admissionDate.toString().split(' ')[0]}
Length of Stay: $lengthOfStay days
Assigned Room: ${assignedRoomId ?? "None"}
Recommended Room: $recommendedRoomTypeText
Preferred ICU Type: $preferredICUTypeText
${isDischarged ? 'DISCHARGED on ${dischargeDate.toString().split(' ')[0]}' : 'Currently Admitted'}
''';
  }

  // Method to simulate the UI admission flow
  void simulateAdmissionFlow() {
    print('\n🧪 SIMULATING PATIENT ADMISSION FLOW:');
    print('📋 PATIENT INFORMATION SUMMARY');
    print('👤 Name: $name');
    print('🎨 Medical Status: $statusColor');
    print('💊 Preferred ICU Type: $preferredICUTypeText');
    print('💡 Recommended Room: $recommendedRoomTypeText');
    
    // Simulate room assignment based on medical rules
    if (status == PatientStatus.black || status == PatientStatus.red || status == PatientStatus.yellow) {
      print('⚠️  MEDICAL RULE: $statusColor patients must go to Emergency Room first!');
      assignToRoom('ER-001', 'Bed-1');
    } else if (status == PatientStatus.green) {
      print('💚 MEDICAL RULE: GREEN patients go directly to General Ward');
      assignToRoom('G-101', 'Bed-1');
    }
    
    print('🎉 PATIENT ADMITTED SUCCESSFULLY!');
  }
}