
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
  String lastOnOperation;
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

  factory Climate.fromJson(Map<String, dynamic> json) {
//    print('Climate.fromJson ${json}');
    List<String> hvacModes = [];
    for (String hvac_mode in json['attributes']['hvac_modes']) {
      hvacModes.add(hvac_mode);
    }
    List<String> fanModes = [];
    for (String fan_mode in json['attributes']['fan_modes']) {
      fanModes.add(fan_mode);
    }

    return Climate(
      entityId: json['entity_id'],
      state: json['state'],
      hvacModes: hvacModes,
      minTemp: double.parse(json['attributes']['min_temp'].toString()),
      maxTemp: double.parse(json['attributes']['max_temp'].toString()),
      targetTempStep:
          double.parse(json['attributes']['target_temp_step'].toString()),
      temperature: double.parse(json['attributes']['temperature'].toString()),
      fanMode: json['attributes']['fan_mode'],
      fanModes: fanModes,
      deviceCode: json['attributes']['device_code'],
      manufacturer: json['attributes']['manufacturer'],
    );
  }
}
