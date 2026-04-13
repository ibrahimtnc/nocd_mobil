# 🚀 Hızlı Başlangıç - Firebase Functions Deploy

## ⚡ Hızlı Adımlar (5 Dakika)

### 1️⃣ Functions Dependencies Yükle

```bash
cd functions
npm install
cd ..
```

### 2️⃣ OpenAI API Key'i Firebase'e Ekle

**Firebase Console'dan:**
1. https://console.firebase.google.com → Projenizi seçin
2. **Functions** > **Configuration** > **Environment variables**
3. **Add variable** → Name: `OPENAI_API_KEY`, Value: API key'iniz
4. **Save**

### 3️⃣ Deploy Et

```bash
./deploy.sh
```

veya manuel:

```bash
firebase deploy --only functions
```

### 4️⃣ Flutter'da Test Et

```bash
flutter run
```

## ✅ Tamamlandı!

Artık uygulamanız gerçek OpenAI API'sini kullanıyor! 🎉

---

## 📖 Detaylı Rehber

Daha detaylı bilgi için `DEPLOY_GUIDE.md` dosyasına bakın.

