import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir
class InterRepository {
  final _apiServices = NetworkApiServices();

  Future<List<InternationalCountry>> fetchInternationalDestination(
    String search,
  ) async {
    final response = await _apiServices.getApiResponse(
      'destination/international-destination',
      queryParameters: {"search": search, "limit": "20", "offset": "0"},
    );

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception(meta?['message'] ?? "Error API");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => InternationalCountry.fromJson(e)).toList();
  }

  Future<List<InterCost>> checkInternationalCost({
    required String origin,
    required String destinationCountryCode,
    required int weight,
    required String courier,
  }) async {
    final response = await _apiServices
        .postApiResponse('calculate/international-cost', {
          "origin": origin,
          "destination": destinationCountryCode,
          "weight": weight.toString(),
          "courier": courier,
        });

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception(meta?['message'] ?? "Unknown error");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => InterCost.fromJson(e)).toList();
  }
}
