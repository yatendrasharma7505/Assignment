import 'package:assignment/model/repository/repo.dart';
import 'package:assignment/model/response/reels_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final Repo _repo = Repo();

  ReelsCubit() : super(ReelsInitial());

  void fetchReels() async {
    emit(ReelsLoading());
    try {
      final reels = await _repo.fetchReels();
      emit(ReelsLoaded(reels));
    } catch (e) {
      emit(ReelsError(e.toString()));
    }
  }
}

abstract class ReelsState {}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final ReelsResponse reels;
  ReelsLoaded(this.reels);
}

class ReelsError extends ReelsState {
  final String message;
  ReelsError(this.message);
}
