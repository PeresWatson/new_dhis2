int? findMaxValue(List numbers) {
  if (numbers.isEmpty) {
    return null; // or throw Exception, or return 0 — depending on your need
  }
  
  int max = numbers[0];
  
  for (int num in numbers) {
    if (num > max) {
      max = num;
    }
  }
  
  return max;
}