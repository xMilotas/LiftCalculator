class Training {
  final int id;   // ID is the Date of the lift as some sort of integer i.e. timeinms or smth()
  final String lift; // lift name

  Training({
    required this.id,
    required this.lift,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lift': lift,
    };
  }

  @override
  String toString() {
    return 'Training{id: $id, lift: $lift';
  }
}
