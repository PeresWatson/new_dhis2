String formatNumberShort(String numberStr) {
  if (numberStr.isEmpty) return '0';

  double number = double.tryParse(numberStr) ?? 0;

  if (number < 1000) {
    return number.toStringAsFixed(0); // No suffix for numbers below 1K
  } else if (number < 1000000) {
    // Thousands → K
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else if (number < 1000000000) {
    // Millions → M
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else {
    // Billions → B
    return '${(number / 1000000000).toStringAsFixed(2)}B';
  }
}