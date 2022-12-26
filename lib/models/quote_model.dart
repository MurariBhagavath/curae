import 'package:flutter/material.dart';

class QuoteModel {
  final String quote;
  final String author;
  final String category;

  QuoteModel(
      {required this.author, required this.category, required this.quote});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
        author: json['author'],
        category: json['category'],
        quote: json['quote']);
  }
}
