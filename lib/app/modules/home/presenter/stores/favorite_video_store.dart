import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_all_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_all_favorite_video_usecase.dart';

class FavoriteVideoStore extends NotifierStore<IFailure, List<Video>> {
  FavoriteVideoStore() : super([]);

  IGetAllFavoriteVideoUsecase get _getAllFavoriteUsecase => Modular.get<GetAllFavoriteVideoUsecase>();

  Future<void> getAllFavoriteVideos() async {
    setLoading(true);
    update((await _getAllFavoriteUsecase()).fold((l) => [], (r) => r));
    setLoading(false);
  }
}
