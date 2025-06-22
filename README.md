# 🚀 Trisolaris Jump

**Kosmička platformer igra inspirisana "The Three-Body Problem"**

## 🎮 O igri

Trisolaris Jump je akciona platformer igra gde kontrolišete Trisolaris - kosmičko biće sa tri tela (X, ▲, ■) koje skače kroz svemir, izbegava neprijatelje i sakuplja zvezdice. Igra kombinuje klasičnu mehaniku skakanja sa modernim vizuelnim efektima i kosmičkom temom.

## 🌟 Glavne karakteristike

### 🎯 Trisolaris lik
- **Tri tela:** Sivi krug sa X, crveni krug sa trouglom, zeleni krug sa kvadratom
- **Zvezdana prašina:** Efektni rep od čestica koji prati Trisolaris
- **Rotacija:** Kontinuirana rotacija za dinamičan izgled
- **Štit:** Orbitalna planeta Y koja štiti od neprijatelja

### 🎨 Teme
- **Monochrome:** Elegantna crno-bela tema sa srebrnim efektima
- **Pixel Art:** Retro piksel stil sa živim bojama
- **Luxury:** Premium zlatno-crna tema sa luksuznim efektima
- **Wired:** Cyberpunk neon tema sa scanlines i tehno efektima

### ⚡ Power-up sistem
- **Jetpack:** 2 sekunde leta sa imunosti na neprijatelje
- **Spring:** Duplo jači skok
- **Shield:** 5 sekundi zaštite od neprijatelja

### 🎵 Audio i vizuelni efekti
- **Pozadinska muzika:** Atmosferska kosmička muzika
- **Zvučni efekti:** Skok, sakupljanje, power-up, sudar
- **Čestice:** Eksplozije, jetpack trail, zvezdana prašina
- **Animacije:** Glatke tranzicije i efekti

## 🎮 Kontrole

- **Naginjanje:** Pomeranje levo/desno
- **Tap:** Pucanje projektila
- **Automatsko skakanje:** Pri skoku na platforme
- **Pause:** Pritisnite pauzu za meni

## 🏆 Sistem bodovanja

- **Visina:** 1 poen na 10 piksela visine
- **Zvezdice:** +25 poena po sakupljenoj zvezdici
- **Neprijatelji:** +50 poena po uništenom neprijatelju
- **Najbolji skor:** Automatsko čuvanje

## 🎨 Kompletno sistem ikonica

Ikonicu Trisolaris Jump je optimizovana za sve iOS uređaje i kontekste:

### 📱 iPhone ikonice
- **20x20, 29x29, 40x40, 60x60, 76x76** - App Icon (2x, 3x)
- **1024x1024** - App Store

### 📱 iPad ikonice
- **20x20, 29x29, 40x40, 76x76** - App Icon (1x, 2x)
- **1024x1024** - App Store

### 🔍 Spotlight ikonice
- **40x40, 58x58, 80x80, 120x120** - Spotlight search

### ⚙️ Settings ikonice
- **29x29, 58x58, 87x87** - Settings app

### 🔔 Notification ikonice
- **20x20, 40x40, 60x60** - Notification center

### 🎨 Dizajn ikonice
- **Trisolaris:** Tri kruga sa simbolima X, ▲, ■
- **Kosmička pozadina:** Crno-plavi gradijent sa zvezdama
- **Zvezdana prašina:** Cijan rep iza Trisolaris-a
- **Platforma:** Zelena platforma na dnu
- **Kosmički efekti:** Elipse u pozadini

### 🛠️ Generisanje ikonica
Sve ikonice su automatski generisane koristeći:
- `create_icon.py` - Python generator za glavne ikonice
- `create_additional_icons.py` - Python generator za dodatne ikonice
- `copy_icons.sh` - Bash skripta za kopiranje
- `IconGenerator.swift` - SwiftUI generator
- `trisolaris_icon.svg` - SVG verzija

## 🚀 TestFlight Setup

Trisolaris Jump je spreman za TestFlight testiranje! Svi potrebni fajlovi su automatski generisani:

### 📱 Screenshot-ovi
- **iPhone 6.7" Display:** 1290 x 2796 (iPhone 14/15 Pro Max)
- **iPhone 6.5" Display:** 1242 x 2688 (iPhone 11/12/13 Pro Max)
- **iPhone 5.5" Display:** 1242 x 2208 (iPhone 8 Plus)
- **iPad Pro 12.9" Display:** 2048 x 2732 (iPad Pro 12.9")
- **iPad Pro 11" Display:** 1668 x 2388 (iPad Pro 11")

