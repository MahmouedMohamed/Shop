// ignore_for_file: file_names

class User{
  String id;
  String? name;
  String? email;
  String? phoneNumber;
  String? photoUrl;
  String? latitude;
  String? longitude;
  String? address;
  User(
      this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.photoUrl,
      this.latitude,
      this.longitude,
      this.address,
      );
  List<String> toList()
  {
    return [
      id,
      name ?? '',
      email ?? '',
      phoneNumber ?? '',
      photoUrl ?? '',
      latitude ?? '',
      longitude ?? '',
      address ?? '',
    ];
  }
}