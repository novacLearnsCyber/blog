#!/bin/bash

# 1. Schimbăm directorul
cd "$HOME/Desktop/blogFolder" || { echo "Eroare: Folderul nu a fost găsit!"; exit 1; }

# CONFIGURARE: Îi spunem lui Git să folosească "merge" ca strategie implicită
git config pull.rebase false

echo "[1/5] Salvez modificarile locale..."
git add .
git commit -m "Auto-save inainte de sync" || echo "Nimic de salvat local."

echo "[2/5] Incerc sa aduc modificarile de pe GitHub..."
# Forțăm pull-ul să facă un merge chiar dacă ramurile sunt divergente
git pull origin main --no-rebase

# Verificăm dacă pull-ul a dat eroare (conflicte reale)
if [ $? -ne 0 ]; then
    echo "[!] Conflicte detectate. Incep repararea automata..."
    
    # Rezolvăm conflictele
    git checkout --theirs public/ 2>/dev/null
    git checkout --ours content/ 2>/dev/null
    
    git add .
    # Finalizăm merge-ul care a fost blocat de conflicte
    git commit -m "Reparat automat conflicte (public=theirs, content=ours)"
    echo "[OK] Conflictele au fost rezolvate."
fi

echo "[3/5] Trimit schimbarile pe GitHub..."
git push origin main

# Verificare finală pentru Push
if [ $? -eq 0 ]; then
    echo "[4/5] GATA! Blogul este sincronizat cu succes."
else
    echo "[!] EROARE: Push-ul a esuat. Verifica conexiunea sau permisiunile."
fi
