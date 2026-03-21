import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'providers';
const _addedProvidersKey = 'added_providers';

/// Provider for managing the list of added providers
class AddedProvidersNotifier extends StateNotifier<List<String>> {
  AddedProvidersNotifier() : super([]) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final list = box.get(_addedProvidersKey, defaultValue: <String>[]);
    state = List<String>.from(list);
  }

  Future<void> _saveToStorage() async {
    final box = await Hive.openBox(_boxName);
    await box.put(_addedProvidersKey, state);
  }

  Future<void> addProvider(String providerId) async {
    if (!state.contains(providerId)) {
      state = [...state, providerId];
      await _saveToStorage();
    }
  }

  Future<void> removeProvider(String providerId) async {
    state = state.where((id) => id != providerId).toList();
    await _saveToStorage();
  }

  bool hasProvider(String providerId) {
    return state.contains(providerId);
  }
}

final addedProvidersProvider =
    StateNotifierProvider<AddedProvidersNotifier, List<String>>((ref) {
  return AddedProvidersNotifier();
});
