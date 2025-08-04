part of 'category_cubit.dart';


sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  List<Map<String, dynamic>>? totalTasks;

  CategoryLoaded(this.categories, this.totalTasks);
}

final class CategorySuccess extends CategoryState {
  final String message;

  CategorySuccess(this.message);
}

final class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
