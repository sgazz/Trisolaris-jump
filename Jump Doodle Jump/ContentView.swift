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
}

// Enum za tipove platformi
enum PlatformType {
    case normal
    case breakable // Nestaje posle skoka
    case moving    // Kreće se levo-desno
}

struct ContentView: View {
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
    
    // Audio Player
    @State private var audioPlayers: [AVAudioPlayer] = []
    
    // Power-up stanja
    @State private var isJetpackActive = false
    @State private var jetpackFuel: TimeInterval = 0
    
    let gravity: CGFloat = 0.8
    let jumpForce: CGFloat = -20
    let moveSpeed: CGFloat = 8
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Svemirska pozadina
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
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
            
            // Platforme
            ForEach(platforms, id: \.id) { platform in
                if !platform.isBroken { // Ne prikazuj polomljene platforme
                    ZStack {
                        Rectangle()
                            .fill(platform.color)
                            .frame(width: platform.width, height: 20)
                            .shadow(color: platform.color, radius: 8)
                            .opacity(platform.opacity) // Za efekat nestajanja
                        
                        // Prikaz power-up-a na platformi
                        if let powerUp = platform.powerUp {
                            switch powerUp {
                            case .jetpack:
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                    .shadow(color: .orange, radius: 10)
                            case .spring:
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                    .shadow(color: .green, radius: 10)
                            }
                        }
                    }
                    .position(platform.position)
                }
            }
            
