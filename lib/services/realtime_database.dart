import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yoga_app/services/auth_gate.dart';
String? id;
class Database {
  User? user = getUser();
  String uid = getUID();

  Future<void> writeData(FirebaseDatabase database, String parent, String child, Map<String, Object?> data, bool setData, bool pushData) async {
    DatabaseReference ref = database.ref();
    if(pushData) {
      ref = database.ref(parent).push();
      id = ref.key;
    }
    else {
      ref = database.ref(child);
      id = '';
    }
    if(setData == true) {
      await ref.set(data);
    }
    else {
      await ref.update(data);
    }
  }

  Future<void> readData(String course) async {
    DatabaseReference readRef = FirebaseDatabase.instance.ref(course);
    readRef.onValue.listen((DatabaseEvent event) {
    });
  }
}

class IdentifyCourse {
  String? courseName;
  IdentifyCourse({required this.courseName});
}