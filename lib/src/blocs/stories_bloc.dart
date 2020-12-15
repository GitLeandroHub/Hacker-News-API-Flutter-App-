//Data Loading Process. Stories Bloc got access to a copy of a repository and that repository mediated access to two
//different information providers (api and db provider) on resources folder.
//Inside repository there is a list of different sources and caches that repository could use. These sources and caches
//were defined using abstract classes(in the end of the repository.dart there is these ideas of implementation) and
//were implemented by the api_provider and the db_provider as well. These abstract classes only define the requirements
//for the names of methods, the arguments and the return values, like a record keeping;
//Inside the repository the most important method is fetchItem. Whenever "someone" call fetchItem it looks through all
//the different sources in a particular order (for loop) and waited for one to retreive the item that is looking for;
//once when it finds the item then look through all the different caches and back the item up in those caches (second for)
//and finally return the item.
//So these takes to stories_bloc that expose the repository through the use of topIds, itemsOutput and itemsFetcher streams
//the itemOutput and itemFetcher stream controllers specifically to solve multi subscription issue that ran into;
//_itemsTransformer was being called far more often that is should have been call and all because everytime we get a stream
//builder that listened to our at the time items stream every single stream builder created a new separated ScanStreamTransformer
//and so for every single stream builder that we had was generating a repetitive incredible number of calls to fetch the same
//item over and over again. And this was solved by sending up two separated stream controllers inside stories_bloc: the
//_itemsOutput and the _itemsFetcher. Fetcher is a sort of a single subscription stream, behind the scenes it is a broadcast
//stream, but "pretend" that this is single subscription. So the only thing that listened to itemsFetcher was itemsOutput
//and for that reason the transformer was only applied to incoming values exactly one time and allowed to sidestep the issue
//around the use of all of the stream builders.

//From there eventually got some information into news_list ********************************

//Inside app.dart there is a navigation setup with the onGenerateRoute callback with the routes method, so every possible
//route that could visit return a MaterialPageRoute and inside this a build method *that can replace news_list bad call*
//because you don't want on your own application any data loading from that build method of an individual screen
//So a good example of doing that data loading was for the News_Detail that got access to commentsBloc pull down some
//information from the path navigation through and do some initial loading with fetchItemWithComments
//and from there finally went into individual screens of NewsDetail and NewsList and started up the actual rendering process

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  //setup publishSubject to call as a stream controller
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  // Getters to streams that give acces to the stream (topIds) and that stream controller (_topIds.stream)
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sinks with return typf of int
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      //index variable is the number of time that ScanStreamTransformer has been invoked, replace to _
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print(index);
        //cache at id stablising a new key inside Map and assign it a future that resolves with ItemModel
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      //second argument is an empty map, with keys to this map: int and and the values Futures that resolves ItemModels
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
