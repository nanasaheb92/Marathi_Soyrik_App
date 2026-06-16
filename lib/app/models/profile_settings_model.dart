
class ProfileSettings {
  String? id;
  String? enableMobileVisibility;
  String? enablePhotoVisibility;
  String? enableEmailVisibility;

  ProfileSettings(
      {this.enableMobileVisibility,
        this.enablePhotoVisibility,
        this.enableEmailVisibility});

  ProfileSettings.fromJson(Map<String, dynamic> json) {
    enableMobileVisibility = json['contact_status'];
    enablePhotoVisibility = json['photo_status'];
    enableEmailVisibility = json['email_status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_status'] = enableMobileVisibility;
    data['photo_status'] = enablePhotoVisibility;
    data['email_status'] = enableEmailVisibility;
    data['id'] = id;
    return data;
  }
}