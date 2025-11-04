import 'dart:io';
import '../domain/models/bed.dart';
import '../domain/models/patient.dart';
import '../domain/services/hospital_system.dart';

class HospitalConsoleUI {

  void run() {
    while (true) {
      print('''
            ╔═══════════════════════════════════════╗
            ║             🏥 HOSPITAL               ║
            ║           MANAGEMENT SYSTEM           ║
            ╚═══════════════════════════════════════╝
            ''');
      print('1. Admit new patient');
      print('2. Update patient status');
      print('3. Show Rooms and Beds Availability');
      print('0. Exit system');
      print('==========================================');
      stdout.write('Choose an option (0-3): ');
      String? mainMenuOption = stdin.readLineSync();

      switch (mainMenuOption) {
        case '1':
          print('This is admin new patient panel');
          break;
        case '2':
          print('This is update pateint status panel');
          break;
        case '3':
          print('This is Show Rooms and Beds Availability panel');
          break;
        case '0':
          print('Existing system ...');
          exit(0);
        default:
          print('Please choose an option between 0 - 3.');
      }
    }
  }
}
