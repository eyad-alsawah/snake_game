import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/core/extensions.dart';

class UpdateViewCubit extends Cubit<List<int>> {
  UpdateViewCubit(super.initialState);

  void updateView(List<int> activeIndices) {
    emit(activeIndices.deepCopy());
  }
}
