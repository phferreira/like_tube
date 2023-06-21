import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_remove_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/remove_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_historic_video_usecase.dart';

class HistoryVideoStore extends NotifierStore<IFailure, ListVideo> {
  HistoryVideoStore() : super(List.of([]));

  IGetHistoricVideoUsecase get _getHistoricVideoUsecase => Modular.get<GetHistoricVideoUsecase>();
  ISetHistoricVideoUsecase get _setHistoricVideoUsecase => Modular.get<SetHistoricVideoUsecase>();
  IRemoveHistoricVideoUsecase get _removeHistoricVideoUsecase => Modular.get<RemoveHistoricVideoUsecase>();

  Future<void> getHistoryVideos() async {
    setLoading(true);
    update((await _getHistoricVideoUsecase()).fold((l) => [], (r) => r));
    setLoading(false);
  }

  Future<void> setHistoryVideo(Video video) async {
    await _setHistoricVideoUsecase(video);
  }

  Future<void> removeAll() async {
    setLoading(true);
    for (final Video video in state) {
      await _removeHistoricVideoUsecase(video);
    }
    await getHistoryVideos();
    setLoading(false);
  }
}
