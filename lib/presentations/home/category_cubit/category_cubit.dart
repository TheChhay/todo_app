import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/services/category_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService _categoryService;

  CategoryCubit(this._categoryService) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryService.getAllCategories();
      final totalTasks = await _categoryService.countTasksGroupedByCategory();
      emit(CategoryLoaded(categories, totalTasks));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    emit(CategoryLoading());
    try {
      await _categoryService.insertCategory(category);
      final categories = await _categoryService.getAllCategories();
      final totalTasks = await _categoryService.countTasksGroupedByCategory();

      emit(CategorySuccess('Category added successfully.'));
      emit(CategoryLoaded(categories, totalTasks));
      print('Category added successfully.');
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
      print('$e');
    }
  }

  Future<void> deleteCategory(int id) async {
    emit(CategoryLoading());
    try {
      await _categoryService.deleteCategory(id);
      final categories = await _categoryService.getAllCategories();
      final totalTasks = await _categoryService.countTasksGroupedByCategory();

      emit(CategorySuccess('Category deleted successfully.'));
      emit(CategoryLoaded(categories, totalTasks));
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    emit(CategoryLoading());
    try {
      await _categoryService.updateCategory(category);
      final categories = await _categoryService.getAllCategories();
      final totalTasks = await _categoryService.countTasksGroupedByCategory();

      emit(CategorySuccess('Category updated successfully.'));
      emit(CategoryLoaded(categories, totalTasks));
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }
}
