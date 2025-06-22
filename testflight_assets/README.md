# 🚀 Trisolaris Jump - TestFlight Assets

## 📁 Struktura fajlova

```
testflight_assets/
├── app_description.txt      # App Store opis
├── keywords.txt            # App Store ključne reči
├── test_information.txt    # TestFlight test informacije
├── email_template.txt      # Email template za testirače
├── checklist.txt          # Checklist pre objavljivanja
└── README.md              # Ovo
```

## 🎯 Koraci za TestFlight

### 1. App Store Connect Setup
1. Idite na [App Store Connect](https://appstoreconnect.apple.com)
2. Kliknite "My Apps" → "+" → "New App"
3. Popunite informacije iz `app_description.txt`
4. Dodajte ključne reči iz `keywords.txt`

### 2. Screenshots
- Screenshot-ovi su generisani u `screenshots/` folderu
- Upload-ujte ih u App Store Connect → Screenshots sekciju

### 3. TestFlight
1. Upload-ujte build u App Store Connect
2. Idite na TestFlight tab
3. Dodajte test informacije iz `test_information.txt`
4. Invite testirače koristeći `email_template.txt`

### 4. Checklist
- Proverite `checklist.txt` pre objavljivanja

## 📱 Podržani uređaji

- iPhone SE (1st, 2nd, 3rd generation)
- iPhone 8, 8 Plus, X, XS, XS Max
- iPhone XR, 11, 11 Pro, 11 Pro Max
- iPhone 12, 12 mini, 12 Pro, 12 Pro Max
- iPhone 13, 13 mini, 13 Pro, 13 Pro Max
- iPhone 14, 14 Plus, 14 Pro, 14 Pro Max
- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max
- iPad (5th-10th generation)
- iPad Air (3rd-5th generation)
- iPad Pro (11-inch, 12.9-inch)
- iPad mini (5th-6th generation)

## 🎨 Screenshot veličine

- iPhone 6.7" Display: 1290 x 2796
- iPhone 6.5" Display: 1242 x 2688
- iPhone 5.5" Display: 1242 x 2208
- iPad Pro 12.9" Display: 2048 x 2732
- iPad Pro 11" Display: 1668 x 2388

## 🚨 Česti problemi

### "No provisioning profiles found"
- Xcode → Preferences → Accounts
- Dodajte Apple ID
- Download Manual Profiles

### "Archive failed"
- Clean Build Folder (Cmd+Shift+K)
- Clean Build (Cmd+K)
- Proverite bundle identifier

### "Upload failed"
- Proverite internet konekciju
- Pokušajte ponovo
- Proverite da li je build "Ready to Submit"

## 📊 Korisni linkovi

- [App Store Connect](https://appstoreconnect.apple.com)
- [TestFlight Guidelines](https://developer.apple.com/testflight/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Napomena:** TestFlight je besplatan i omogućava testiranje sa do 10,000 testirača.
