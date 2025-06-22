#!/bin/bash

# Skripta za automatsko setup TestFlight-a za Trisolaris Jump
echo "🚀 Trisolaris Jump - TestFlight Setup"
echo "======================================"

# Kreiraj direktorijume
echo "📁 Kreiranje direktorijuma..."
mkdir -p screenshots
mkdir -p testflight_assets

# Proveri da li je Python instaliran
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 nije instaliran. Instalirajte Python3 prvo."
    exit 1
fi

# Proveri da li je Pillow instaliran
echo "🔍 Provera Pillow biblioteke..."
python3 -c "import PIL" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "📦 Instaliranje Pillow..."
    python3 -m venv testflight_env
    source testflight_env/bin/activate
    pip install Pillow
else
    echo "✅ Pillow je već instaliran"
fi

# Generisanje ikonica
echo "🎨 Generisanje ikonica..."
if [ -d "testflight_env" ]; then
    source testflight_env/bin/activate
fi
python3 create_icon.py
python3 create_additional_icons.py

# Kopiranje ikonica
echo "📋 Kopiranje ikonica..."
./copy_icons.sh

# Generisanje screenshot-a
echo "📱 Generisanje screenshot-a..."
python3 generate_screenshots.py

# Kreiranje App Store Connect fajlova
echo "📝 Kreiranje App Store Connect fajlova..."

# App description
cat > testflight_assets/app_description.txt << 'EOF'
Trisolaris Jump je akciona platformer igra gde kontrolišete Trisolaris - kosmičko biće sa tri tela koje skače kroz svemir, izbegava neprijatelje i sakuplja zvezdice.

🌟 Karakteristike:
• Četiri jedinstvene teme (Monochrome, Pixel Art, Luxury, Wired)
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

🎨 Teme:
• Monochrome: Elegantna crno-bela tema
• Pixel Art: Retro piksel stil
• Luxury: Premium zlatno-crna tema
• Wired: Cyberpunk neon tema

⚡ Power-up-ovi:
• Jetpack: 2 sekunde leta sa imunosti
• Spring: Duplo jači skok
• Shield: 5 sekundi zaštite

Igrajte Trisolaris Jump i istražite kosmičke tajne!
EOF

# Keywords
cat > testflight_assets/keywords.txt << 'EOF'
game,platformer,space,cosmic,jump,arcade,action,adventure,indie,retro,pixel,cyberpunk,neon,particles,physics,gravity,jetpack,powerup,collectible,score,leaderboard,atmospheric,music,effects,stars,galaxy,universe,alien,creature,three,body,problem,inspired
EOF

# Test information
cat > testflight_assets/test_information.txt << 'EOF'
What to Test:
- Osnovna mehanika skakanja
- Kontrola naginjanjem telefona
- Power-up sistemi (Jetpack, Spring, Shield)
- Različite teme (Monochrome, Pixel Art, Luxury, Wired)
- Audio efekti i pozadinska muzika
- Sistem bodovanja i najbolji skor
- Čestice i vizuelni efekti
- Kolizije sa neprijateljima
- Sakupljanje zvezdica
- Pause/Resume funkcionalnost
- Game Over i restart
- Toggle zvuka
- Promena tema

Known Issues:
- Nema poznatih problema

Notes:
- Igra zahteva accelerometer za kontrolu
- Preporučeno igranje u portrait modu
- Testirajte na različitim iPhone/iPad modelima
- Power-up-ovi se aktiviraju skakanjem na platforme
- Jetpack daje imunost na neprijatelje
- Štit štiti od jednog sudara sa neprijateljem
EOF

# Email template za testirače
cat > testflight_assets/email_template.txt << 'EOF'
Subject: Testiraj Trisolaris Jump - Nova kosmička igra! 🚀

Pozdrav!

Pozivam te da testiraš moju novu igru Trisolaris Jump!

🎮 O igri:
Trisolaris Jump je akciona platformer igra gde kontrolišete kosmičko biće sa tri tela koje skače kroz svemir. Igra ima 4 jedinstvene teme, power-up sisteme i kosmičke efekte.

📱 Kako testirati:
1. Instaliraj TestFlight aplikaciju sa App Store-a
2. Klikni na link koji ćeš dobiti u sledećem email-u
3. Prihvati poziv za testiranje
4. Instaliraj Trisolaris Jump
5. Igraj i javi mi feedback!

🎯 Šta testirati:
- Osnovna mehanika skakanja
- Kontrola naginjanjem telefona
- Power-up sistemi (Jetpack, Spring, Shield)
- Različite teme (Monochrome, Pixel Art, Luxury, Wired)
- Audio efekti i muzika
- Sistem bodovanja
- Čestice i vizuelni efekti
- Kolizije sa neprijateljima
- Sakupljanje zvezdica

🚀 Kontrole:
- Naginjanje levo/desno za kretanje
- Tap za pucanje projektila
- Automatsko skakanje na platforme

Hvala na pomoći! 🚀

Pozdrav,
[Vaše ime]
EOF

# Checklist
cat > testflight_assets/checklist.txt << 'EOF'
TestFlight Setup Checklist:
==========================

Pre objavljivanja:
□ Apple Developer Program članstvo ($99/godišnje)
□ Xcode 15.0+ instaliran
□ App Store Connect pristup

Xcode konfiguracija:
□ Bundle identifier promenjen u jedinstveni
□ Team izabran u Signing & Capabilities
□ Automatically manage signing uključen
□ Deployment target postavljen na iOS 15.0
□ App icon dodata (1024x1024)

App Store Connect:
□ Nova aplikacija kreirana
□ App information popunjeno
□ Screenshots upload-ovani
□ App description dodata
□ Keywords dodati

TestFlight:
□ Build uspešno upload-ovan
□ Internal testing aktivan
□ Testers dodati
□ Test information napisana
□ External testing submit-ovan za review

Nakon TestFlight-a:
□ Feedback od testirača
□ Bug fixes implementirani
□ Poboljšanja dodana
□ Final build upload-ovan
□ App Store submission
EOF

# Kreiranje README za TestFlight
cat > testflight_assets/README.md << 'EOF'
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
EOF

echo ""
echo "✅ TestFlight setup završen!"
echo ""
echo "📋 Sledeći koraci:"
echo "1. Otvorite Xcode i konfigurišite signing"
echo "2. Idite na App Store Connect i kreirajte novu aplikaciju"
echo "3. Upload-ujte build u App Store Connect"
echo "4. Dodajte screenshot-ove iz screenshots/ foldera"
echo "5. Konfigurišite TestFlight sa fajlovima iz testflight_assets/"
echo ""
echo "📁 Generisani fajlovi:"
echo "- screenshots/ - Screenshot-ovi za različite uređaje"
echo "- testflight_assets/ - Fajlovi za App Store Connect"
echo "- icons/ - Sve ikonice za različite uređaje"
echo ""
echo "📖 Detaljna uputstva: TESTFLIGHT_SETUP.md"
echo ""

# Očisti privremene fajlove
if [ -d "testflight_env" ]; then
    rm -rf testflight_env
fi

echo "🚀 Srećno sa TestFlight-om!" 