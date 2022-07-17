import 'package:intl/intl.dart';

enum AlertAction {
  cancel,
  discard,
  disagree,
  agree,
}

const bool devMode = false;
const double textScaleFactor = 1.0;

const Map<String, String> req_headers = {
  "enc": "a1",
  "key": "a2",
  "Content-Type": "application/json",
  "Token" : "qndWY7mBcSs2buPVrlLHxUg9RhAKI38XoZDOyjTFzav6pf5wGEi1tJQCNMk4"

};

const String apiURL = "https://fudc.4topapps.com";
const String apiURL_helpDesk = "https://support.fudc.4topapps.com/api";

  const  timeFormat = "hh:mm a";
  const  dateTimeFormat = "yyyy-MM-dd hh:mm a";
  const  dateFormat = "yyyy-MM-dd";


  String getDateNow()
{
  DateTime now = DateTime.now();
  return DateFormat(dateFormat).format(now);
}


String eventName(String name,{String prefix = ""})
{
   String st  = name ;

   st = st.replaceAll("#", "");
   st = st.replaceAll(" ", "_");
   st = st.replaceAll(".", "_");

   st = st.toLowerCase();

   st = "fudc_" + prefix + st ;

   print ("eventName:" + st) ;

   return st;
}