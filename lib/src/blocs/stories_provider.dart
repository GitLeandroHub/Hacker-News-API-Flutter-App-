import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

//then make a InheritedWidget called StoriesProvider that allow to reach out the context at any point inside
//build hierarchy and get an instance of out stories provider with then give acces to the underlying block
class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key key, Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()).bloc;
  }
}
