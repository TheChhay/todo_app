part of 'nav_cubit.dart';

@immutable
sealed class NavState {
  final int index;

  const NavState(this.index);
}

final class NavInitial extends NavState {
  const NavInitial(int index) : super(index);
}
