# API Folder vs Android Postman Collection Mapping

Generated against:
- API folder: `c:/wamp64/www/su/apis`
- Collection: `postman/MarathiSoyarik-Android-API.postman_collection.json`

## Summary
- API files detected: 61
- Endpoints directly mapped in Android collection: 50
- Added to collection from API folder: 11
- Collection-only routes (not present as php file in `/apis`): 7

## Added To Collection (from `/apis`)
- aadhaar-verification.php
- age-group-search.php
- best-matches.php
- get-horoscope.php
- latest-registered-profiles.php
- near_by_list.php
- profile_settings.php
- same-education.php
- same-occupation.php
- update-password.php
- upload-horoscope.php

These are added under folder:
- `Additional APIs (found in /apis)`

## Collection-only Routes
These are used by Android app but are not direct php files under `/apis`:
- banners
- logout
- news-blogs
- news-categories
- quote
- slider
- upload

## Local-first + Production switch
Collection now supports switching without editing URLs:
- `target_env=local` -> uses `local_base_url`
- `target_env=production` -> uses `production_base_url`

Default values:
- local_base_url = `http://localhost/su`
- production_base_url = `https://swapna.kothulefarm.in`

Update in collection variables before running:
- `target_env`
- `user_id`
- `profile_id`
- `recipient_id`
- upload file variables if testing file APIs
