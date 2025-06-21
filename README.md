# 🚀 Trisolaris Jump

**Kosmička platformer igra inspirisana "The Three-Body Problem" serijom**

![Trisolaris Jump](https://img.shields.io/badge/Platform-iOS-blue) ![Swift](https://img.shields.io/badge/Swift-5.0-orange) ![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0-green)

## 🌟 O igri

Trisolaris Jump je zabavna platformer igra gde kontrolišete Trisolaris - kosmičko biće sa tri tela (X, trougao, kvadrat) koje skače po platformama u beskonačnom svemiru. Igra kombinije fizičku mehaniku skakanja sa kosmičkim temama i dinamičkim power-up sistemom.

### 🎮 Glavni lik
- **Trisolaris:** Kosmičko biće sa tri tela u obliku X, trougla i kvadrata
- **Srebrni rep:** Magični rep od zvezdane prašine koji ostavlja trag
- **Rotacija:** Kontinuirana rotacija za kosmički efekat

## ✨ Funkcionalnosti

### 🎯 Osnovna mehanika
- **Skakanje:** Fizički realistično skakanje sa gravitacijom
- **Kretanje:** Kontrola naginjanjem telefona levo/desno
- **Pucanje:** Tap na ekran za pucanje projektila
- **Kolizije:** Detekcija sudara sa platformama i neprijateljima

### 🏗️ Platforme
- **Normalne platforme:** Osnovne platforme za skakanje
- **Pokretne platforme:** Platforme koje se kreću levo-desno
- **Polomljive platforme:** Nestaju posle skoka
- **Dinamička težina:** Platforme se smanjuju sa povećanjem skora

### ⚡ Power-up sistemi
- **Jetpack:** 3 sekunde letenja sa česticama
- **Spring:** Duplo jači skok
- **Shield:** 5 sekundi zaštite od neprijatelja

### 🐛 Neprijatelji i prepreke
- **Neprijatelji:** Ladybug neprijatelji na platformama
- **Progresivna težina:** 1-3% šanse za neprijatelje (0-30,000 poena)
- **Pucanje:** Možete pucati u neprijatelje za bonus poene

### 🎨 Vizuelni efekti
- **Čestice:** Jetpack trail i jump efekti
- **Zvezdana prašina:** Magični rep Trisolaris-a
- **Eksplozije:** Vizuelni efekti za uništavanje neprijatelja
- **Teme:** Colorful i Monochrome teme

### 🎵 Audio sistem
- **Pozadinska muzika:** Kosmička atmosfera
- **Zvučni efekti:** Jump, power-up, collision zvukovi
- **Toggle:** Uključivanje/isključivanje zvuka

## 🎮 Kontrole

### 📱 Osnovne kontrole
- **Naginjanje:** Levo/desno za kretanje
- **Tap:** Pucanje projektila
- **Pause:** Pause dugme za pauziranje

### 🎯 Power-up kontrole
- **Jetpack:** Automatska kontrola dok je aktivan
- **Shield:** Automatska zaštita od neprijatelja
- **Spring:** Automatski jači skok

## 🏆 Sistem bodovanja

### 📊 Poeni
- **Skakanje:** 1 poen na 10 piksela visine
- **Collectibles:** 25 poena po zvezdici
- **Neprijatelji:** 50 poena po uništenom neprijatelju

### 🏅 Najbolji skor
- **Local storage:** Automatsko čuvanje najboljeg skora
- **Persistent:** Skor se čuva između sesija

## 🎨 Teme

### 🌈 Colorful tema
- **Boje:** Žive kosmičke boje
- **Gradijenti:** Višebojni pozadinski gradijenti
- **Čestice:** Oranžne i crvene čestice

### ⚪ Monochrome tema
- **Boje:** Srebrne i bele nijanse
- **Gradijenti:** Crno-beli pozadinski gradijenti
- **Rep:** Srebrna zvezdana prašina

## 🛠️ Instalacija

### 📋 Preduslovi
- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

### 🔧 Koraci instalacije
1. Klonirajte repository:
```bash
git clone https://github.com/sgazz/Trisolaris-jump.git
```

2. Otvorite projekat u Xcode:
```bash
cd Trisolaris-jump
open "Jump Doodle Jump.xcodeproj"
```

3. Izaberite target device ili simulator

4. Pritisnite `Cmd + R` za pokretanje

## 🎯 Tehnologije

### 📱 Platforma
- **iOS:** Native iOS aplikacija
- **SwiftUI:** Modern UI framework
- **Core Motion:** Senzori za kretanje

### 🎮 Game Engine
- **Custom Engine:** Proprijetarni game engine
- **Timer-based:** 60 FPS game loop
- **Physics:** Custom fizika za skakanje

### 🎵 Audio
- **AVFoundation:** Audio playback
- **Background Music:** Loop pozadinska muzika
- **Sound Effects:** Multiple audio players

## 🚀 Performanse

### ⚡ Optimizacije
- **Čestice:** Ograničen broj čestica (50 max)
- **Zvezdana prašina:** Ograničen broj (30 max)
- **Frame rate:** 60 FPS optimizacija
- **Memory management:** Automatsko čišćenje

### 📊 Statistike
- **Platforme:** Dinamičko generisanje
- **Neprijatelji:** 1-3% frekvencija
- **Power-ups:** 15% šansa po platformi

## 🎮 Gameplay tips

### 💡 Strategije
1. **Koristite power-up-ove:** Jetpack za teške situacije
2. **Sakupljajte zvezdice:** Bonus poeni za visok skor
3. **Pucajte u neprijatelje:** 50 bonus poena
4. **Izbegavajte polomljive platforme:** Mogu vas pokolebati

### 🏆 Za visok skor
- Fokusirajte se na sakupljanje collectibles
- Koristite shield za sigurno uništavanje neprijatelja
- Pratite pokretne platforme
- Sačuvajte jetpack za kritične situacije

## 🔧 Razvoj

### 📁 Struktura projekta
```
Jump Doodle Jump/
├── ContentView.swift          # Glavna igra
├── Jump_Doodle_JumpApp.swift  # App entry point
├── Assets.xcassets/          # Resursi
└── README.md                 # Dokumentacija
```

### 🎯 Glavne komponente
- **ContentView:** Glavna game view
- **Theme system:** Teme i boje
- **Particle system:** Čestice i efekti
- **Audio system:** Zvukovi i muzika
- **Physics engine:** Fizika skakanja

## 🤝 Doprinosi

Dobrodošli su svi doprinosi! Molimo vas da:

1. Fork-ujte projekat
2. Kreirajte feature granu (`git checkout -b feature/AmazingFeature`)
3. Commit-ujte promene (`git commit -m 'Add AmazingFeature'`)
4. Push-ujte granu (`git push origin feature/AmazingFeature`)
5. Otvorite Pull Request

## 📄 Licenca

Ovaj projekat je pod [MIT License](LICENSE) licencom.

## 👨‍💻 Autor

**Gazza** - [GitHub](https://github.com/sgazz)

## 🙏 Zahvalnice

- Inspirisano "The Three-Body Problem" serijom
- Kosmičke teme i koncepti
- SwiftUI i iOS development community

---

⭐ **Ako vam se sviđa projekat, ostavite zvezdicu!** ⭐ 