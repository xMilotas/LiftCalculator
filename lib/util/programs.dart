import 'package:liftcalculator/util/staticPrograms.dart';

class LiftNumber {
  double weight;
  final int weightPercentage;
  final int reps;
  final int sets;
  // Wether or not this current set is a PR set, thus more than x reps is the goal
  final bool pr;
  LiftNumber(this.weightPercentage, this.reps,
      {this.sets = 1, this.weight = 0, this.pr = false});

  @override
  String toString() {
    return "%:${this.weightPercentage}, reps: ${this.reps}, weight: ${this.weight}, sets: ${this.sets}, pr: ${this.pr}";
  }
}

class LiftProgram {
  final String name;
  final String cycleType;
  final int maxCycles;
  final LiftDay week1;
  final LiftDay week2;
  final LiftDay week3;

  LiftProgram(this.name, this.cycleType, this.maxCycles, this.week1, this.week2,
      this.week3);
}

class LiftDay {
  final List<LiftNumber> coreLifts;
  final List<LiftNumber> cycleLift;
  LiftDay({required this.coreLifts, required this.cycleLift});
}

// List of supported programs:

final boringButBig =
    LiftProgram('Boring But Big', 'Leader', 2, bbb["1"]!, bbb["2"]!, bbb["3"]!);
final firstSetLast =
    LiftProgram('First Set Last', 'Anchor', 1, fsl["1"]!, fsl["2"]!, fsl["3"]!);
