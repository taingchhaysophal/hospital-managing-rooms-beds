enum PatientStatus {
  black,  // Critical, life-threatening → Emergency Room
  red,    // Serious, unstable → Emergency Room
  yellow, // Stable but serious → ICU Room  
  green   // Stable, recovering → General Room
}

enum Gender {
  male,
  female,
  other
}

// Simple enums to avoid dependency on Room class
enum RoomType {
  general,
  icu, 
  emergency
}

enum ICUType {
  normal,
  private,
  vip
}