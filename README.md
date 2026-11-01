# Gia Phả Việt 4.0 — Flutter v0.2

Ứng dụng nguyên mẫu Android, chưa có backend và chưa lưu dữ liệu lâu dài.

## Tự động tạo APK
Vào **Actions → Build Android APK → Run workflow** (hoặc đợi push vào main).
Sau khi workflow thành công, tải artifact `gia-pha-viet-v0-2-debug-apk`, giải nén và cài `app-debug.apk`.

## Chạy cục bộ
Cài Flutter SDK và Android SDK, sau đó chạy:
```sh
flutter create --org vn.giaphaviet --platforms android .
flutter pub get
flutter run
```

**Lưu ý:** Đây là bản demo chưa kiểm thử APK, dữ liệu chỉ lưu trong bộ nhớ. Không nhập dữ liệu cá nhân thực.
