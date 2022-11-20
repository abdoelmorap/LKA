class LanguageSelection{

  var drop;
  String val = 'en_US';

  String langName = 'English';

  LanguageSelection._privateConstructor();

  static LanguageSelection get instance => _instance;

  static final LanguageSelection _instance = LanguageSelection._privateConstructor();

  factory LanguageSelection(){
    return _instance;
  }
}