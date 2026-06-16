class Search {
  String? id;
  String? gender;
  String? religion;
  String? caste;
  String? maritalStatus;
  String? motherTongue;
  String? ageFrom;
  String? ageTo;
  String? heightFrom;
  String? heightTo;
  String? country;
  String? state;
  String? city;
  String? education;

  Search(
      {this.gender,
      this.religion,
      this.caste,
      this.maritalStatus,
      this.motherTongue,
      this.ageFrom,
      this.ageTo,
      this.heightFrom,
      this.heightTo,
      this.country,
      this.state,
      this.city,
      this.education});

  Search.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gender = json['gender'];
    religion = json['religion'];
    caste = json['caste'];
    maritalStatus = json['marital_status'];
    motherTongue = json['mother_tongue'];
    ageFrom = json['age_from'];
    ageTo = json['age_to'];
    heightFrom = json['height_from'];
    heightTo = json['height_to'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    education = json['education'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = this.id;
    if (gender != null) {
      data['gender'] = gender;
    }

    if (religion != null) {
      religion = religion?.replaceFirst(RegExp(r'^,'), '');
      data['religion'] = religion;
    }

    if (caste != null) {
      caste = caste?.replaceFirst(RegExp(r'^,'), '');
      data['caste'] = caste;
    }

    if (maritalStatus != null) {
      maritalStatus = maritalStatus?.replaceFirst(RegExp(r'^,'), '');
      data['marital_status'] = maritalStatus;
    }

    if (motherTongue != null) {
      motherTongue = motherTongue?.replaceFirst(RegExp(r'^,'), '');
      data['mother_tongue'] = motherTongue;
    }

    if (ageFrom != null) {
      data['age_from'] = ageFrom;
    }

    if (ageTo != null) {
      data['age_to'] = ageTo;
    }

    if (heightFrom != null) {
      data['height_from'] = (heightFrom == null)
          ? ""
          : heightFrom
          .toString()
          .replaceAll(" ft", ".")
          .replaceAll(" ", "")
          .replaceAll("inches", "")
          .trim();
      if (data["height_from"]
          .toString()
          .length == 2) {
        data["height_from"] = "${data["height_from"]}0";
      }
    }

    if (heightTo != null) {
      data['height_to'] = (heightTo == null)
          ? ""
          : heightTo
          .toString()
          .replaceAll(" ft", ".")
          .replaceAll(" ", "")
          .replaceAll("inches", "")
          .trim();
      if (data["height_to"]
          .toString()
          .length == 2) {
        data["height_to"] = "${data["height_to"]}0";
      }
    }

    if (country != null) {
      // Remove the leading comma, if it exists
      country = country?.replaceFirst(RegExp(r'^,'), '');
      data['country'] = country;
    }

    if (state != null) {
      // Remove the leading comma, if it exists
      state = state?.replaceFirst(RegExp(r'^,'), '');
      data['state'] = state;
    }

    if (city != null) {
      // Remove the leading comma, if it exists
      city = city?.replaceFirst(RegExp(r'^,'), '');
      data['city'] = city;
    }

    if (education != null) {
      // Remove the leading comma, if it exists
      education = education?.replaceFirst(RegExp(r'^,'), '');
      data['education'] = education;
    }
    return data;
  }
}
