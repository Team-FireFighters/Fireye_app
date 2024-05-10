import 'dart:convert';

import 'package:fireye/global/constants/api_keys.dart';
import 'package:fireye/global/constants/constants.dart';
import 'package:fireye/global/constants/phone_numbers.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MessagingService{
  Future<void> sendAlertMessage(LatLng latLng, String phNo) async{
    
    String twilioURL = 'https://api.twilio.com/2010-04-01/Accounts/${APIkeys.twilioAccSID}/Messages.json';

    Map<String, String> body = {
      'From' : PhoneNumbers.twilioPhoneNumber,
      'To' : phNo,
      'Body' : "\n\nEmergency Service called @ (${latLng.latitude}°N, ${latLng.longitude}°E)\n${Constants().googleMapsSearch(latLng)}"
    };

    final response = await http.post(
      Uri.parse(twilioURL),
      body: body,
      headers : {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization' : 'Basic ' + 
          base64Encode(
            utf8.encode('${APIkeys.twilioAccSID}:${APIkeys.twilioAuthToken}')
          )
      }
    );

    if(response.statusCode == 201){
      print('Message Sent Successfully');
    } else {
      print('Failed to send message\nError: ${response.body}');
    }
    
  }
}