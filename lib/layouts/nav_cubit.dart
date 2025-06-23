import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'nav_state.dart';

class NavCubit extends Cubit<NavState> {
  NavCubit() : super(const NavInitial(0));

  void changeTab(int index) {
    emit(NavInitial(index)); // emitting new state with updated index
  }
}
