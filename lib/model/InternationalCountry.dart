part of 'model.dart';

class InternationalCountry extends Equatable {
	final String? countryId;
	final String? countryName;

	const InternationalCountry({this.countryId, this.countryName});

	factory InternationalCountry.fromJson(Map<String, dynamic> json) => InternationalCountry(
				countryId: json['country_id'] as String?,
				countryName: json['country_name'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'country_id': countryId,
				'country_name': countryName,
			};

	@override
	List<Object?> get props => [countryId, countryName];
}
