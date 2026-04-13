#!/bin/bash

# Firebase Functions Deploy Script
# Bu script Firebase Functions'ı deploy eder

echo "🚀 Firebase Functions Deploy Başlatılıyor..."

# 1. Functions klasörüne git
cd functions || exit

# 2. Dependencies kontrolü
if [ ! -d "node_modules" ]; then
  echo "📦 Dependencies yükleniyor..."
  npm install
else
  echo "✅ Dependencies zaten yüklü"
fi

# 3. Ana dizine dön
cd ..

# 4. Firebase deploy
echo "🚀 Functions deploy ediliyor..."
firebase deploy --only functions

# 5. Başarı mesajı
if [ $? -eq 0 ]; then
  echo "✅ Deploy başarılı!"
  echo "📱 Flutter uygulamanızı test edebilirsiniz."
else
  echo "❌ Deploy başarısız! Lütfen hataları kontrol edin."
  exit 1
fi

