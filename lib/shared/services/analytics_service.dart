import 'dart:async';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';

/// {@template analytics_service}
/// A service responsible for fetching, caching, and managing analytics data.
///
/// This service acts as the "Single Source of Truth" for analytics within the
/// dashboard session. It implements:
/// 1.  **In-Memory Caching:** Stores fetched data to prevent redundant network
///     calls when navigating between tabs or pages.
/// 2.  **Request Deduplication:** Merges simultaneous requests for the same
///     resource into a single network call.
/// {@endtemplate}
class AnalyticsService {
  /// {@macro analytics_service}
  AnalyticsService({
    required DataRepository<KpiCardData> kpiRepository,
    required DataRepository<ChartCardData> chartRepository,
    required DataRepository<RankedListCardData> rankedListRepository,
  }) : _kpiRepository = kpiRepository,
       _chartRepository = chartRepository,
       _rankedListRepository = rankedListRepository;

  final DataRepository<KpiCardData> _kpiRepository;
  final DataRepository<ChartCardData> _chartRepository;
  final DataRepository<RankedListCardData> _rankedListRepository;

  // --- Caches ---
  final _kpiCache = <KpiCardId, KpiCardData>{};
  final _chartCache = <ChartCardId, ChartCardData>{};
  final _rankedListCache = <RankedListCardId, RankedListCardData>{};

  // --- In-Flight Requests (Deduplication) ---
  final _kpiInFlight = <KpiCardId, Future<KpiCardData>>{};
  final _chartInFlight = <ChartCardId, Future<ChartCardData>>{};
  final _rankedListInFlight = <RankedListCardId, Future<RankedListCardData>>{};

  /// Fetches a KPI card by its [id].
  ///
  /// If [forceRefresh] is true, bypasses the cache.
  Future<KpiCardData> getKpi(
    KpiCardId id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _kpiCache.containsKey(id)) {
      return _kpiCache[id]!;
    }

    if (_kpiInFlight.containsKey(id)) {
      return _kpiInFlight[id]!;
    }

    final future = _kpiRepository.readAll(filter: {'_id': id.name}).then((
      response,
    ) {
      if (response.items.isEmpty) {
        throw const NotFoundException('KPI card not found');
      }
      final data = response.items.first;
      _kpiCache[id] = data;
      return data;
    });

    _kpiInFlight[id] = future;

    try {
      return await future;
    } finally {
      await _kpiInFlight.remove(id);
    }
  }

  /// Fetches a Chart card by its [id].
  ///
  /// If [forceRefresh] is true, bypasses the cache.
  Future<ChartCardData> getChart(
    ChartCardId id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _chartCache.containsKey(id)) {
      return _chartCache[id]!;
    }

    if (_chartInFlight.containsKey(id)) {
      return _chartInFlight[id]!;
    }

    final future = _chartRepository.readAll(filter: {'_id': id.name}).then((
      response,
    ) {
      if (response.items.isEmpty) {
        throw const NotFoundException('Chart card not found');
      }
      final data = response.items.first;
      _chartCache[id] = data;
      return data;
    });

    _chartInFlight[id] = future;

    try {
      return await future;
    } finally {
      await _chartInFlight.remove(id);
    }
  }

  /// Fetches a Ranked List card by its [id].
  ///
  /// If [forceRefresh] is true, bypasses the cache.
  Future<RankedListCardData> getRankedList(
    RankedListCardId id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _rankedListCache.containsKey(id)) {
      return _rankedListCache[id]!;
    }

    if (_rankedListInFlight.containsKey(id)) {
      return _rankedListInFlight[id]!;
    }

    final future = _rankedListRepository.readAll(filter: {'_id': id.name}).then(
      (response) {
        if (response.items.isEmpty) {
          throw const NotFoundException('Ranked list card not found');
        }
        final data = response.items.first;
        _rankedListCache[id] = data;
        return data;
      },
    );

    _rankedListInFlight[id] = future;

    try {
      return await future;
    } finally {
      await _rankedListInFlight.remove(id);
    }
  }

  /// Clears all cached data.
  void clearCache() {
    _kpiCache.clear();
    _chartCache.clear();
    _rankedListCache.clear();
  }
}
