class WeightReps{
  double weight = 0;
  int reps = 0;

  WeightReps(double weight, int reps){
    this.weight = _roundWeight(weight);
    this.reps = reps;
  }

  @override
  String toString() {
    return '${this.weight} kg x ${this.reps}'; 
  }

  /// Rounds a weight to the nearest 0.5/1kg
  double _roundWeight(double weight){
    return (weight*2).round()/2;
  }
}