import 'dart:io';
import '../domain/enums/patient_status.dart';
import '../domain/entities/patient.dart';

class HospitalConsoleUI {
  List<Patient> patients = [];

  void run() {
    print('''
╔═══════════════════════════════════════╗
║        🏥 HOSPITAL ADMISSION         ║
║           MANAGEMENT SYSTEM           ║
╚═══════════════════════════════════════╝
''');

    while (true) {
      _showMainMenu();
      final choice = _getUserInput('Choose an option (1-5): ');
      
      switch (choice) {
        case '1':
          _admitNewPatient();
          break;
        case '2':
          _processEmergencyPatient();
          break;
        case '3':
          _showPatientList();
          break;
        case '4':
          _testPatientClass();
          break;
        case '5':
          print('\n👋 Thank you for using Hospital System. Goodbye!');
          return;
        default:
          print('\n❌ Invalid choice. Please try again.');
      }
    }
  }

  void _showMainMenu() {
    print('\n' + '='*50);
    print('📋 MAIN MENU');
    print('='*50);
    print('1. 🧑‍⚕️ Admit New Patient');
    print('2. 🚨 Process Emergency Patient After Treatment');
    print('3. 📊 Show Patient List');
    print('4. 🧪 Test Patient Class Features');
    print('5. ❌ Exit System');
    print('='*50);
  }

  void _admitNewPatient() {
    print('\n' + '='*50);
    print('🧑‍⚕️ NEW PATIENT ADMISSION');
    print('='*50);

    // Step 1: Patient provides basic information
    print('\n📝 PATIENT INFORMATION COLLECTION:');
    final name = _getUserInput('Enter patient name: ');

    // Step 2: Patient chooses ICU type preference
    print('\n💊 PATIENT ICU PREFERENCE:');
    print('Which type of ICU room would you prefer if needed?');
    print('1. 🛌 Private ICU (2 beds per room)');
    print('2. ⭐ VIP ICU (1 bed per room)');
    print('3. 🏥 Normal ICU (4 beds per room)');
    
    final icuChoice = _getUserInput('Choose ICU type (1-3): ');
    ICUType preferredICUType;
    
    switch (icuChoice) {
      case '1': 
        preferredICUType = ICUType.private;
        break;
      case '2': 
        preferredICUType = ICUType.vip;
        break;
      case '3': 
        preferredICUType = ICUType.normal;
        break;
      default:
        print('❌ Invalid choice. Defaulting to Normal ICU.');
        preferredICUType = ICUType.normal;
    }

    // Step 3: Nurse assesses medical status
    print('\n🎨 NURSE MEDICAL ASSESSMENT:');
    print('What is the patient\'s medical condition?');
    print('1. ⬛ BLACK - Critical, life-threatening (Emergency)');
    print('2. 🟨 YELLOW - Serious, needs immediate care (Emergency)');
    print('3. 🟩 GREEN - Stable, can wait (General Ward)');
    
    final statusChoice = _getUserInput('Enter status (1-3): ');
    PatientStatus status;
    
    switch (statusChoice) {
      case '1': status = PatientStatus.black; break;
      case '2': status = PatientStatus.yellow; break;
      case '3': status = PatientStatus.green; break;
      default:
        print('❌ Invalid choice. Defaulting to GREEN.');
        status = PatientStatus.green;
    }

    // Create patient record
    final patient = Patient(
      id: 'P${(patients.length + 1).toString().padLeft(3, '0')}',
      name: name,
      age: 35, // Default age for demo
      gender: Gender.male, // Default gender for demo
      contactInfo: 'N/A',
      status: status,
      medicalCondition: 'To be assessed',
      admissionDate: DateTime.now(),
      preferredICUType: preferredICUType,
    );

    // Display patient summary
    print('\n' + '='*50);
    print('📋 PATIENT INFORMATION SUMMARY');
    print('='*50);
    print('👤 Name: $name');
    print('🎨 Medical Status: ${patient.statusColor}');
    print('💊 Preferred ICU Type: ${patient.preferredICUTypeText}');
    print('='*50);

    // Automatic room assignment based on medical rules
    print('\n🧑‍⚕️ NURSE ROOM ASSIGNMENT:');
    
    if (status == PatientStatus.black || status == PatientStatus.yellow) {
      print('⚠️  MEDICAL RULE: ${patient.statusColor} patients must go to Emergency Room first!');
      patient.assignToRoom('ER-001', 'Bed-1');
    } else if (status == PatientStatus.green) {
      print('💚 MEDICAL RULE: GREEN patients go directly to General Ward');
      patient.assignToRoom('G-101', 'Bed-1');
    }

    patients.add(patient);
    print('\n🎉 PATIENT ADMITTED SUCCESSFULLY!');
    print('📋 Final Assignment: ${patient.name} → ${patient.assignedRoomId}');
    print('🆔 Patient ID: ${patient.id}');

    _pressEnterToContinue();
  }

