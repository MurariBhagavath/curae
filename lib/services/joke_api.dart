import 'dart:convert';
import 'package:curae/models/joke_model.dart';
import 'package:http/http.dart' as http;

const String api_key = 'tdn90dm5lhd+6c7bG3RDtQ==BRR4wWA7UYvahclT';

Future<JokeModel> getJokeFromAPI() async {
  var client = http.Client();
  var response = await client.get(
      Uri.parse('https://api.api-ninjas.com/v1/jokes?limit=1'),
      headers: {'X-Api-Key': api_key});
  if (response.statusCode == 200) {
    print(response.body);
    var json = jsonDecode(response.body);
    var joke = JokeModel.fromJson(json[0]);
    return joke;
  } else {
    return JokeModel.fromJson({
      "joke": "What did the floor say to the desk? I can see your drawers!",
    });
  }
}
