import 'enum.dart';
import 'patient.dart';

class Bed {
  final String bedId;
  BedStatus status;
  Patient? patient; 

  Bed(this.bedId, {this.status = BedStatus.available});

  void assignPatient(Patient newPatient) {
    patient = newPatient;
    status = BedStatus.busy;
    print(' Assigned ${newPatient.name} to bed $bedId');
  }

  void releaseBed() {
    print('🛏️ Bed $bedId released from ${patient?.name}');
    patient = null;
    status = BedStatus.available;
  }
}
