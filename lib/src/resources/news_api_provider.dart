import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';
import 'dart:async';
import 'repository.dart';

//underscore _ "we don't want people to be able to export this route url into other files prefix with underscore"
final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  //return types of functions in this case:
  //A Future that resolves with the list of IDs (integers)
  Future<List<int>> fetchTopIds() async {
    //request is async option so mark await ketword "wait for the get request to complete"
    //so we can take the response that comes back and assign to a variable "response"
    final response = await client.get('$_root/topstories.json');
    //we get this response back, we have to take the response and parse it to an useful Json data
    final ids = json.decode(response.body);

    return ids.cast<int>();

    //return the list of ids we just fetched
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id.json');
    //now take that response and parse it using the Json decode function
    final parsedJson = json.decode(response.body);

    return ItemModel.fromJson(parsedJson);
  }
}
