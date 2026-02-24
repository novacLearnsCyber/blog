#!/bin/bash

# Navigăm către folderul blogului
# Notă: Asigură-te că calea este corectă pentru sistemul tău Linux
cd "$HOME/Desktop/blogFolder" || { echo "Eroare: Folderul nu a fost găsit!"; exit 1; }

echo "============================================"
echo "  ACTUALIZARE BLOG - SYNC OBSIDIAN + HUGO"
echo "============================================"
echo ""

echo "[1/5] Verificăm modificările..."
git status

echo ""
echo "[2/5] Adăugăm toate fișierele modificate..."
git add .

echo ""
echo "[3/5] Verificăm build-ul Hugo local..."
# Executăm hugo și verificăm dacă a reușit
if ! hugo; then
    echo ""
    echo "[EROARE] Build-ul Hugo a eșuat! Verifică erorile de mai sus."
    read -p "Apasă Enter pentru a închide..."
    exit 1
fi

echo ""
echo "[4/5] Trimitem modificările pe GitHub..."
# Generăm un mesaj de commit cu data și ora curentă
current_date=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Update blog: $current_date"

if ! git push origin main; then
    echo ""
    echo "[EROARE] Push-ul pe GitHub a eșuat!"
    read -p "Apasă Enter pentru a închide..."
    exit 1
fi

echo ""
echo "[5/5] Așteptăm GitHub Actions să rebuilduiască site-ul..."
echo "Site-ul va fi live în ~1-2 minute la:"
echo "https://novaclearnscyber.github.io/blog/"
echo ""
echo "============================================"
echo "  GATA! Blogul se actualizează pe GitHub."
echo "============================================"

# Opțional: Menținem terminalul deschis pentru a vedea confirmarea


