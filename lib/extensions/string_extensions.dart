extension StringExtension on String {
  String capitalizeLabelCase() {
    if (isNotEmpty) {
      final List<String> words = this.toLowerCase().split(' ');
      final StringBuffer result = new StringBuffer();

      for (int i = 0; i < words.length; i++) {
        String word = words[i];
        if (word.isNotEmpty) {
          word = '${word[0].toUpperCase()}${word.substring(1)}';
        }
        result.write('$word ');
      }

      return result.toString().trim();
    } else {
      return "";
    }
  }
}
