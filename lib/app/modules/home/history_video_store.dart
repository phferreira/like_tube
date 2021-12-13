import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_remove_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/remove_historic_video_usecase.dart';

import 'domain/usecases/implementation/set_historic_video_usecase.dart';

class HistoryVideoStore extends NotifierStore<IFailure, List<Video>> {
  HistoryVideoStore() : super([]);

  IGetHistoricVideoUsecase get _getHistoricVideoUsecase => Modular.get<GetHistoricVideoUsecase>();
  ISetHistoricVideoUsecase get _setHistoricVideoUsecase => Modular.get<SetHistoricVideoUsecase>();
  IRemoveHistoricVideoUsecase get _removeHistoricVideoUsecase => Modular.get<RemoveHistoricVideoUsecase>();

  Future getHistoryVideos() async {
    setLoading(true);
    update((await _getHistoricVideoUsecase()).fold((l) => [], (r) => r));
    setLoading(false);
  }

  Future setHistoryVideo(Video video) async {
    await _setHistoricVideoUsecase(video);
  }

  void removeAll() async {
    for (Video video in state) {
      await _removeHistoricVideoUsecase(video);
    }
  }
}
