class CBTQuestion {
  final String id;
  final String question;
  final List<String> options;
  final bool isMultiSelect;

  CBTQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.isMultiSelect = false,
  });
} 