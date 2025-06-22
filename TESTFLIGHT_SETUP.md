# 🚀 TestFlight Setup - Trisolaris Jump

## 📋 Preduslovi

### 🍎 Apple Developer Account
- **Apple Developer Program** članstvo ($99/godišnje)
- **App Store Connect** pristup
- **Xcode** 15.0+ instaliran

### 📱 Uređaji za testiranje
- **iPhone/iPad** sa iOS 15.0+
- **TestFlight** aplikacija instalirana
- **Apple ID** za testiranje

## 🛠️ Koraci za TestFlight Setup

### 1. Priprema projekta

#### A. Bundle Identifier
```bash
# Trenutni bundle identifier
Gazza.Jump-Doodle-Jump

# Preporučeno: Promenite u jedinstveni identifier
com.yourname.trisolarisjump
```

#### B. App Store Connect Setup
1. Idite na [App Store Connect](https://appstoreconnect.apple.com)
2. Kliknite **"My Apps"**
3. Kliknite **"+"** → **"New App"**
4. Popunite informacije:
   - **Platform:** iOS
   - **Name:** Trisolaris Jump
   - **Primary language:** English
   - **Bundle ID:** com.yourname.trisolarisjump
   - **SKU:** trisolarisjump2025
   - **User Access:** Full Access

### 2. Xcode konfiguracija

#### A. Signing & Capabilities
1. Otvorite Xcode projekat
2. Izaberite **"Jump Doodle Jump"** target
3. Idite na **"Signing & Capabilities"** tab
4. Konfigurišite:
   - **Team:** Vaš Apple Developer Team
   - **Bundle Identifier:** com.yourname.trisolarisjump
   - **Automatically manage signing:** ✅

#### B. Info.plist ažuriranje
```xml
<key>CFBundleDisplayName</key>
<string>Trisolaris Jump</string>
<key>CFBundleVersion</key>
<string>1.0</string>
<key>CFBundleShortVersionString</key>
<string>1.0</string>
<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>accelerometer</string>
</array>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
```

### 3. Build i Archive

#### A. Build Settings
1. **Deployment Target:** iOS 15.0
2. **Build Configuration:** Release
3. **Code Signing:** Automatic

#### B. Archive proces
```bash
# U Xcode-u:
1. Product → Archive
2. Čekajte da se završi build
3. Organizer će se otvoriti automatski
4. Izaberite najnoviji archive
5. Kliknite "Distribute App"
6. Izaberite "App Store Connect"
7. Kliknite "Next" kroz sve korake
8. Upload-ujte na App Store Connect
```

### 4. App Store Connect konfiguracija

#### A. App Information
1. **App Information** tab:
   - **Name:** Trisolaris Jump
   - **Subtitle:** Kosmička platformer igra
   - **Keywords:** game,platformer,space,cosmic,jump
   - **Description:** 
   ```
   Trisolaris Jump je akciona platformer igra gde kontrolišete Trisolaris - 
   kosmičko biće sa tri tela koje skače kroz svemir, izbegava neprijatelje 
   i sakuplja zvezdice.
   
   🌟 Karakteristike:
   • Tri jedinstvene teme (Monochrome, Pixel Art, Luxury, Wired)
   • Power-up sistemi (Jetpack, Spring, Shield)
   • Kosmički vizuelni efekti i čestice
   • Atmosferska pozadinska muzika
   • Kontrola naginjanjem telefona
   
   🎮 Kontrole:
   • Naginjanje levo/desno za kretanje
   • Tap za pucanje projektila
   • Automatsko skakanje na platforme
   
   🏆 Sistem bodovanja:
   • Poeni za visinu skakanja
   • Bonus poeni za sakupljanje zvezdica
   • Najbolji skor se čuva automatski
   ```

#### B. Screenshots
Potrebne veličine:
- **iPhone 6.7" Display:** 1290 x 2796
- **iPhone 6.5" Display:** 1242 x 2688
- **iPhone 5.5" Display:** 1242 x 2208
- **iPad Pro 12.9" Display:** 2048 x 2732
- **iPad Pro 11" Display:** 1668 x 2388

#### C. App Icon
- **1024x1024** PNG (već generisana)

### 5. TestFlight konfiguracija

#### A. Internal Testing
1. **TestFlight** tab u App Store Connect
2. **Internal Testing** sekcija
3. **Add Build** → izaberite vaš build
4. **Add Testers** → dodajte sebe
5. **Test Information:**
   ```
   What to Test:
   - Osnovna mehanika skakanja
   - Kontrola naginjanjem
   - Power-up sistemi (Jetpack, Spring, Shield)
   - Različite teme (Monochrome, Pixel Art, Luxury, Wired)
   - Audio efekti i muzika
   - Sistem bodovanja
   - Čestice i vizuelni efekti
   - Kolizije sa neprijateljima
   - Sakupljanje zvezdica
   - Pause/Resume funkcionalnost
   
   Known Issues:
   - Nema poznatih problema
   
   Notes:
   - Igra zahteva accelerometer za kontrolu
   - Preporučeno igranje u portrait modu
   - Testirajte na različitim iPhone/iPad modelima
   ```

#### B. External Testing
1. **External Testing** sekcija
2. **Add Build** → izaberite vaš build
3. **Add Testers** → dodajte email adrese prijatelja
4. **Test Information** (isto kao gore)
5. **Submit for Review** → Apple će pregledati

### 6. Invite prijatelje

#### A. Email template za prijatelje
```
Subject: Testiraj Trisolaris Jump - Nova kosmička igra! 🚀

Pozdrav!

Pozivam te da testiraš moju novu igru Trisolaris Jump!

🎮 O igri:
Trisolaris Jump je akciona platformer igra gde kontrolišete kosmičko biće 
sa tri tela koje skače kroz svemir. Igra ima 4 jedinstvene teme, power-up 
sisteme i kosmičke efekte.

📱 Kako testirati:
1. Instaliraj TestFlight aplikaciju sa App Store-a
2. Klikni na link koji ćeš dobiti u sledećem email-u
3. Prihvati poziv za testiranje
4. Instaliraj Trisolaris Jump
5. Igraj i javi mi feedback!

🎯 Šta testirati:
- Osnovna mehanika skakanja
- Kontrola naginjanjem telefona
- Power-up sistemi
- Različite teme
- Audio efekti
- Sistem bodovanja

Hvala na pomoći! 🚀

Pozdrav,
[Vaše ime]
```

## 🚨 Česti problemi i rešenja

### Problem: "No provisioning profiles found"
**Rešenje:**
1. Xcode → Preferences → Accounts
2. Dodajte Apple ID
3. Download Manual Profiles
4. Uključite "Automatically manage signing"

### Problem: "Archive failed"
**Rešenje:**
1. Clean Build Folder (Cmd+Shift+K)
2. Clean Build (Cmd+K)
3. Proverite da li su svi fajlovi dodati u target
4. Proverite bundle identifier

### Problem: "Upload failed"
**Rešenje:**
1. Proverite internet konekciju
2. Pokušajte ponovo
3. Proverite da li je build "Ready to Submit"

### Problem: "App Store Connect can't find build"
**Rešenje:**
1. Sačekajte 5-10 minuta
2. Refresh App Store Connect
3. Proverite da li je upload uspešan

## 📊 TestFlight Analytics

### Pratite:
- **Installs:** Koliko ljudi je instaliralo
- **Sessions:** Koliko puta se igraju
- **Crashes:** Greške u igri
- **Feedback:** Komentari testirača

### Korisni linkovi:
- [App Store Connect](https://appstoreconnect.apple.com)
- [TestFlight Guidelines](https://developer.apple.com/testflight/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## 🎯 Checklist pre objavljivanja

- [ ] Bundle identifier je jedinstven
- [ ] App icon je dodata (1024x1024)
- [ ] Screenshots su dodate
- [ ] App description je napisana
- [ ] Keywords su dodati
- [ ] Build je uspešno upload-ovan
- [ ] Internal testing je aktivan
- [ ] Testers su dodati
- [ ] Test information je napisana

## 🚀 Nakon TestFlight-a

### Feedback od prijatelja:
1. **Gameplay:** Da li je zabavna
2. **Kontrole:** Da li su intuitivne
3. **Teme:** Koja im se najviše sviđa
4. **Težina:** Da li je balansirana
5. **Bugs:** Greške koje su pronašli

### Poboljšanja:
1. Fiksirajte greške
2. Dodajte nove funkcionalnosti
3. Optimizujte performanse
4. Dodajte nove teme
5. Poboljšajte audio

---

**Napomena:** TestFlight je besplatan i omogućava testiranje sa do 10,000 testirača. Koristite ga za feedback pre objavljivanja na App Store! 