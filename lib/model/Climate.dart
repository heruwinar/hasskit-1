class Climate {
  final String entityId;
  String state;
  List<String> hvacModes;
  double minTemp;
  double maxTemp;
  double targetTempStep;
  double temperature;
  String fanMode;
  List<String> fanModes;
  int deviceCode;
  String manufacturer;

  Climate({
    this.entityId,
    this.state,
    this.hvacModes,
    this.minTemp,
    this.maxTemp,
    this.targetTempStep,
    this.temperature,
    this.fanMode,
    this.fanModes,
    this.deviceCode,
    this.manufacturer,
  });
}
