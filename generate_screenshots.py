#!/usr/bin/env python3
"""
Skripta za generisanje screenshot-a Trisolaris Jump za TestFlight
Potrebno je imati Pillow instaliran: pip install Pillow
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_screenshot(width, height, device_name):
    """Kreira screenshot za određeni uređaj"""
    
    # Kreiraj novu sliku
    img = Image.new('RGBA', (width, height), (0, 0, 0, 255))
    draw = ImageDraw.Draw(img)
    
    # Kosmička pozadina - gradijent
    for y in range(height):
        ratio = y / height
        r = int(0 + ratio * 51)
        g = int(0 + ratio * 0)
        b = int(0 + ratio * 102)
        color = (r, g, b, 255)
        draw.line([(0, y), (width, y)], fill=color)
    
    # Zvezde u pozadini
    import random
    random.seed(42)
    
    num_stars = int((width * height) / 10000)  # Prilagodi broj zvezda veličini
    for _ in range(num_stars):
        x = random.randint(0, width)
        y = random.randint(0, height)
        radius = random.randint(1, 3)
        opacity = random.randint(100, 200)
        draw.ellipse([x-radius, y-radius, x+radius, y+radius], 
                    fill=(255, 255, 255, opacity))
    
    # Kosmički efekti - elipse
    center_x, center_y = width // 2, height // 2
    
    # Spoljašnja elipsa
    outer_ellipse = [center_x - width//3, center_y - height//6, 
                     center_x + width//3, center_y + height//6]
    draw.ellipse(outer_ellipse, outline=(0, 255, 255, 100), width=3)
    
    # Unutrašnja elipsa
    inner_ellipse = [center_x - width//4, center_y - height//8, 
                     center_x + width//4, center_y + height//8]
    draw.ellipse(inner_ellipse, outline=(255, 0, 255, 100), width=2)
    
    # Trisolaris - skaliran za screenshot
    scale_factor = min(width, height) / 1024.0
    
    # Glavni krug (X)
    circle1_radius = int(60 * scale_factor)
    circle1_x, circle1_y = center_x, center_y - int(100 * scale_factor)
    
    # Gradijent za prvi krug (sivi)
    for r in range(circle1_radius, 0, -1):
        ratio = r / circle1_radius
        color = (int(200 * ratio), int(200 * ratio), int(200 * ratio), 255)
        draw.ellipse([circle1_x - r, circle1_y - r, circle1_x + r, circle1_y + r], 
                    fill=color)
    
    # X simbol
    try:
        font_size = int(40 * scale_factor)
        font = ImageFont.truetype("Arial.ttf", font_size)
    except:
        font = ImageFont.load_default()
    
    draw.text((circle1_x - font_size//3, circle1_y - font_size//2), "✕", 
              fill=(0, 0, 0, 255), font=font)
    
    # Crveni krug (trougao)
    circle2_radius = int(60 * scale_factor)
    circle2_x, circle2_y = center_x - int(80 * scale_factor), center_y + int(20 * scale_factor)
    
    for r in range(circle2_radius, 0, -1):
        ratio = r / circle2_radius
        color = (int(255 * ratio), int(100 * ratio), int(100 * ratio), 255)
        draw.ellipse([circle2_x - r, circle2_y - r, circle2_x + r, circle2_y + r], 
                    fill=color)
    
    # Trougao simbol
    draw.text((circle2_x - font_size//3, circle2_y - font_size//2), "▲", 
              fill=(255, 255, 255, 255), font=font)
    
    # Zeleni krug (kvadrat)
    circle3_radius = int(60 * scale_factor)
    circle3_x, circle3_y = center_x + int(80 * scale_factor), center_y + int(20 * scale_factor)
    
    for r in range(circle3_radius, 0, -1):
        ratio = r / circle3_radius
        color = (int(100 * ratio), int(255 * ratio), int(100 * ratio), 255)
        draw.ellipse([circle3_x - r, circle3_y - r, circle3_x + r, circle3_y + r], 
                    fill=color)
    
    # Kvadrat simbol
    draw.text((circle3_x - font_size//3, circle3_y - font_size//2), "■", 
              fill=(255, 255, 255, 255), font=font)
    
    # Zvezdana prašina (rep)
    for i in range(7):
        y_offset = int(200 * scale_factor) + i * int(15 * scale_factor)
        radius = int(3 * scale_factor) + (i % 3)
        opacity = 200 - i * 20
        draw.ellipse([center_x - radius, center_y + y_offset - radius, 
                     center_x + radius, center_y + y_offset + radius], 
                    fill=(0, 255, 255, opacity))
    
    # Platforme
    platform_width = int(300 * scale_factor)
    platform_height = int(20 * scale_factor)
    platform_y = center_y + int(320 * scale_factor)
    
    # Gradijent za platformu
    for y in range(platform_height):
        ratio = y / platform_height
        color = (int(100 * ratio), int(255 * ratio), int(100 * ratio), 200)
        draw.rectangle([center_x - platform_width//2, platform_y + y,
                       center_x + platform_width//2, platform_y + y + 1], 
                      fill=color)
    
    # UI elementi
    # Score
    score_font_size = int(36 * scale_factor)
    try:
        score_font = ImageFont.truetype("Arial.ttf", score_font_size)
    except:
        score_font = ImageFont.load_default()
    
    draw.text((50, 50), "Score: 1250", fill=(255, 255, 255, 255), font=score_font)
    
    # Pause button
    pause_size = int(36 * scale_factor)
    pause_x = width - 100
    pause_y = 50
    draw.ellipse([pause_x - pause_size//2, pause_y - pause_size//2,
                  pause_x + pause_size//2, pause_y + pause_size//2], 
                 fill=(255, 255, 255, 100))
    
    # Device name watermark
    watermark_font_size = int(24 * scale_factor)
    try:
        watermark_font = ImageFont.truetype("Arial.ttf", watermark_font_size)
    except:
        watermark_font = ImageFont.load_default()
    
    draw.text((20, height - 50), f"Trisolaris Jump - {device_name}", 
              fill=(255, 255, 255, 150), font=watermark_font)
    
    return img

def main():
    """Glavna funkcija"""
    print("Generisanje screenshot-a za TestFlight...")
    
    # Kreiraj direktorijum za screenshot-ove
    os.makedirs("screenshots", exist_ok=True)
    
    # Definišimo screenshot veličine za različite uređaje
    screenshot_sizes = {
        "iPhone_6.7_Display": (1290, 2796),      # iPhone 14 Pro Max, 15 Pro Max
        "iPhone_6.5_Display": (1242, 2688),      # iPhone 11 Pro Max, 12 Pro Max, 13 Pro Max
        "iPhone_5.5_Display": (1242, 2208),      # iPhone 8 Plus
        "iPad_Pro_12.9_Display": (2048, 2732),   # iPad Pro 12.9"
        "iPad_Pro_11_Display": (1668, 2388),     # iPad Pro 11"
    }
    
    # Generisanje screenshot-a
    for device_name, (width, height) in screenshot_sizes.items():
        print(f"Generisanje screenshot-a za {device_name} ({width}x{height})...")
        screenshot = create_screenshot(width, height, device_name)
        screenshot.save(f"screenshots/{device_name}.png")
    
    print("\nSvi screenshot-ovi su generisani!")
    print("Kopirajte ih u App Store Connect → Screenshots sekciju")
    print("\nKoraci:")
    print("1. Idite na App Store Connect")
    print("2. Izaberite Trisolaris Jump")
    print("3. Idite na App Information → Screenshots")
    print("4. Upload-ujte screenshot-ove za odgovarajuće uređaje")

if __name__ == "__main__":
    main() 