part of 'category_cubit.dart';


@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);
}