            // Trisolaris lik (popunjen, sa glow efektom)
            ZStack {
                // Sivi krug
                ZStack {
                    Circle()
                        .fill(Color(white: 0.8))
                        .frame(width: 30, height: 30)
                        .shadow(color: .white, radius: 8)
                    Text("+")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: 20, weight: .bold))
                }
                .offset(x: 0, y: -22)

                // Crveni krug
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                        .shadow(color: .red, radius: 8)
                    Text("+")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 20, weight: .bold))
                }
                .offset(x: -19, y: 11)

                // Zeleni krug
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .shadow(color: .green, radius: 8)
                    Text("+")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 20, weight: .bold))
                }
                .offset(x: 19, y: 11)
            }
            .rotationEffect(.degrees(rotationAngle))
            .position(playerPosition)
            
            // UI
            VStack {
                HStack {
                    Text("Score: \(score)")
                        .font(.system(size: 36, weight: .bold, design: .monospaced)) // Unapređen izgled
                        .foregroundColor(.white)
                        .padding()
                        .shadow(color: .white, radius: 5) // Glow
                    Spacer()
                }
                Spacer()
            }
            
            // Kontrole
            if !isGameActive {
                VStack {
                    Text("TRISOLARIS JUMP")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .cyan, radius: 10)
                    
                    Text("Naginjajte telefon levo/desno")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding()
                        .shadow(color: .white, radius: 3)
                    
                    Button("START") {
                        startGame()
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.cyan.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.cyan, lineWidth: 2)
                    )
                    .shadow(color: .cyan, radius: 10)
                }
            }
        }
        .onAppear {
            setupInitialScene()
            // Ne pokrećemo motion manager dok igra ne počne
        }
        .onDisappear {
            stopMotionManager()
        }
    }
    
    private func setupInitialScene() {
        platforms.removeAll()
        
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
    }
    
    private func startGame() {
        // Prvo, resetuj scenu na početno stanje
        setupInitialScene()
        
        // Resetuj sve vrednosti
        isGameActive = true
        score = 0
        totalScroll = 0 // Resetuj visinu
        isJetpackActive = false
        jetpackFuel = 0
        
        // Izvrši prvi skok da igra počne
        jump(force: jumpForce)
        playSound(named: "jump.mp3")
        
        // Pokretanje motion manager-a
        setupMotionManager()
        
        // Pokretanje animacije rotacije
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Game loop
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            updateGame()
        }
    }
    
    private func updateGame() {
        // Fizika
        if isJetpackActive {
            // Jetpack fizika - leti nagore
            playerVelocity = -25
            jetpackFuel -= 1/60
            if jetpackFuel <= 0 {
                isJetpackActive = false
            }
        } else {
            // Normalna fizika sa gravitacijom
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
                
                // Pusti zvuk i izvrši akciju na osnovu tipa platforme
                if let powerUp = platform.powerUp {
                    activatePowerUp(powerUp)
                    platforms[i].powerUp = nil // Ukloni power-up nakon korišćenja
                } else if platforms[i].type == .breakable {
                    platforms[i].isBreaking = true
                    playSound(named: "break.mp3")
                    jump(force: jumpForce) // I dalje skoči sa nje
                } else {
                    // Normalan skok
                    playSound(named: "jump.mp3")
                    jump(force: jumpForce)
                }
                
                playerPosition.y = platform.position.y - 20
                break
            }
        }
    }
    
    private func movePlatforms() {
        // Logika je premeštena u updateGame za bolju sinhronizaciju sa igračem
    }
    
    private func addNewPlatform(at yPosition: CGFloat? = nil) {
        let yPos = yPosition ?? (platforms.map({ $0.position.y }).min() ?? screenHeight) - CGFloat.random(in: 60...100)
        
        // Određivanje tipa platforme
        var platformType = PlatformType.normal
        if Int.random(in: 1...100) <= 5 { // 5% šanse za specijalnu platformu
            platformType = [.breakable, .moving].randomElement()!
        }
        
        var color: Color
        switch platformType {
        case .normal:
            color = [.green, .blue, .purple, .orange].randomElement() ?? .green
        case .breakable:
            color = Color(.brown) // Smeđa za lomljive
        case .moving:
            color = .gray // Siva za pokretne
        }
        
        var newPlatform = Platform(
            position: CGPoint(
                x: CGFloat.random(in: 50...(screenWidth - 50)),
                y: yPos
            ),
            width: CGFloat.random(in: 60...120),
            color: color,
            type: platformType
        )
        
        // Postavljanje brzine za pokretne platforme
        if platformType == .moving {
            newPlatform.velocity = CGPoint(x: [-1.5, 1.5].randomElement()!, y: 0)
        }
        
        // Šansa za dodavanje power-up-a (15%) - samo na normalnim platformama
        if platformType == .normal && Int.random(in: 0...100) < 15 {
            newPlatform.powerUp = [.jetpack, .spring].randomElement()
        }
        
        platforms.append(newPlatform)
    }
    
    private func gameOver() {
        isGameActive = false
        gameTimer?.invalidate()
        gameTimer = nil
        rotationAngle = 0
        isJetpackActive = false
        stopMotionManager()
        playSound(named: "gameover.mp3")
    }
    
    private func activatePowerUp(_ type: PowerUpType) {
        switch type {
        case .jetpack:
            isJetpackActive = true
            jetpackFuel = 3.0 // Trajanje jetpacka u sekundama
            playSound(named: "jetpack.mp3")
        case .spring:
            jump(force: jumpForce * 2.5) // Duplo jači skok
            playSound(named: "spring.mp3")
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
    
    // --- Funkcija za Zvuk ---
    private func playSound(named soundName: String) {
        // Potrebno je da dodate zvučne fajlove (npr. jump.mp3) u vaš projekat.
        // Idite na File -> Add Files to "Jump Doodle Jump"...
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            print("Zvučni fajl '\(soundName)' nije pronađen.")
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
}

struct Platform {
    let id = UUID()
    var position: CGPoint
    let width: CGFloat
    var color: Color
    var powerUp: PowerUpType?
    var type: PlatformType
    var velocity: CGPoint = .zero // Za pokretne platforme
    var isBroken: Bool = false
    var isBreaking: Bool = false
    var opacity: Double = 1.0
}

#Preview {
    ContentView()
}
