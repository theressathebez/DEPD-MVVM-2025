part of 'model.dart';

class InterCost extends Equatable {
	final String? name;
	final String? code;
	final String? service;
	final String? description;
	final String? currency;
	final double? cost;
	final String? etd;
	final String? currencyUpdatedAt;
	final double? currencyValue;

	const InterCost({
		this.name, 
		this.code, 
		this.service, 
		this.description, 
		this.currency, 
		this.cost, 
		this.etd, 
		this.currencyUpdatedAt, 
		this.currencyValue, 
	});

	factory InterCost.fromJson(Map<String, dynamic> json) => InterCost(
				name: json['name'] as String?,
				code: json['code'] as String?,
				service: json['service'] as String?,
				description: json['description'] as String?,
				currency: json['currency'] as String?,
				cost: (json['cost'] as num?)?.toDouble(),
				etd: json['etd'] as String?,
				currencyUpdatedAt: json['currency_updated_at'] as String?,
				currencyValue: (json['currency_value'] as num?)?.toDouble(),
			);

	Map<String, dynamic> toJson() => {
				'name': name,
				'code': code,
				'service': service,
				'description': description,
				'currency': currency,
				'cost': cost,
				'etd': etd,
				'currency_updated_at': currencyUpdatedAt,
				'currency_value': currencyValue,
			};

	@override
	List<Object?> get props {
		return [
				name,
				code,
				service,
				description,
				currency,
				cost,
				etd,
				currencyUpdatedAt,
				currencyValue,
		];
	}
}
