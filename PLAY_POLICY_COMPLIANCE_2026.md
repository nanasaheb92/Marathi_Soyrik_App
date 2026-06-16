# Google Play Policy Compliance Checklist (2026 Update)

This project has been reviewed against the July 2026 policy notice and updated where code changes were possible.

## Changes applied in code

1. Added strict 18+ enforcement in signup profile flow.
- Validation now blocks registration/profile submission if date of birth is under 18.
- Applied in both UI form validation and controller submit logic.

2. Added explicit manifest guards to remove restricted telephony/SMS permissions.
- `READ_CALL_LOG`, `WRITE_CALL_LOG`, `READ_SMS`, `RECEIVE_SMS`, `SEND_SMS`, `RECEIVE_MMS`, `RECEIVE_WAP_PUSH`, `READ_PHONE_STATE`, `READ_PHONE_NUMBERS`, `PROCESS_OUTGOING_CALLS` are explicitly removed with `tools:node="remove"`.
- This protects against accidental permission additions from transitive dependencies.

3. Verified target SDK compliance.
- Android target SDK is already set to 36, which satisfies the Aug 31, 2026 target API requirement.

## What to verify manually in Play Console (required)

These items cannot be fully completed by source-code edits alone:

1. App content and age settings
- Set proper audience and content rating.
- Ensure app is not targeted to children if chat/contact features are present.
- Confirm declarations align with age-restricted content requirements.

2. Data safety form
- Declare all user data collected/shared (profile info, phone, photos, chat metadata, notifications, analytics, auth data, payment metadata).
- Include third-party SDK data practices (OneSignal, Firebase Auth, OTP/verification SDKs, payment SDKs).
- If any AI features are enabled now or in future, include AI-provider data handling in disclosures.

3. SMS/Call Log declaration page
- Confirm no restricted SMS/Call Log permissions are requested in release artifact.
- Since `READ_CALL_LOG` is not requested, remove any old declaration forms if previously submitted.

4. Developer verification / app registration
- Check Android Developer Verification page and register any unregistered apps.

5. Privacy policy consistency
- Ensure hosted privacy policy URL content explicitly covers:
  - age restrictions (18+),
  - data collection/use/sharing,
  - OTP/phone verification flow,
  - notifications,
  - account deletion/contact channel.

## Quick pre-release commands

Run before uploading to Play:

1. `flutter clean`
2. `flutter pub get`
3. `cd android && .\gradlew.bat :app:processReleaseMainManifest`
4. Inspect merged manifest and verify restricted permissions are absent.
5. Build release bundle and upload to internal testing first.

## Notes

- The app currently uses OTP-based verification and does not request `READ_CALL_LOG`.
- Keep this file updated when SDKs are upgraded, because SDK manifest changes can affect Play declarations.
