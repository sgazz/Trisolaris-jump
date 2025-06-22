//
//  ThemeManager.swift
//  Jump Doodle Jump
//
//  Created by Gazza on 20. 6. 2025..
//

import SwiftUI

// --- TEME ---
enum ThemeType: String, CaseIterable {
    case color = "Color"
    case monochrome = "Monochrome"
    case pixel = "Pixel Art"
    case luxury = "Luxury"
    case wired = "Wired"
}

struct Theme {
    let accent: Color
    let backgroundGradient: [Color]
    let trisolaris: [Color]
    let platformNormal: [Color]
    let platformBreakable: Color
    let platformMoving: Color
    let enemy: Color
    let projectile: Color
    let collectible: Color
    let shield: Color
    let particleJetpack: Color
    let particleExplosion: Color
    let textColor: Color
    let buttonTextColor: Color

    static let colorful = Theme(
        accent: .cyan,
        backgroundGradient: [.black, Color.purple.opacity(0.3), Color.blue.opacity(0.2)],
        trisolaris: [Color(white: 0.8), .red, .green],
        platformNormal: [.green, .blue, .purple, .orange],
        platformBreakable: Color(.sRGB, red: 0.6, green: 0.4, blue: 0.2, opacity: 1.0), // Brown
        platformMoving: .gray,
        enemy: .red,
        projectile: .yellow,
        collectible: .yellow,
        shield: .blue,
        particleJetpack: .orange,
        particleExplosion: .red,
        textColor: .white,
        buttonTextColor: .white
    )

    static let monochrome = Theme(
        accent: .white,
        backgroundGradient: [.black, Color(white: 0.15), Color(white: 0.3)],
        trisolaris: [Color(white: 0.9), Color(white: 0.7), Color(white: 0.5)],
        platformNormal: [Color(white: 0.6)],
        platformBreakable: Color(white: 0.4),
        platformMoving: Color(white: 0.8),
        enemy: .white,
        projectile: .white,
        collectible: Color(white: 0.95),
        shield: .white,
        particleJetpack: Color(white: 0.8),
        particleExplosion: .white,
        textColor: .white,
        buttonTextColor: .black
    )
    
