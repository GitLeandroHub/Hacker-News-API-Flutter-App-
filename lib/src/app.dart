import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return CommentsProvider(
      //when the app starts, create a new instance of StoriesProvider with in turn will create a new instance of StoriesBLoc
      //and make it avaliable to every widget inside the application
      child: StoriesProvider(
        //navigator object
        child: MaterialApp(
          title: 'News!',
          //first screen with a widget called NewsList
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    //for many cases use switch and case to route. The id is nested inside of settings on that name property
    if (settings.name == '/') {
      //return a build MaterialPageRoute
      return MaterialPageRoute(
        //named propertie called builder with a fuction that takes context
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);

          storiesBloc.fetchTopIds();

          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(builder: (context) {
        final commentsBloc = CommentsProvider.of(context);
        //extract the item id from settings.name and pass into NewsDetail. A fantastic location to do some initialization
        //or data fetching for NewsDetail
        final itemId = int.parse(settings.name.replaceFirst('/', ''));

        commentsBloc.fetchItemWithComments(itemId);

        return NewsDetail(
          itemId: itemId,
        );
      });
    }
  }
}
