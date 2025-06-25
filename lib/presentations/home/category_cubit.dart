import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/services/category_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService _categoryService;

  CategoryCubit(this._categoryService) : super(CategoryInitial());

  Future<void> loadCategories() async {
    final categories = await _categoryService.getAllCategories();
    emit(CategoryLoaded(categories));
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoryService.insertCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _categoryService.deleteCategory(id);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoryService.updateCategory(category);
    await loadCategories();
  }
}
