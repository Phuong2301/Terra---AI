class BusinessLocationResponse {
  final bool success;
  final String message;
  final int status;
  final List<BusinessLocation> data;
  final Paginate? paginate;

  BusinessLocationResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.paginate,
  });

  factory BusinessLocationResponse.fromJson(Map<String, dynamic> json) {
    return BusinessLocationResponse(
      success: json['success'] ?? false,
      message: (json['message'] ?? '').toString(),
      status: json['status'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => BusinessLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginate: json['paginate'] != null
          ? Paginate.fromJson(json['paginate'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.map((e) => e.toJson()).toList(),
        'paginate': paginate?.toJson(),
      };
}

class BusinessLocation {
  final int id;
  final String code;
  final String businessName;
  final String? businessStartDate;
  final int? currencyId;
  final int? timezoneId;
  final int? countryId;
  final int? provinceId;
  final int? cityId;
  final String? addressLine1;
  final String? addressLine2;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final String? contactPerson;
  final String? contactNumber;
  final String? contactEmail;
  final String? logoPath;
  final int? financialYearStartMonth;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? createdBy;
  final int? updatedBy;

  final Currency? currency;
  final Country? country;
  final Province? province;
  final City? city;
  final TimezoneModel? timezone;
  final List<LocationHistory> histories;

  BusinessLocation({
    required this.id,
    required this.code,
    required this.businessName,
    required this.businessStartDate,
    required this.currencyId,
    required this.timezoneId,
    required this.countryId,
    required this.provinceId,
    required this.cityId,
    required this.addressLine1,
    required this.addressLine2,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.contactPerson,
    required this.contactNumber,
    required this.contactEmail,
    required this.logoPath,
    required this.financialYearStartMonth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.currency,
    required this.country,
    required this.province,
    required this.city,
    required this.timezone,
    required this.histories,
  });

  factory BusinessLocation.fromJson(Map<String, dynamic> json) {
    return BusinessLocation(
      id: json['id'] ?? 0,
      code: (json['code'] ?? '').toString(),
      businessName: (json['business_name'] ?? '').toString(),
      businessStartDate: json['business_start_date']?.toString(),
      currencyId: json['currency_id'],
      timezoneId: json['timezone_id'],
      countryId: json['country_id'],
      provinceId: json['province_id'],
      cityId: json['city_id'],
      addressLine1: json['address_line1']?.toString(),
      addressLine2: json['address_line2']?.toString(),
      postalCode: json['postal_code']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      contactPerson: json['contact_person']?.toString(),
      contactNumber: json['contact_number']?.toString(),
      contactEmail: json['contact_email']?.toString(),
      logoPath: json['logo_path']?.toString(),
      financialYearStartMonth: json['financial_year_start_month'],
      isActive: _toBool(json['is_active']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      currency: json['currency'] != null
          ? Currency.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? Country.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      province: json['province'] != null
          ? Province.fromJson(json['province'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? City.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      timezone: json['timezone'] != null
          ? TimezoneModel.fromJson(json['timezone'] as Map<String, dynamic>)
          : null,
      histories: (json['histories'] as List? ?? [])
          .map((e) => LocationHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'business_name': businessName,
        'business_start_date': businessStartDate,
        'currency_id': currencyId,
        'timezone_id': timezoneId,
        'country_id': countryId,
        'province_id': provinceId,
        'city_id': cityId,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'contact_person': contactPerson,
        'contact_number': contactNumber,
        'contact_email': contactEmail,
        'logo_path': logoPath,
        'financial_year_start_month': financialYearStartMonth,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'currency': currency?.toJson(),
        'country': country?.toJson(),
        'province': province?.toJson(),
        'city': city?.toJson(),
        'timezone': timezone?.toJson(),
        'histories': histories.map((e) => e.toJson()).toList(),
      };
}

class Currency {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json['id'] ?? 0,
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        symbol: (json['symbol'] ?? '').toString(),
        isActive: _toBool(json['is_active']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'symbol': symbol,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Country {
  final int id;
  final String name;
  final String code;
  final String? phoneCode;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'] ?? 0,
        name: (json['name'] ?? '').toString(),
        code: (json['code'] ?? '').toString(),
        phoneCode: json['phone_code']?.toString(),
        isActive: _toBool(json['is_active']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'phone_code': phoneCode,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Province {
  final int id;
  final int? countryId;
  final String name;
  final String? code;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  Province({
    required this.id,
    required this.countryId,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json['id'] ?? 0,
        countryId: json['country_id'],
        name: (json['name'] ?? '').toString(),
        code: json['code']?.toString(),
        isActive: _toBool(json['is_active']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country_id': countryId,
        'name': name,
        'code': code,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class City {
  final int id;
  final int? provinceId;
  final String name;
  final String? code;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  City({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] ?? 0,
        provinceId: json['province_id'],
        name: (json['name'] ?? '').toString(),
        code: json['code']?.toString(),
        isActive: _toBool(json['is_active']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'province_id': provinceId,
        'name': name,
        'code': code,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class TimezoneModel {
  final int id;
  final String name;
  final String offset;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  TimezoneModel({
    required this.id,
    required this.name,
    required this.offset,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimezoneModel.fromJson(Map<String, dynamic> json) => TimezoneModel(
        id: json['id'] ?? 0,
        name: (json['name'] ?? '').toString(),
        offset: (json['offset'] ?? '').toString(),
        isActive: _toBool(json['is_active']),
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'offset': offset,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class LocationHistory {
  final int id;
  final int? locationId;
  final String locationCode;
  final String businessName;
  final int? countryId;
  final int? provinceId;
  final int? cityId;
  final String? contactPerson;
  final String? contactNumber;
  final String? contactEmail;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final Country? country;
  final Province? province;
  final City? city;

  LocationHistory({
    required this.id,
    required this.locationId,
    required this.locationCode,
    required this.businessName,
    required this.countryId,
    required this.provinceId,
    required this.cityId,
    required this.contactPerson,
    required this.contactNumber,
    required this.contactEmail,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.province,
    required this.city,
  });

  factory LocationHistory.fromJson(Map<String, dynamic> json) =>
      LocationHistory(
        id: json['id'] ?? 0,
        locationId: json['location_id'],
        locationCode: (json['location_code'] ?? '').toString(),
        businessName: (json['business_name'] ?? '').toString(),
        countryId: json['country_id'],
        provinceId: json['province_id'],
        cityId: json['city_id'],
        contactPerson: json['contact_person']?.toString(),
        contactNumber: json['contact_number']?.toString(),
        contactEmail: json['contact_email']?.toString(),
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['created_at']?.toString(),
        updatedAt: json['updated_at']?.toString(),
        country: json['country'] != null
            ? Country.fromJson(json['country'] as Map<String, dynamic>)
            : null,
        province: json['province'] != null
            ? Province.fromJson(json['province'] as Map<String, dynamic>)
            : null,
        city: json['city'] != null
            ? City.fromJson(json['city'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'location_code': locationCode,
        'business_name': businessName,
        'country_id': countryId,
        'province_id': provinceId,
        'city_id': cityId,
        'contact_person': contactPerson,
        'contact_number': contactNumber,
        'contact_email': contactEmail,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'country': country?.toJson(),
        'province': province?.toJson(),
        'city': city?.toJson(),
      };
}

class Paginate {
  final int currentPage;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginateLink> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  Paginate({
    required this.currentPage,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        currentPage: json['current_page'] ?? 0,
        firstPageUrl: json['first_page_url']?.toString(),
        from: json['from'],
        lastPage: json['last_page'] ?? 0,
        lastPageUrl: json['last_page_url']?.toString(),
        links: (json['links'] as List? ?? [])
            .map((e) => PaginateLink.fromJson(e as Map<String, dynamic>))
            .toList(),
        nextPageUrl: json['next_page_url']?.toString(),
        path: json['path']?.toString(),
        perPage: json['per_page'] is int
            ? json['per_page']
            : int.tryParse(json['per_page']?.toString() ?? '0') ?? 0,
        prevPageUrl: json['prev_page_url']?.toString(),
        to: json['to'],
        total: json['total'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'links': links.map((e) => e.toJson()).toList(),
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}

class PaginateLink {
  final String? url;
  final String label;
  final bool active;

  PaginateLink({
    required this.url,
    required this.label,
    required this.active,
  });

  factory PaginateLink.fromJson(Map<String, dynamic> json) => PaginateLink(
        url: json['url']?.toString(),
        label: (json['label'] ?? '').toString(),
        active: _toBool(json['active']),
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'label': label,
        'active': active,
      };
}

bool _toBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v.toString().toLowerCase();
  return s == 'true' || s == '1';
}
