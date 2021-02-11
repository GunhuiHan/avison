
import 'package:avisonhouse/models/program.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt tabIndex = 0.obs;
  var programList = List<Program>().obs;
  RxMap newProgram = Program().initProgram.toJson().obs;
  RxBool isRa = false.obs;


  updateIndex(int index) {
    this.tabIndex.value = index;
    print(this.tabIndex);
  }

  getProgramList(programs) {
    this.programList.assignAll(programs);
  }

  updateNewProgram(type, body) {
    this.newProgram.update(type, (value) => body);
    print(newProgram);
  }

  deleteProgram(Program program) {
    this.programList.assignAll(this.programList..where((program) => program != program));
  }

  initEditProgram(Program program) {
    this.newProgram(program.toJson());
  }

  resetProgram() {
    this.newProgram(Program().initProgram.toJson());
  }

  joinRa(bool isRa) => this.isRa.value = isRa;
}
