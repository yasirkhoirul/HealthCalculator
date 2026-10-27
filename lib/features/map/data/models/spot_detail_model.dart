import 'package:json_annotation/json_annotation.dart';
import 'spot_model.dart';

part 'spot_detail_model.g.dart';

/// Model data detail spot belajar kampus
@JsonSerializable(explicitToJson: true)
class SpotDetailModel {
  final SpotModel spot;
  final List<String> photos;
  final List<String> amenities;
  final int activeBuddiesCount;
  final String operatingHours;

  const SpotDetailModel({
    required this.spot,
    this.photos = const [],
    this.amenities = const [],
    this.activeBuddiesCount = 0,
    this.operatingHours = '08:00 - 21:00',
  });

  factory SpotDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SpotDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotDetailModelToJson(this);

  SpotDetailModel copyWith({
    SpotModel? spot,
    List<String>? photos,
    List<String>? amenities,
    int? activeBuddiesCount,
    String? operatingHours,
  }) {
    return SpotDetailModel(
      spot: spot ?? this.spot,
      photos: photos ?? this.photos,
      amenities: amenities ?? this.amenities,
      activeBuddiesCount: activeBuddiesCount ?? this.activeBuddiesCount,
      operatingHours: operatingHours ?? this.operatingHours,
    );
  }
}
