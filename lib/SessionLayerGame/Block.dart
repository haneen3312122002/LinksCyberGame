class Block {
  final String text;

  Block({required this.text});

  // Override equals and hashcode if necessary
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Block && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;
}
