library tv_series;

export 'data/datasources/tv_series_local_data_source.dart';
export 'data/datasources/tv_series_remote_data_source.dart';

export 'data/models/tv_series_detail_model.dart';
export 'data/models/tv_series_model.dart';
export 'data/models/tv_series_response.dart';
export 'data/models/tv_series_table.dart';

export 'data/repositories/tv_series_repository_impl.dart';

export 'domain/entities/tv_series.dart';
export 'domain/entities/tv_series_detail.dart';

export 'domain/repositories/tv_series_repository.dart';

export 'domain/usecases/get_on_the_air_tv_series.dart';
export 'domain/usecases/get_popular_tv_series.dart';
export 'domain/usecases/get_top_rated_tv_series.dart';
export 'domain/usecases/get_tv_series_detail.dart';
export 'domain/usecases/get_tv_series_recommendations.dart';
export 'domain/usecases/get_watchlist_tv_series.dart';
export 'domain/usecases/get_watchlist_tv_series_status.dart';
export 'domain/usecases/remove_tv_series_watchlist.dart';
export 'domain/usecases/save_tv_series_watchlist.dart';

export 'presentation/pages/popular_tv_series_page.dart';
export 'presentation/pages/top_rated_tv_series_page.dart';
export 'presentation/pages/tv_series_detail_page.dart';
export 'presentation/pages/tv_series_page.dart';
export 'presentation/pages/watchlist_tv_series_page.dart';

export 'presentation/providers/popular_tv_series_notifier.dart';
export 'presentation/providers/top_rated_tv_series_notifier.dart';
export 'presentation/providers/tv_series_detail_notifier.dart';
export 'presentation/providers/tv_series_list_notifier.dart';
export 'presentation/providers/watchlist_tv_series_notifier.dart';

export 'presentation/widgets/tv_series_card_list.dart';
