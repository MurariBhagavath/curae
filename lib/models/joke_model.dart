class JokeModel {
  final String joke;
  JokeModel({required this.joke});

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(joke: json['joke']);
  }
}