### 📋 App Store Connect fajlovi
- `app_description.txt` - App Store opis
- `keywords.txt` - Ključne reči za pretragu
- `test_information.txt` - TestFlight test informacije
- `email_template.txt` - Email template za testirače
- `checklist.txt` - Checklist pre objavljivanja

### 🛠️ Automatski setup
```bash
# Pokrenite automatski setup
./setup_testflight.sh

# Ili ručno generisanje
python3 create_icon.py
python3 create_additional_icons.py
python3 generate_screenshots.py
./copy_icons.sh
```

### 📖 Detaljna uputstva
- `TESTFLIGHT_SETUP.md` - Kompletna dokumentacija
- `testflight_assets/README.md` - Uputstva za TestFlight

## 🛠️ Tehnologije

- **SwiftUI:** Moderna iOS UI framework
- **Core Motion:** Senzori za naginjanje
- **AVFoundation:** Audio reprodukcija
- **SpriteKit:** Čestice i animacije
- **UserDefaults:** Čuvanje skorova i podešavanja

## 📱 Kompatibilnost

- **iOS:** 15.0+
- **Uređaji:** iPhone, iPad (sve generacije)
- **Orijentacija:** Portrait
- **Senzori:** Accelerometer (naginjanje)

## 🎯 Saveti za igru

1. **Koristite jetpack pametno:** Sačuvajte ga za opasne situacije
2. **Sakupljajte zvezdice:** Daju bonus poene
3. **Pucajte na neprijatelje:** Uništavajte ih pre nego što vas dotaknu
4. **Pratite platforme:** Različite tipove platformi
5. **Koristite štit:** Aktivirajte ga kada vidite neprijatelje

## 🚀 Razvoj

### Struktura projekta
```
Jump Doodle Jump/
├── ContentView.swift          # Glavna igra
├── ThemeManager.swift         # Upravljanje temama
├── Assets.xcassets/          # Resursi
│   └── AppIcon.appiconset/   # Kompletno sistem ikonica
│       ├── AppIcon.png       # Glavna ikonica
│       ├── iPhone_*.png      # iPhone ikonice
│       ├── iPad_*.png        # iPad ikonice
│       ├── Spotlight_*.png   # Spotlight ikonice
│       ├── Settings_*.png    # Settings ikonice
│       └── Notification_*.png # Notification ikonice
├── create_icon.py            # Generator glavnih ikonica
├── create_additional_icons.py # Generator dodatnih ikonica
├── generate_screenshots.py   # Generator screenshot-a
├── copy_icons.sh             # Skripta za kopiranje
├── setup_testflight.sh       # Automatski TestFlight setup
├── IconGenerator.swift       # SwiftUI generator
├── trisolaris_icon.svg       # SVG ikonica
├── screenshots/              # Screenshot-ovi za TestFlight
├── testflight_assets/        # App Store Connect fajlovi
└── README.md                 # Dokumentacija
```

### Dodavanje novih tema
1. Dodajte novu temu u `ThemeManager.swift`
2. Definišite boje i efekte
3. Testirajte na različitim uređajima

### Optimizacija performansi
- Ograničen broj čestica (50 max)
- Optimizovana zvezdana prašina (30 max)
- Efikasno ažuriranje čestica

### Generisanje ikonica
```bash
# Kompletno generisanje svih ikonica
python3 -m venv icon_env
source icon_env/bin/activate
pip install Pillow
python create_icon.py
python create_additional_icons.py
./copy_icons.sh
```

### TestFlight setup
```bash
# Automatski setup za TestFlight
./setup_testflight.sh

# Ručno generisanje screenshot-a
python3 generate_screenshots.py
```

## 📄 Licenca

Ovaj projekat je kreiran za edukaciju i zabavu. Slobodno koristite i modifikujte prema potrebi.

## 🤝 Doprinosi

Dobrodošli su svi predlozi za poboljšanja:
- Nove teme
- Dodatni power-up-ovi
- Nove mehanike
- Optimizacije performansi
- Poboljšanja ikonica
- TestFlight feedback

---

**Napomena:** Igra je inspirisana "The Three-Body Problem" trilogijom Liu Cixina, ali nije povezana sa zvaničnim proizvodima. 