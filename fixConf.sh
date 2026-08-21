#!/bin/bash


cd "$HOME/Desktop/blogFolder" || { echo "Eroare: Folderul nu a fost găsit!"; exit 1; }

git config pull.rebase false

echo "[1/5] Salvez modificarile locale..."
git add .
git commit -m "Auto-save inainte de sync" || echo "Nimic de salvat local."

echo "[2/5] Incerc sa aduc modificarile de pe GitHub..."
git pull origin main --no-rebase

if [ $? -ne 0 ]; then
    echo "[!] Conflicte detectate. Incep repararea automata..."
    
    git checkout --theirs public/ 2>/dev/null
    git checkout --ours content/ 2>/dev/null
    
    git add .
    git commit -m "Reparat automat conflicte (public=theirs, content=ours)"
    echo "[OK] Conflictele au fost rezolvate."
fi

echo "[3/5] Trimit schimbarile pe GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "[4/5]Blogul este sincronizat cu succes."
else
    echo "[!] EROARE: Push-ul a esuat. Verifica conexiunea sau permisiunile."
fi