  void _processEmergencyPatient() {
    if (patients.isEmpty) {
      print('\n❌ No patients in the system.');
      return;
    }

    // Find patients in emergency rooms
    final emergencyPatients = patients.where((patient) =>
        patient.assignedRoomId != null &&
        patient.assignedRoomId!.startsWith('ER') &&
        patient.status != PatientStatus.green).toList();

    if (emergencyPatients.isEmpty) {
      print('\n❌ No patients currently in Emergency needing processing.');
      return;
    }

    print('\n' + '='*50);
    print('🚨 PROCESS EMERGENCY PATIENTS AFTER TREATMENT');
    print('='*50);

    // Show patients in emergency
    print('Patients in Emergency Rooms:');
    for (int i = 0; i < emergencyPatients.length; i++) {
      final patient = emergencyPatients[i];
      print('${i + 1}. ${patient.name} - ${patient.statusColor} - Room: ${patient.assignedRoomId}');
    }

    final choice = _getUserInput('\nSelect patient to process (1-${emergencyPatients.length}): ');
    final index = int.tryParse(choice) ?? 0;

    if (index < 1 || index > emergencyPatients.length) {
      print('❌ Invalid selection.');
      return;
    }

    final patient = emergencyPatients[index - 1];
    
    print('\n' + '='*50);
    print('🩺 TREATMENT COMPLETE FOR: ${patient.name}');
    print('='*50);
    print('Current: ${patient.statusColor} in ${patient.assignedRoomId}');
    
    // Medical reassessment after treatment
    print('\n🎨 POST-TREATMENT ASSESSMENT:');
    print('What is the patient\'s new status after emergency treatment?');
    print('1. 🟨 YELLOW - Still serious, needs ICU care');
    print('2. 🟩 GREEN - Recovered, ready for General Ward');
    
    final newStatusChoice = _getUserInput('Select new status (1-2): ');
    final newStatus = newStatusChoice == '1' ? PatientStatus.yellow : PatientStatus.green;
    
    // Update patient status
    patient.updateStatus(newStatus);
    
    print('\n✅ Patient status updated: ${patient.statusColor}');

    // Assign to new room based on new status
    if (newStatus == PatientStatus.yellow) {
      print('\n💊 PATIENT NEEDS ICU CARE');
      print('💊 USING PATIENT\'S ICU PREFERENCE: ${patient.preferredICUTypeText}');
      patient.assignToRoom('ICU-${patient.preferredICUTypeText.split(' ')[0].toUpperCase()}', 'Bed-1');
    } else {
      print('\n🏥 PATIENT READY FOR GENERAL WARD');
      patient.assignToRoom('G-102', 'Bed-1');
    }

    _pressEnterToContinue();
  }

  void _showPatientList() {
    print('\n' + '='*50);
    print('📊 PATIENT LIST');
    print('='*50);
    
    if (patients.isEmpty) {
      print('No patients currently admitted.');
    } else {
      for (final patient in patients) {
        print('\n${patient.getDetails()}');
      }
    }
    
    _pressEnterToContinue();
  }

  void _testPatientClass() {
    print('\n' + '='*50);
    print('🧪 TESTING PATIENT CLASS FEATURES');
    print('='*50);

    // Test patient creation
    final testPatient = Patient(
      id: 'TEST001',
      name: 'Test Patient',
      age: 30,
      gender: Gender.female,
      contactInfo: '555-TEST',
      status: PatientStatus.black,
      medicalCondition: 'Test Condition',
      admissionDate: DateTime.now(),
      preferredICUType: ICUType.vip,
    );

    print('✅ Test Patient Created:');
    print(testPatient.getDetails());

    // Test status update
    print('\n--- Testing Status Update ---');
    testPatient.updateStatus(PatientStatus.yellow);
    print('Recommended Room: ${testPatient.recommendedRoomTypeText}');

    // Test discharge
    print('\n--- Testing Discharge ---');
    testPatient.discharge();
    print('Is discharged: ${testPatient.isDischarged}');

    _pressEnterToContinue();
  }

  String _getUserInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync()?.trim() ?? '';
  }

  void _pressEnterToContinue() {
    print('\n⏎ Press Enter to continue...');
    stdin.readLineSync();
  }
}