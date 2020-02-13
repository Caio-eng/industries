import 'package:bloc/bloc.dart';
import 'package:industries/pages/homepage.dart';
import 'package:industries/pages/myaccountspage.dart';
import 'package:industries/pages/myorderspage.dart';

enum NavigationEvents {
  HomePageClickEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
    }
  }

}