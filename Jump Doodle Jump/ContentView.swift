//
//  ContentView.swift
//  Jump Doodle Jump
//
//  Created by Gazza on 20. 6. 2025..
//

import SwiftUI
import CoreMotion
import AVFoundation

// Enum za tipove Power-up-ova
enum PowerUpType: String {
    case jetpack
    case spring
    case shield // Novi power-up
}

// Enum za tipove platformi
enum PlatformType {
    case normal
    case breakable // Nestaje posle skoka
    case moving    // Kreće se levo-desno
}

// Struktura za Neprijatelje
struct Enemy {
    let id = UUID()
}

// Struktura za čestice (Particles)
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var creationDate = Date()
}

// Struktura za zvezdanu prašinu (Star Dust)
struct StarDust: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var velocity: CGPoint
    var creationDate = Date()
}

// Struktura za Projektile
struct Projectile: Identifiable {
    let id = UUID()
    var position: CGPoint
}

// Struktura za Sakupljanje (Collectibles)
struct Collectible: Identifiable {
    let id = UUID()
    var position: CGPoint
}

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    
    @State private var playerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
    @State private var playerVelocity: CGFloat = 0
    @State private var platforms: [Platform] = []
    @State private var gameTimer: Timer?
    @State private var isGameActive = false
    @State private var rotationAngle: Double = 0
    @State private var score: Int = 0
    @State private var motionManager = CMMotionManager()
    @State private var tiltX: Double = 0
    @State private var totalScroll: CGFloat = 0 // Za precizno praćenje visine
    
    // Stanja za kraj igre i najbolji skor
    @State private var isGameOverScreenShowing = false
    @State private var highScore = 0
    @State private var isPaused = false
    @State private var isSoundEnabled = true
    
    // Audio Player
    @State private var audioPlayers: [AVAudioPlayer] = []
    @State private var backgroundMusicPlayer: AVAudioPlayer?
    
    // Power-up stanja
    @State private var isJetpackActive = false
    @State private var jetpackFuel: TimeInterval = 0
    
    // Stanje za štit
    @State private var isShieldActive = false
    @State private var shieldTime: TimeInterval = 0
    
    // Stanje za čestice i projektile
    @State private var particles: [Particle] = []
    @State private var projectiles: [Projectile] = []
    @State private var collectibles: [Collectible] = []
    @State private var starDust: [StarDust] = [] // Nova zvezdana prašina
    
    let gravity: CGFloat = 0.8
    let jumpForce: CGFloat = -20
    let moveSpeed: CGFloat = 8
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Konstante za težinu
    let basePlatformWidth: CGFloat = 120
    let minPlatformWidth: CGFloat = 70
    
    let baseEnemyChance: Double = 1 // u % - Smanjeno prema predlogu
    let maxEnemyChance: Double = 3  // Smanjeno sa 10 na 3%
    
    let baseSpecialPlatformChance: Double = 5
    let maxSpecialPlatformChance: Double = 20
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: themeManager.currentTheme.backgroundGradient), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Wired efekti - scanlines i tehno pozadina
            if themeManager.selectedThemeType == .wired {
                // Scanlines efekat
                VStack(spacing: 2) {
                    ForEach(0..<Int(screenHeight / 4), id: \.self) { _ in
                        Rectangle()
                            .fill(Color(red: 0.0, green: 1.0, blue: 0.5).opacity(0.1))
                            .frame(height: 1)
                    }
                }
                
                // Tehno grid pozadina
                VStack(spacing: 20) {
                    ForEach(0..<Int(screenHeight / 20), id: \.self) { _ in
                        HStack(spacing: 20) {
                            ForEach(0..<Int(screenWidth / 20), id: \.self) { _ in
                                Rectangle()
                                    .fill(Color(red: 0.0, green: 1.0, blue: 0.5).opacity(0.05))
                                    .frame(width: 1, height: 1)
                            }
                        }
                    }
                }
            }
            
            // Zvezde u pozadini
            ForEach(0..<50, id: \.self) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...screenWidth),
                        y: CGFloat.random(in: 0...screenHeight)
                    )
                    .opacity(Double.random(in: 0.3...1.0))
            }
            
            // Čestice (Particles) - crtaju se iza svega ostalog
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.opacity < 0.5 ? themeManager.currentTheme.particleExplosion : themeManager.currentTheme.particleJetpack)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
            
            // Zvezdana prašina (Star Dust) - rep Trisolaris-a
            ForEach(starDust) { dust in
                Circle()
                    .fill(themeManager.selectedThemeType == .monochrome ? Color(white: 0.8).opacity(0.6) : themeManager.currentTheme.accent.opacity(0.6))
                    .frame(width: dust.size, height: dust.size)
                    .position(dust.position)
                    .opacity(dust.opacity)
                    .blur(radius: 1)
            }
            
            // Projektili
            ForEach(projectiles) { projectile in
                Capsule()
                    .fill(themeManager.currentTheme.projectile)
                    .frame(width: 5, height: 15)
                    .shadow(color: themeManager.currentTheme.projectile, radius: 5)
                    .position(projectile.position)
            }
            
            // Collectibles (Zvezdice)
            ForEach(collectibles) { collectible in
                Image(systemName: "star.fill")
                    .foregroundColor(themeManager.currentTheme.collectible)
                    .font(.system(size: 20))
                    .shadow(color: themeManager.currentTheme.collectible, radius: 5)
                    .position(collectible.position)
            }
            
            // Platforme
            ForEach(platforms, id: \.id) { platform in
                if !platform.isBroken { // Ne prikazuj polomljene platforme
                    ZStack {
                        Rectangle()
                            .fill(platform.color)
                            .frame(width: platform.width, height: 20)
                            .shadow(color: platform.color, radius: 8)
                            .opacity(platform.opacity) // Za efekat nestajanja
                            .overlay(
                                // Wired efekti za platforme
                                Group {
                                    if themeManager.selectedThemeType == .wired {
                                        // Neon glow
                                        Rectangle()
                                            .stroke(platform.color, lineWidth: 2)
                                            .frame(width: platform.width, height: 20)
                                            .shadow(color: platform.color, radius: 5)
                                        
                                        // Scanlines na platformi
                                        VStack(spacing: 1) {
                                            ForEach(0..<10, id: \.self) { _ in
                                                Rectangle()
                                                    .fill(platform.color.opacity(0.3))
                                                    .frame(height: 1)
                                            }
                                        }
                                        .frame(width: platform.width, height: 20)
                                    }
                                }
                            )
                        
                        // Prikaz power-up-a na platformi
                        if let powerUp = platform.powerUp {
                            switch powerUp {
                            case .jetpack:
                                Image(systemName: "flame.fill")
                                    .foregroundColor(themeManager.currentTheme.particleJetpack)
                                    .font(.title2)
                                    .shadow(color: themeManager.currentTheme.particleJetpack, radius: 10)
                            case .spring:
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                    .shadow(color: .green, radius: 10)
                            case .shield:
                                Image(systemName: "shield.fill")
                                    .foregroundColor(themeManager.currentTheme.shield)
                                    .font(.title2)
                                    .shadow(color: themeManager.currentTheme.shield, radius: 10)
                            }
                        }
                        
                        // Prikaz neprijatelja
                        if platform.enemy != nil {
                            Image(systemName: "ladybug.fill")
                                .font(.system(size: 30))
                                .foregroundColor(themeManager.currentTheme.enemy)
                                .offset(y: -25) // Postavi ga iznad platforme
                                .shadow(color: themeManager.currentTheme.enemy, radius: 5)
                        }
                    }
                    .position(platform.position)
                }
            }
            
            // Trisolaris lik sa štitom
            ZStack {
                // Četvrti krug (štit) koji se okrece oko Trisolaris-a
                if isShieldActive {
                    ZStack {
                        // Orbitalna putanja (suptilna linija)
                        Circle()
                            .stroke(themeManager.currentTheme.shield.opacity(0.2), lineWidth: 1)
                            .frame(width: 100, height: 100)
                        
                        // Mala planeta Y
                        ZStack {
                            // Glavni krug planete
                            Circle()
                                .fill(themeManager.currentTheme.shield.opacity(0.9))
                                .frame(width: 15, height: 15)
                                .shadow(color: themeManager.currentTheme.shield, radius: 3)
                            
                            // Atmosfera planete
                            Circle()
                                .stroke(themeManager.currentTheme.shield.opacity(0.4), lineWidth: 1)
                                .frame(width: 20, height: 20)
                            
                            // Y simbol na planeti
                            Text("Y")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.system(size: 8, weight: .bold))
                                .shadow(color: .black.opacity(0.3), radius: 0.5)
                        }
                        .rotationEffect(.degrees(rotationAngle * -1.2)) // Suprotna rotacija sa orbitalnim pokretom
                        .offset(x: 0, y: -50) // Pozicioniranje na orbitu
                    }
                    .rotationEffect(.degrees(rotationAngle * -0.3)) // Sporija rotacija orbite
                    .scaleEffect(isShieldActive ? 1.0 : 0.9)
                    .opacity(isShieldActive ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isShieldActive)
                }
                
                // Sivi krug sa X simbolom
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.trisolaris[0])
                        .frame(width: 30, height: 30)
                        .shadow(color: themeManager.currentTheme.trisolaris[0], radius: 8)
                        .overlay(
                            // Wired efekti za Trisolaris
                            Group {
                                if themeManager.selectedThemeType == .wired {
                                    Circle()
                                        .stroke(themeManager.currentTheme.trisolaris[0], lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .shadow(color: themeManager.currentTheme.trisolaris[0], radius: 3)
                                }
                            }
                        )
                    Text("✕")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: 18, weight: .bold))
                }
                .offset(x: 0, y: -22)

                // Crveni krug sa trouglom
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.trisolaris[1])
                        .frame(width: 30, height: 30)
                        .shadow(color: themeManager.currentTheme.trisolaris[1], radius: 8)
                        .overlay(
                            // Wired efekti za Trisolaris
                            Group {
                                if themeManager.selectedThemeType == .wired {
                                    Circle()
                                        .stroke(themeManager.currentTheme.trisolaris[1], lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .shadow(color: themeManager.currentTheme.trisolaris[1], radius: 3)
                                }
                            }
                        )
                    Text("▲")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 16, weight: .bold))
                }
                .offset(x: -19, y: 11)

                // Zeleni krug sa kvadratom
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.trisolaris[2])
                        .frame(width: 30, height: 30)
                        .shadow(color: themeManager.currentTheme.trisolaris[2], radius: 8)
                        .overlay(
                            // Wired efekti za Trisolaris
                            Group {
                                if themeManager.selectedThemeType == .wired {
                                    Circle()
                                        .stroke(themeManager.currentTheme.trisolaris[2], lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .shadow(color: themeManager.currentTheme.trisolaris[2], radius: 3)
                                }
                            }
                        )
                    Text("■")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 14, weight: .bold))
                }
                .offset(x: 19, y: 11)
            }
            .rotationEffect(.degrees(rotationAngle))
            .position(playerPosition)
            
            // --- UI IGRE ---
            if isGameActive {
                VStack {
                    HStack {
                        Text("Score: \(score)")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .shadow(color: themeManager.currentTheme.textColor, radius: 5)
                            .overlay(
                                // Wired efekti za UI
                                Group {
                                    if themeManager.selectedThemeType == .wired {
                                        Text("Score: \(score)")
                                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                                            .foregroundColor(themeManager.currentTheme.textColor.opacity(0.3))
                                            .offset(x: 1, y: 1)
                                            .blur(radius: 1)
                                    }
                                }
                            )
                        
                        Spacer()
                        
                        Button(action: pauseGame) {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                                .shadow(color: themeManager.currentTheme.textColor, radius: 5)
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            
            // --- GLAVNI MENI ---
            if !isGameActive && !isGameOverScreenShowing {
                VStack(spacing: 20) {
                    Text("TRISOLARIS JUMP")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(themeManager.currentTheme.textColor).shadow(color: themeManager.currentTheme.accent, radius: 10)
                        .overlay(
                            // Wired efekti za naslov
                            Group {
                                if themeManager.selectedThemeType == .wired {
                                    Text("TRISOLARIS JUMP")
                                        .font(.largeTitle).fontWeight(.bold).foregroundColor(themeManager.currentTheme.textColor.opacity(0.3))
                                        .offset(x: 2, y: 2)
                                        .blur(radius: 2)
                                }
                            }
                        )
                    
                    Text("High Score: \(highScore)")
                        .font(.title2).foregroundColor(themeManager.currentTheme.textColor.opacity(0.8))
                    
                    Text("Naginjajte telefon levo/desno").foregroundColor(themeManager.currentTheme.textColor).font(.title3).padding().shadow(color: themeManager.currentTheme.textColor, radius: 3)
                    
                    Button("START", action: startGame)
                        .font(.title2).foregroundColor(themeManager.currentTheme.buttonTextColor).padding().background(themeManager.currentTheme.accent.opacity(0.4)).cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(themeManager.currentTheme.accent, lineWidth: 2)).shadow(color: themeManager.currentTheme.accent, radius: 10)
                    
                    HStack(spacing: 40) {
                        Button(action: toggleSound) { Image(systemName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill").font(.title).foregroundColor(themeManager.currentTheme.textColor) }
                        Button(action: themeManager.toggleTheme) { Image(systemName: "paintbrush.fill").font(.title).foregroundColor(themeManager.currentTheme.textColor) }
                    }.padding()
                }
            }
            
            // --- PAUSE MENI ---
            if isPaused {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 30) {
                    Text("PAUSED").font(.largeTitle).fontWeight(.bold).foregroundColor(themeManager.currentTheme.textColor).shadow(color: themeManager.currentTheme.textColor, radius: 10)
                    
                    Button("RESUME", action: resumeGame)
                        .font(.title).foregroundColor(themeManager.currentTheme.textColor).padding(.horizontal, 40).padding(.vertical, 15).background(Color.green.opacity(0.8)).cornerRadius(15).shadow(color: .green, radius: 10)
                    
                    Button("QUIT", action: quitGame)
                        .font(.title).foregroundColor(themeManager.currentTheme.textColor).padding(.horizontal, 40).padding(.vertical, 15).background(Color.red.opacity(0.8)).cornerRadius(15).shadow(color: .red, radius: 10)
                }
            }
            
            // Game Over Ekran
            if isGameOverScreenShowing {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("GAME OVER")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.enemy)
                        .shadow(color: themeManager.currentTheme.enemy, radius: 10)
                    
                    Text("Score: \(score)")
                        .font(.system(size: 32, design: .monospaced))
                    
                    Text("High Score: \(highScore)")
                        .font(.system(size: 24, design: .monospaced))
                    
                    Button("RETRY") {
                        startGame()
                    }
                    .font(.title)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(15)
                    .shadow(color: .green, radius: 10)
                    .padding(.top, 20)
                }
                .foregroundColor(themeManager.currentTheme.textColor)
            }
        }
        .onTapGesture {
            if isGameActive {
                shoot()
            }
        }
        .onAppear {
            loadPreferences()
            setupInitialScene()
            playBackgroundMusic()
        }
        .onDisappear {
            stopMotionManager()
            stopBackgroundMusic()
        }
    }
    
    private func setupInitialScene() {
        platforms.removeAll()
        projectiles.removeAll()
        collectibles.removeAll()
        
        // Kreiraj početnu, široku platformu
        let startPlatform = Platform(
            position: CGPoint(x: screenWidth / 2, y: screenHeight * 0.8),
            width: 120,
            color: .green,
            type: .normal
        )
        platforms.append(startPlatform)
        
        // Postavi igrača tačno na nju
        // 30 = 20 (visina igrača od centra do stopala) + 10 (pola visine platforme)
        playerPosition = CGPoint(x: startPlatform.position.x, y: startPlatform.position.y - 30)
        
        // Generiši ostale platforme iznad
        for i in 1...15 {
            let yPos = startPlatform.position.y - CGFloat(i) * CGFloat.random(in: 80...95)
            addNewPlatform(at: yPos)
        }
        isPaused = false
    }
    
    private func startGame() {
        isGameOverScreenShowing = false
        setupInitialScene()
        isGameActive = true
        score = 0
        totalScroll = 0
        isJetpackActive = false
        jetpackFuel = 0
        isShieldActive = false
        shieldTime = 0
        particles.removeAll()
        projectiles.removeAll()
        collectibles.removeAll()
        starDust.removeAll() // Očisti zvezdanu prašinu
        jump(force: jumpForce)
        playSound(named: "jump.mp3")
        setupMotionManager()
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) { rotationAngle = 360 }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in updateGame() }
    }
    
    private func updateGame() {
        if !isGameActive || isPaused { return }

        // Ažuriranje čestica
        updateParticles()
        
        // Ažuriranje zvezdane prašine
        updateStarDust()

        // Ažuriranje štita
        if isShieldActive {
            shieldTime -= 1/60
            if shieldTime <= 0 {
                isShieldActive = false
            }
        }

        // Provera sudara sa neprijateljem
        checkEnemyCollision()
        if !isGameActive { return } // Ako je igra gotova, prekini petlju

        // Fizika
        if isJetpackActive {
            playerVelocity = -25
            jetpackFuel -= 1/60
            // Emituj čestice samo svaki 3. frame za bolju performansu
            if Int(Date().timeIntervalSince1970 * 60) % 3 == 0 {
                emitJetpackTrail()
            }
            if jetpackFuel <= 0 { isJetpackActive = false }
        } else {
            playerVelocity += gravity
        }
        
        playerPosition.y += playerVelocity
        
        // Pomeranje pokretnih platformi
        for i in platforms.indices {
            if platforms[i].type == .moving {
                platforms[i].position.x += platforms[i].velocity.x
                
                // Odbijanje od ivica ekrana
                if platforms[i].position.x - platforms[i].width / 2 < 0 || platforms[i].position.x + platforms[i].width / 2 > screenWidth {
                    platforms[i].velocity.x *= -1
                }
            }
            
            // Logika za nestajanje polomljenih platformi
            if platforms[i].isBreaking {
                platforms[i].opacity -= 0.1
                if platforms[i].opacity <= 0 {
                    platforms[i].isBroken = true
                }
            }
        }
        
        // Kretanje levo-desno pomoću naginjanja
        let moveDirection = Double(tiltX) * 2.0 // Povećavam senzitivnost
        playerPosition.x += CGFloat(moveDirection) * moveSpeed
        
        // Provera kolizije sa platformama
        checkPlatformCollisions()
        
        // Provera granica ekrana
        if playerPosition.x < 0 {
            playerPosition.x = screenWidth
        } else if playerPosition.x > screenWidth {
            playerPosition.x = 0
        }
        
        // Provera pada
        if playerPosition.y > screenHeight + 100 {
            gameOver()
        }
        
        // Pomeranje platformi i dodavanje novih
        if playerPosition.y < screenHeight * 0.4 {
            let yOffset = screenHeight * 0.4 - playerPosition.y
            playerPosition.y += yOffset
            totalScroll += yOffset // Ažuriraj ukupnu pređenu visinu
            
            for i in platforms.indices {
                platforms[i].position.y += yOffset
            }
            
            // Uklanjanje platformi koje su izašle sa ekrana
            platforms.removeAll { $0.position.y > screenHeight + 50 }
            
            // Dodavanje novih platformi na vrhu
            if let highestPlatformY = platforms.map({ $0.position.y }).min() {
                while highestPlatformY > -50 {
                    addNewPlatform(at: highestPlatformY - 80)
                    break // Dodaj jednu po jednu da ne pretrpamo
                }
            }
        }
        
        // Provera sakupljanja
        checkCollectibles()
        
        // Ažuriranje skora na osnovu visine
        score = Int(totalScroll / 10)
    }
    
    private func jump(force: CGFloat) {
        playerVelocity = force
    }
    
    private func checkPlatformCollisions() {
        for i in platforms.indices {
            let platform = platforms[i]
            if playerPosition.y + 20 >= platform.position.y - 10 &&
               playerPosition.y + 20 <= platform.position.y + 10 &&
               playerPosition.x >= platform.position.x - platform.width/2 &&
               playerPosition.x <= platform.position.x + platform.width/2 &&
               playerVelocity > 0 && !platforms[i].isBroken {
                
                emitJumpParticles(at: CGPoint(x: playerPosition.x, y: playerPosition.y + 25))
                
                if let powerUp = platform.powerUp {
                    activatePowerUp(powerUp)
                    platforms[i].powerUp = nil
                } else if platforms[i].type == .breakable {
                    platforms[i].isBreaking = true
                    playSound(named: "break.mp3")
                    jump(force: jumpForce)
                } else {
                    playSound(named: "jump.mp3")
                    jump(force: jumpForce)
                }
                
                playerPosition.y = platform.position.y - 20
                break
            }
        }
    }
    
    private func checkEnemyCollision() {
        for i in platforms.indices {
            if platforms[i].enemy != nil {
                let enemyPosition = CGPoint(x: platforms[i].position.x, y: platforms[i].position.y - 25)
                let distance = hypot(playerPosition.x - enemyPosition.x, playerPosition.y - enemyPosition.y)

                if distance < 45 {
                    // Trisolaris je imun na neprijatelje kada je jetpack aktivan
                    if isJetpackActive {
                        // Uništi neprijatelja bez gubljenja jetpack-a
                        emitExplosion(at: enemyPosition)
                        playSound(named: "enemy_hit.mp3")
                        platforms[i].enemy = nil
                        score += 50 // Bonus poeni
                    } else if isShieldActive {
                        // Uništi neprijatelja
                        emitExplosion(at: enemyPosition)
                        playSound(named: "shield_block.mp3")
                        platforms[i].enemy = nil
                        isShieldActive = false // Štit se troši
                    } else {
                        // Kraj igre
                        playSound(named: "hit.mp3")
                        gameOver()
                    }
                    return
                }
            }
        }
    }
    
    private func movePlatforms() {
        // Logika je premeštena u updateGame za bolju sinhronizaciju sa igračem
    }
    
    private func addNewPlatform(at yPosition: CGFloat? = nil) {
        let yPos = yPosition ?? (platforms.map({ $0.position.y }).min() ?? screenHeight) - CGFloat.random(in: 60...100)
        
        // --- Dinamička težina ---
        let difficultyMultiplier = min(1.0, CGFloat(score) / 30000.0) // Sporije povećanje, max na 30000 poena
        
        // Smanji širinu platformi
        let currentMaxWidth = basePlatformWidth - (basePlatformWidth - minPlatformWidth) * difficultyMultiplier
        let platformWidth = CGFloat.random(in: minPlatformWidth...currentMaxWidth)
        
        // Povećaj šansu za specijalne platforme
        let specialPlatformChance = baseSpecialPlatformChance + (maxSpecialPlatformChance - baseSpecialPlatformChance) * Double(difficultyMultiplier)
        
        // Povećaj šansu za neprijatelje - mnogo sporije
        let enemyChance = baseEnemyChance + (maxEnemyChance - baseEnemyChance) * Double(difficultyMultiplier)
        // --- Kraj dinamičke težine ---
        
        // Određivanje tipa platforme
        var platformType = PlatformType.normal
        if Double.random(in: 1...100) <= specialPlatformChance {
            platformType = [.breakable, .moving].randomElement()!
        }
        
        var color: Color
        switch platformType {
        case .normal: color = themeManager.currentTheme.platformNormal.randomElement() ?? .gray
        case .breakable: color = themeManager.currentTheme.platformBreakable
        case .moving: color = themeManager.currentTheme.platformMoving
        }
        
        var newPlatform = Platform(
            position: CGPoint(x: CGFloat.random(in: 50...(screenWidth - 50)), y: yPos),
            width: platformWidth, // Koristi dinamičku širinu
            color: color,
            type: platformType
        )
        
        if platformType == .moving {
            newPlatform.velocity = CGPoint(x: [-1.5, 1.5].randomElement()!, y: 0)
        }
        
        let spawnRoll = Double.random(in: 0...100)
        if platformType == .normal {
            if spawnRoll < enemyChance { // Koristi dinamičku šansu
                newPlatform.enemy = Enemy()
            } else if spawnRoll < enemyChance + 15 { // 15% šanse za power-up
                newPlatform.powerUp = [.jetpack, .spring, .shield].randomElement()
            }
        }
        
        platforms.append(newPlatform)
        
        // Dodaj zvezdicu između platformi (20% šanse)
        if Double.random(in: 0...100) < 20 {
            if let lastPlatform = platforms.last(where: { $0.id != newPlatform.id }) {
                let xPos = CGFloat.random(in: 50...screenWidth - 50)
                let yPos = (newPlatform.position.y + lastPlatform.position.y) / 2
                let newCollectible = Collectible(position: CGPoint(x: xPos, y: yPos))
                collectibles.append(newCollectible)
            }
        }
    }
    
    private func gameOver() {
        if !isGameActive { return }
        isGameActive = false
        gameTimer?.invalidate()
        gameTimer = nil
        rotationAngle = 0
        isJetpackActive = false
        stopMotionManager()
        isShieldActive = false
        particles.removeAll()
        projectiles.removeAll()
        collectibles.removeAll()
        starDust.removeAll() // Očisti zvezdanu prašinu
        
        // Logika za najbolji skor
        if score > highScore {
            highScore = score
            saveHighScore()
        }
        
        // Pusti zvuk i prikaži ekran za kraj igre
        playSound(named: "gameover.mp3")
        isGameOverScreenShowing = true
        stopBackgroundMusic()
    }
    
    private func activatePowerUp(_ type: PowerUpType) {
        switch type {
        case .jetpack:
            isJetpackActive = true
            jetpackFuel = 2.0 // Trajanje jetpacka u sekundama (smanjeno sa 3.0 na 2.0)
            playSound(named: "jetpack.mp3")
        case .spring:
            jump(force: jumpForce * 2.5) // Duplo jači skok
            playSound(named: "spring.mp3")
        case .shield:
            isShieldActive = true
            shieldTime = 5.0 // Trajanje štita u sekundama
            playSound(named: "shield_on.mp3")
        }
    }
    
    private func setupMotionManager() {
        motionManager.startAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = 1/60
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data else { return }
            let acceleration = data.acceleration
            tiltX = acceleration.x
        }
    }
    
    private func stopMotionManager() {
        motionManager.stopAccelerometerUpdates()
    }
    
    // --- Funkcije za Zvuk i Skor ---
    
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: "TrisolarisJumpHighScore")
    }
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: "TrisolarisJumpHighScore")
    }
    
    private func loadPreferences() {
        highScore = UserDefaults.standard.integer(forKey: "TrisolarisJumpHighScore")
        isSoundEnabled = !UserDefaults.standard.bool(forKey: "TrisolarisJumpMuted")
        themeManager.loadTheme()
    }
    
    private func saveSoundPreference() {
        UserDefaults.standard.set(!isSoundEnabled, forKey: "TrisolarisJumpMuted")
    }
    
    private func toggleSound() {
        isSoundEnabled.toggle()
        saveSoundPreference()
        if isSoundEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
            audioPlayers.forEach { $0.stop() }
            audioPlayers.removeAll()
        }
    }
    
    private func playSound(named soundName: String) {
        guard isSoundEnabled else { return }
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            print("Zvučni fajl '\(soundName)' nije pronađen. Dodajte 'hit.mp3' u projekat.")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.prepareToPlay()
            audioPlayers.append(player)
            player.play()
            
            // Ukloni playere koji su završili sa reprodukcijom da se ne gomilaju
            audioPlayers.removeAll { !$0.isPlaying }
            
        } catch {
            print("Greška pri reprodukciji zvuka: \(error.localizedDescription)")
        }
    }
    
    private func playBackgroundMusic() {
        guard isSoundEnabled, backgroundMusicPlayer == nil else {
            backgroundMusicPlayer?.play()
            return
        }
        guard let path = Bundle.main.path(forResource: "background.mp3", ofType: nil) else {
            print("Zvučni fajl 'background.mp3' nije pronađen.")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            backgroundMusicPlayer?.numberOfLoops = -1 // Ponavljaj beskonačno
            backgroundMusicPlayer?.volume = 0.3
            backgroundMusicPlayer?.play()
        } catch {
            print("Greška pri reprodukciji pozadinske muzike.")
        }
    }
    
    private func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil // Oslobodi memoriju
    }
    
    // --- Funkcije za čestice ---
    
    private func emitJetpackTrail() {
        let particle = Particle(
            position: CGPoint(x: playerPosition.x, y: playerPosition.y + 20),
            size: CGFloat.random(in: 5...15),
            opacity: 1.0
        )
        particles.append(particle)
        
        // Dodaj zvezdanu prašinu za rep - optimizovano
        if starDust.count < 20 { // Ograniči broj čestica za bolju performansu
            emitStarDust()
        }
    }
    
    private func emitStarDust() {
        // Emituj zvezdanu prašinu iza Trisolaris-a - optimizovano
        let trisolarisHeight: CGFloat = 60
        let repLength = trisolarisHeight * 2
        
        // Emituj manje čestica ali redovnije
        for i in 0..<4 { // Smanjeno sa 8 na 4
            let progress = Double(i) / 3.0
            let yOffset = progress * repLength
            
            let dust = StarDust(
                position: CGPoint(
                    x: playerPosition.x + CGFloat.random(in: -10...10), // Smanjen raspon
                    y: playerPosition.y + 20 + yOffset
                ),
                size: CGFloat.random(in: 3...8) * (1.0 - progress * 0.3), // Veće čestice
                opacity: 0.9 * (1.0 - progress * 0.2), // Veća početna providnost
                velocity: CGPoint(
                    x: CGFloat.random(in: -0.5...0.5), // Smanjena brzina
                    y: CGFloat.random(in: 0.3...1.0)
                )
            )
            starDust.append(dust)
        }
    }

    private func emitJumpParticles(at position: CGPoint) {
        for _ in 0..<10 {
            let particle = Particle(
                position: position,
                size: CGFloat.random(in: 2...8),
                opacity: 1.0
            )
            particles.append(particle)
        }
    }
    
    private func emitExplosion(at position: CGPoint) {
        for _ in 0..<30 {
            let particle = Particle(
                position: position,
                size: CGFloat.random(in: 3...12),
                opacity: 1.0
            )
            particles.append(particle)
        }
    }
    
    private func updateParticles() {
        // Ograniči broj čestica za bolju performansu
        if particles.count > 50 {
            particles.removeFirst(particles.count - 50)
        }
        
        for i in (0..<particles.count).reversed() {
            particles[i].opacity -= 0.03 // Smanjeno sa 0.05 za sporije nestajanje
            
            // Dodaj malo gravitacije česticama
            particles[i].position.y += 0.8 // Smanjeno sa 1
            
            if particles[i].opacity <= 0 {
                particles.remove(at: i)
            }
        }
    }
    
    private func updateStarDust() {
        // Ograniči broj čestica za bolju performansu
        if starDust.count > 30 {
            starDust.removeFirst(starDust.count - 30)
        }
        
        for i in (0..<starDust.count).reversed() {
            // Pomeri zvezdanu prašinu
            starDust[i].position.x += starDust[i].velocity.x
            starDust[i].position.y += starDust[i].velocity.y
            
            // Smanji opacity sporije za duži trajnost
            starDust[i].opacity -= 0.015 // Smanjeno sa 0.02
            
            // Ukloni ako je potpuno providna ili van ekrana
            if starDust[i].opacity <= 0 || starDust[i].position.y > screenHeight + 50 {
                starDust.remove(at: i)
            }
        }
    }
    
    // --- Funkcija za pucanje ---
    private func shoot() {
        let newProjectile = Projectile(position: CGPoint(x: playerPosition.x, y: playerPosition.y - 40))
        projectiles.append(newProjectile)
        playSound(named: "shoot.mp3")
    }
    
    // --- Funkcije za ažuriranje ---
    
    private func checkCollectibles() {
        for i in (0..<collectibles.count).reversed() {
            let collectible = collectibles[i]
            let distance = hypot(playerPosition.x - collectible.position.x, playerPosition.y - collectible.position.y)
            
            if distance < 40 { // Radijus sakupljanja
                score += 25 // Bonus poeni
                playSound(named: "collect.mp3")
                emitExplosion(at: collectible.position) // "Poof" efekat
                collectibles.remove(at: i)
            }
        }
    }
    
    private func updateProjectiles() {
        for i in (0..<projectiles.count).reversed() {
            projectiles[i].position.y -= 20 // Brzina projektila
            
            // Ukloni ako je van ekrana
            if projectiles[i].position.y < 0 {
                projectiles.remove(at: i)
                continue
            }
            
            // Provera sudara sa neprijateljima
            for j in (0..<platforms.count).reversed() {
                // Dodatna provera jer se nizovi menjaju unutar petlji
                guard i < projectiles.count, j < platforms.count else { continue }
                
                if platforms[j].enemy != nil {
                    let enemyPosition = CGPoint(x: platforms[j].position.x, y: platforms[j].position.y - 25)
                    let projectilePosition = projectiles[i].position
                    
                    // Jednostavna provera kolizije
                    if abs(projectilePosition.x - enemyPosition.x) < 20 && abs(projectilePosition.y - enemyPosition.y) < 20 {
                        emitExplosion(at: enemyPosition)
                        playSound(named: "enemy_hit.mp3")
                        
                        platforms[j].enemy = nil // Ukloni neprijatelja
                        projectiles.remove(at: i) // Ukloni projektil
                        
                        score += 50 // Bonus poeni
                        
                        break // Prekini petlju za neprijatelje, jer je projektil uništen
                    }
                }
            }
        }
    }
    
    // --- Kontrole Stanja Igre ---
    private func pauseGame() {
        if isGameActive {
            isPaused = true
            gameTimer?.invalidate()
            stopMotionManager()
            backgroundMusicPlayer?.pause()
        }
    }
    
    private func resumeGame() {
        isPaused = false
        setupMotionManager()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in updateGame() }
        backgroundMusicPlayer?.play()
    }
    
    private func quitGame() {
        isPaused = false
        isGameActive = false
        isGameOverScreenShowing = false
        setupInitialScene()
        playBackgroundMusic() // Ponovo pusti muziku za meni
    }
}

struct Platform {
    let id = UUID()
    var position: CGPoint
    let width: CGFloat
    var color: Color
    var powerUp: PowerUpType?
    var enemy: Enemy?
    var type: PlatformType
    var velocity: CGPoint = .zero // Za pokretne platforme
    var isBroken: Bool = false
    var isBreaking: Bool = false
    var opacity: Double = 1.0
}

#Preview {
    ContentView()
}
