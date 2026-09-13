class MatchProfile {
  String? profileId;
  String? name;
  String? dob;
  String? caste;
  String? religion;
  String? height;
  String? location;
  String? photo1;
  String? photo2;
  String? photo3;
  String? photo4;
  String? phone;
  String? mobile;
  String? birthtime;
  String? birthplace;
  String? education;
  String? occupation;
  String? annualIncome;
  String? subcaste;
  String? expectations;
  String? assets;
  String? nativePlace;

  MatchProfile(
      {this.profileId,
      this.name,
      this.dob,
      this.caste,
      this.religion,
      this.height,
      this.location,
      this.photo1,
      this.photo2,
      this.photo3,
      this.photo4,
      this.phone,
      this.mobile,
      this.birthtime,
      this.birthplace,
      this.education,
      this.occupation,
      this.annualIncome,
      this.subcaste,
      this.expectations,
      this.assets,
      this.nativePlace});

  MatchProfile.fromJson(Map<String, dynamic> json) {
    profileId = json['profile_id'] ?? json["id"];
    name = json['name'];
    dob = json['dob'];
    caste = json['caste'];
    religion = json['religion'];
    height = json['height'];
    location = json['location'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
    photo3 = json['photo3'];
    photo4 = json['photo4'];
    phone = json['phone'];
    mobile = json['mobile'];
    birthtime = json['birthtime'];
    birthplace = json['birthplace'];
    education = json['education'];
    occupation = json['occupation'];
    annualIncome = json['annual_income'];
    subcaste = json['subcaste'];
    expectations = json['general_expt'] ?? json['expectations'];
    assets = json['residance'] ?? json['assets'];
    nativePlace = json['native_place'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_id'] = this.profileId;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['caste'] = this.caste;
    data['religion'] = this.religion;
    data['height'] = this.height;
    data['location'] = this.location;
    data['photo1'] = this.photo1;
    data['photo2'] = this.photo2;
    data['photo3'] = this.photo3;
    data['photo4'] = this.photo4;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['birthtime'] = this.birthtime;
    data['birthplace'] = this.birthplace;
    data['education'] = this.education;
    data['occupation'] = this.occupation;
    data['annual_income'] = this.annualIncome;
    data['subcaste'] = this.subcaste;
    data['general_expt'] = this.expectations;
    data['residance'] = this.assets;
    data['native_place'] = this.nativePlace;
    return data;
  }
}
