

extension ParseNumbers on double {
  String removeDecimalZeroFormat() {
    return this.toStringAsFixed(this.truncateToDouble() == this ? 0 : 1);
  }
}