import 'package:flutter/material.dart';
import 'comments_bloc.dart';
//export the comments_bloc as well so any oher file inside the application that imports the comments_provider file
//will automatically know about the comments_bloc as well
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({Key key, Widget child})
      //initialize the bloc
      : bloc = CommentsBloc(),
        //super constructor
        super(key: key, child: child);

  //method required from inheritedWidget
  bool updateShouldNotify(_) => true;

  static CommentsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CommentsProvider>())
        .bloc;
  }
}
