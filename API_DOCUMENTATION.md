# Backend API Documentation

## API Base Configuration

- Active Base URL: https://swapna.kothulefarm.in/
- API Path Prefix: apis/
- Endpoint Builder File: lib/app/providers/api_endpoints.dart
- API Call Executor File: lib/app/providers/api_provider.dart

## Endpoint Index

| Method | Endpoint | Included In File(s) |
|---|---|---|
| GET | banners | lib/app/repositories/slider_repository.dart |
| GET | logout | lib/app/repositories/user_repository.dart |
| GET | master-data.php | lib/app/repositories/settings_repository.dart |
| GET | news-blogs/${category.catId} | lib/app/repositories/category_repository.dart |
| GET | news-categories | lib/app/repositories/category_repository.dart |
| GET | packages.php | lib/app/repositories/settings_repository.dart |
| GET | quote/get-next/${day} | lib/app/repositories/onBoard_repository.dart |
| GET | slider/all | lib/app/repositories/onBoard_repository.dart |
| GET | success-stories.php | lib/app/repositories/settings_repository.dart |
| POST | add_block_list.php | lib/app/repositories/matches_repository.dart |
| POST | api/set-vpin | lib/app/repositories/user_repository.dart |
| POST | api/signup | lib/app/repositories/user_repository.dart |
| POST | api/verify-otp | lib/app/repositories/user_repository.dart |
| POST | basic-details-update.php | lib/app/repositories/membership_repository.dart |
| POST | blogs | lib/app/repositories/category_repository.dart |
| POST | education-occupation-update.php | lib/app/repositories/membership_repository.dart |
| POST | family-details-update.php | lib/app/repositories/membership_repository.dart |
| POST | forgot-password.php | lib/app/repositories/user_repository.dart |
| POST | get_education_occupation_preferance.php | lib/app/repositories/membership_repository.dart |
| POST | get_Location_Details.php | lib/app/repositories/membership_repository.dart |
| POST | get_partner_preferance.php | lib/app/repositories/membership_repository.dart |
| POST | get_religious_preference.php | lib/app/repositories/membership_repository.dart |
| POST | get-basic-details.php | lib/app/repositories/membership_repository.dart |
| POST | get-document.php | lib/app/repositories/membership_repository.dart |
| POST | get-education-occupation.php | lib/app/repositories/membership_repository.dart |
| POST | get-family-details.php | lib/app/repositories/membership_repository.dart |
| POST | get-lifestyle.php | lib/app/repositories/membership_repository.dart |
| POST | get-location-details.php | lib/app/repositories/membership_repository.dart |
| POST | get-other-pictures.php | lib/app/repositories/membership_repository.dart |
| POST | get-religious-info.php | lib/app/repositories/membership_repository.dart |
| POST | lifestyle-update.php | lib/app/repositories/membership_repository.dart |
| POST | location-details-update.php | lib/app/repositories/membership_repository.dart |
| POST | login.php | lib/app/repositories/user_repository.dart |
| POST | matches.php | lib/app/repositories/matches_repository.dart |
| POST | my_package.php | lib/app/repositories/settings_repository.dart |
| POST | profile-details.php | lib/app/repositories/matches_repository.dart<br>lib/app/repositories/user_repository.dart |
| POST | Received_interest.php | lib/app/repositories/matches_repository.dart |
| POST | register.php | lib/app/repositories/user_repository.dart |
| POST | religious-info-update.php | lib/app/repositories/membership_repository.dart |
| POST | search.php | lib/app/repositories/matches_repository.dart<br>lib/app/repositories/settings_repository.dart |
| POST | send-chat.php | lib/app/repositories/matches_repository.dart |
| POST | send-contact.php | lib/app/repositories/matches_repository.dart |
| POST | send-interest.php | lib/app/repositories/matches_repository.dart |
| POST | Sent_interest.php | lib/app/repositories/matches_repository.dart |
| POST | shortlist.php | lib/app/repositories/matches_repository.dart |
| POST | show_Blocked_Profile.php | lib/app/repositories/matches_repository.dart |
| POST | show_shortlist_profile.php | lib/app/repositories/matches_repository.dart |
| POST | update_education_occupation_preferance.php | lib/app/repositories/membership_repository.dart |
| POST | update_Location_Details.php | lib/app/repositories/membership_repository.dart |
| POST | update_partner_preferance.php | lib/app/repositories/membership_repository.dart |
| POST | update_religious_preference.php | lib/app/repositories/membership_repository.dart |
| POST | update_status.php | lib/app/repositories/matches_repository.dart |
| POST | update-visibility-status.php | lib/app/repositories/membership_repository.dart |
| POST | upload | lib/app/providers/api_provider.dart |
| POST | upload-document.php | lib/app/repositories/membership_repository.dart |
| POST | upload-other-pictures.php | lib/app/repositories/membership_repository.dart |
| POST | view_profile.php | lib/app/repositories/matches_repository.dart |
| POST | viewed_my_profile.php | lib/app/repositories/matches_repository.dart |
| POST | viewed_profile.php | lib/app/repositories/matches_repository.dart |

## Source Files Containing API Calls

- lib/app/providers/api_provider.dart
- lib/app/repositories/category_repository.dart
- lib/app/repositories/matches_repository.dart
- lib/app/repositories/membership_repository.dart
- lib/app/repositories/onBoard_repository.dart
- lib/app/repositories/settings_repository.dart
- lib/app/repositories/slider_repository.dart
- lib/app/repositories/user_repository.dart

