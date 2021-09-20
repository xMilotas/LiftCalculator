class Lift {
  final int id;
  final String title;
  final String abbreviation;

  Lift(this.id, this.title, this.abbreviation);
}

final List<Lift> GLOBAL_ALL_LIFTS = 
    [
    Lift(0, "Overhead Press", "OHP"),
    Lift(1, "Deadlift", "DL"),
    Lift(2, "Bench Press", "BP"),
    Lift(3, "Squat", "SQ")
    ];