

abstract class Util {
  static String removeFirstZero(String phone) {
    var temp = phone.split('')[0];
    print('firstData $temp');
    if (temp == '0') {
      print('firstData1 ${ phone.substring(0)}');
      return phone.substring(1);
    } else {
      print('firstData2 $phone');
      return phone;
    }
  }
}