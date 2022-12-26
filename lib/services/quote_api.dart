import 'dart:convert';

import 'package:curae/models/quote_model.dart';
import 'package:http/http.dart' as http;

final String api_key = 'tdn90dm5lhd+6c7bG3RDtQ==BRR4wWA7UYvahclT';

Future<QuoteModel> getQuote() async {
  var client = http.Client();
  var response = await client.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=happiness'),
      headers: {'X-Api-Key': api_key});
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    var quote = QuoteModel.fromJson(json[0]);
    return quote;
  } else {
    return QuoteModel.fromJson({
      "quote": "The will of man is his happiness.",
      "author": "Friedrich Schiller",
      "category": "happiness"
    });
  }
}