    static let pixel = Theme(
        accent: Color(red: 0.2, green: 0.8, blue: 0.2), // Neon green
        backgroundGradient: [.black, Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.2, green: 0.2, blue: 0.4)],
        trisolaris: [Color(red: 1.0, green: 0.2, blue: 0.2), Color(red: 0.2, green: 0.2, blue: 1.0), Color(red: 1.0, green: 1.0, blue: 0.2)], // Red, Blue, Yellow
        platformNormal: [Color(red: 0.2, green: 0.8, blue: 0.2), Color(red: 0.8, green: 0.2, blue: 0.8), Color(red: 0.2, green: 0.8, blue: 0.8)], // Green, Purple, Cyan
        platformBreakable: Color(red: 0.8, green: 0.4, blue: 0.2), // Orange
        platformMoving: Color(red: 0.6, green: 0.6, blue: 0.6), // Gray
        enemy: Color(red: 1.0, green: 0.0, blue: 0.0), // Bright red
        projectile: Color(red: 1.0, green: 1.0, blue: 0.0), // Bright yellow
        collectible: Color(red: 1.0, green: 1.0, blue: 0.0), // Bright yellow
        shield: Color(red: 0.0, green: 0.8, blue: 1.0), // Cyan
        particleJetpack: Color(red: 1.0, green: 0.5, blue: 0.0), // Orange
        particleExplosion: Color(red: 1.0, green: 0.0, blue: 0.0), // Bright red
        textColor: Color(red: 0.2, green: 0.8, blue: 0.2), // Neon green
        buttonTextColor: .black
    )
    
    static let luxury = Theme(
        accent: Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        backgroundGradient: [Color(red: 0.1, green: 0.05, blue: 0.2), Color(red: 0.2, green: 0.1, blue: 0.3), Color(red: 0.3, green: 0.15, blue: 0.4)], // Deep purple gradient
        trisolaris: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 0.8, green: 0.8, blue: 1.0), Color(red: 1.0, green: 0.9, blue: 0.8)], // Gold, Silver, Pearl
        platformNormal: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 0.8, green: 0.8, blue: 1.0), Color(red: 0.0, green: 0.8, blue: 1.0)], // Gold, Silver, Diamond blue
        platformBreakable: Color(red: 0.6, green: 0.4, blue: 0.2), // Bronze
        platformMoving: Color(red: 0.8, green: 0.8, blue: 1.0), // Silver
        enemy: Color(red: 1.0, green: 0.2, blue: 0.2), // Ruby red
        projectile: Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        collectible: Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        shield: Color(red: 0.0, green: 0.8, blue: 1.0), // Diamond blue
        particleJetpack: Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        particleExplosion: Color(red: 1.0, green: 0.2, blue: 0.2), // Ruby red
        textColor: Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        buttonTextColor: .black
    )
    
    static let wired = Theme(
        accent: Color(red: 0.0, green: 1.0, blue: 0.5), // Neon cyan
        backgroundGradient: [.black, Color(red: 0.05, green: 0.1, blue: 0.05), Color(red: 0.1, green: 0.2, blue: 0.1)], // Dark green gradient
        trisolaris: [Color(red: 0.0, green: 1.0, blue: 0.5), Color(red: 1.0, green: 0.0, blue: 0.5), Color(red: 0.0, green: 0.5, blue: 1.0)], // Neon cyan, magenta, blue
        platformNormal: [Color(red: 0.0, green: 1.0, blue: 0.5), Color(red: 0.5, green: 0.0, blue: 1.0), Color(red: 1.0, green: 0.5, blue: 0.0)], // Neon cyan, purple, orange
        platformBreakable: Color(red: 0.8, green: 0.2, blue: 0.2), // Dark red
        platformMoving: Color(red: 0.3, green: 0.3, blue: 0.3), // Dark gray
        enemy: Color(red: 1.0, green: 0.0, blue: 0.0), // Bright red
        projectile: Color(red: 0.0, green: 1.0, blue: 0.5), // Neon cyan
        collectible: Color(red: 1.0, green: 1.0, blue: 0.0), // Bright yellow
        shield: Color(red: 0.0, green: 1.0, blue: 0.5), // Neon cyan
        particleJetpack: Color(red: 0.0, green: 1.0, blue: 0.5), // Neon cyan
        particleExplosion: Color(red: 1.0, green: 0.0, blue: 0.0), // Bright red
        textColor: Color(red: 0.0, green: 1.0, blue: 0.5), // Neon cyan
        buttonTextColor: .black
    )
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    @Published var selectedThemeType: ThemeType
    
    init() {
        self.selectedThemeType = .color
        self.currentTheme = Theme.colorful
        loadTheme()
    }
    
    func loadTheme() {
        let themeRaw = UserDefaults.standard.string(forKey: "TrisolarisTheme") ?? ThemeType.color.rawValue
        selectedThemeType = ThemeType(rawValue: themeRaw) ?? .color
        updateTheme()
    }
    
    func updateTheme() {
        switch selectedThemeType {
        case .color:
            currentTheme = Theme.colorful
        case .monochrome:
            currentTheme = Theme.monochrome
        case .pixel:
            currentTheme = Theme.pixel
        case .luxury:
            currentTheme = Theme.luxury
        case .wired:
            currentTheme = Theme.wired
        }
    }
    
    func toggleTheme() {
        let allThemes = ThemeType.allCases
        if let currentIndex = allThemes.firstIndex(of: selectedThemeType) {
            let nextIndex = (currentIndex + 1) % allThemes.count
            selectedThemeType = allThemes[nextIndex]
        }
        updateTheme()
        saveTheme()
    }
    
    func saveTheme() {
        UserDefaults.standard.set(selectedThemeType.rawValue, forKey: "TrisolarisTheme")
    }
} 