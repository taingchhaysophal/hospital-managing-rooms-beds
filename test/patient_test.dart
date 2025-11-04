import 'package:test/test.dart';
import '../lib/domain/models/patient_status.dart';
import '../lib/domain/models/patient.dart';

void main() {
  group('Patient Class Standalone Tests', () {
    late Patient patient;
    
    setUp(() {
      patient = Patient(
        id: 'P001',
        name: 'John Doe',
        age: 45,
        gender: Gender.male,
        contactInfo: '123-456-7890',
        status: PatientStatus.red,
        medicalCondition: 'Heart Attack',
        admissionDate: DateTime(2024, 1, 15),
        preferredICUType: ICUType.private,
      );
    });

    test('should create patient with correct initial values', () {
      expect(patient.name, 'John Doe');
      expect(patient.status, PatientStatus.red);
      expect(patient.preferredICUType, ICUType.private);
      expect(patient.isDischarged, false);
      expect(patient.age, 45);
      expect(patient.gender, Gender.male);
    });

    test('should update patient status correctly', () {
      patient.updateStatus(PatientStatus.green);
      expect(patient.status, PatientStatus.green);
      expect(patient.recommendedRoomType, RoomType.general);
    });

    test('should assign patient to room', () {
      patient.assignToRoom('ER001', 'BED01');
      expect(patient.assignedRoomId, 'ER001');
      expect(patient.assignedBedId, 'BED01');
    });

    test('should discharge patient correctly', () {
      patient.discharge();
      expect(patient.isDischarged, true);
      expect(patient.assignedRoomId, isNull);
      expect(patient.assignedBedId, isNull);
    });

    test('should calculate length of stay correctly', () {
      final stayDuration = patient.lengthOfStay;
      expect(stayDuration, greaterThan(0));
    });

    test('should recommend correct room types based on status', () {
      // Test BLACK → Emergency
      patient.updateStatus(PatientStatus.black);
      expect(patient.recommendedRoomType, RoomType.emergency);
      expect(patient.recommendedRoomTypeText, 'Emergency Room');
      
      // Test YELLOW → ICU
      patient.updateStatus(PatientStatus.yellow);
      expect(patient.recommendedRoomType, RoomType.icu);
      expect(patient.recommendedRoomTypeText, 'ICU');
      
      // Test GREEN → General
      patient.updateStatus(PatientStatus.green);
      expect(patient.recommendedRoomType, RoomType.general);
      expect(patient.recommendedRoomTypeText, 'General Ward');
    });

    test('should display correct status colors', () {
      patient.updateStatus(PatientStatus.black);
      expect(patient.statusColor, '⬛ BLACK');
      
      patient.updateStatus(PatientStatus.yellow);
      expect(patient.statusColor, '🟨 YELLOW');
      
      patient.updateStatus(PatientStatus.green);
      expect(patient.statusColor, '🟩 GREEN');
    });

    test('should display correct ICU type text', () {
      expect(patient.preferredICUTypeText, 'Private ICU');
      
      final patient2 = Patient(
        id: 'P002',
        name: 'Jane Smith',
        age: 30,
        gender: Gender.female,
        contactInfo: '123-456-7891',
        status: PatientStatus.green,
        medicalCondition: 'Checkup',
        admissionDate: DateTime.now(),
        preferredICUType: ICUType.vip,
      );
      
      expect(patient2.preferredICUTypeText, 'VIP ICU');
    });

    test('should simulate admission flow without errors', () {
      expect(() {
        patient.simulateAdmissionFlow();
      }, returnsNormally);
    });

    test('should generate detailed patient information', () {
      final details = patient.getDetails();
      expect(details.contains('John Doe'), true);
      expect(details.contains('Heart Attack'), true);
      expect(details.contains('Currently Admitted'), true);
    });
  });

  group('Patient Medical Rules Validation', () {
    test('BLACK patient should go to Emergency', () {
      final criticalPatient = Patient(
        id: 'P003',
        name: 'Critical Patient',
        age: 60,
        gender: Gender.male,
        contactInfo: '123-456-7892',
        status: PatientStatus.black,
        medicalCondition: 'Major Trauma',
        admissionDate: DateTime.now(),
      );
      
      expect(criticalPatient.recommendedRoomType, RoomType.emergency);
    });

    test('GREEN patient should go to General Ward', () {
      final stablePatient = Patient(
        id: 'P004',
        name: 'Stable Patient',
        age: 25,
        gender: Gender.female,
        contactInfo: '123-456-7893',
        status: PatientStatus.green,
        medicalCondition: 'Minor Infection',
        admissionDate: DateTime.now(),
      );
      
      expect(stablePatient.recommendedRoomType, RoomType.general);
    });
  });
}