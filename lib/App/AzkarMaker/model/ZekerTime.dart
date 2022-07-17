
class ZekerTime
{
  ZekerTime();

  int hours = 0;
  int minutes = 0;

  factory  ZekerTime.fromJson(Map<String, dynamic> map) {
    var cls = ZekerTime();
    cls.hours = map["hours"]   ?? 0;
    cls.minutes = map["minutes"]   ?? 0;

    return cls;
  }

  Map<String, dynamic> toJson() => {
    'hours': hours,
    'minutes': minutes
  };


}