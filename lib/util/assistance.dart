// User can input custom exercise (name) with sets,reps & (optional weight)
// Needs to be mapped to a core exercise
class AssistanceLift {
  final String exerciseName;
  final int relatedCoreExerciseId;
  int sets;
  int reps;
  int weight;

  AssistanceLift(this.exerciseName, this.relatedCoreExerciseId, this.sets, this.reps, {this.weight = 0});
}

// Storage? 