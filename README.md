# GFast - Script d'automatisation Git

GFast est un script shell interactif qui simplifie et standardise le processus de commit et de push Git. Il offre une interface utilisateur conviviale avec des messages colorés et une gestion d'erreurs robuste.

## 🚀 Fonctionnalités

- 🎨 Interface interactive avec messages colorés
- ↩️ Option de retour en arrière à chaque étape avec 'r'
- 🔄 Initialisation automatique de Git si nécessaire
- 🔗 Configuration assistée du remote
- ✨ Convention de commit standardisée
- 🛠️ Gestion avancée des erreurs

## 📋 Types de Commit Supportés

1. `feat` : Nouvelle fonctionnalité
2. `fix` : Correction de bug
3. `docs` : Modification de la documentation
4. `style` : Formatage du code
5. `refactor` : Restructuration du code
6. `test` : Ajout ou modification de tests
7. `chore` : Tâches diverses

## 🛠️ Installation

1. Copiez le script dans votre dossier `~/bin` :
```bash
cp gf.sh ~/bin/gf
chmod +x ~/bin/gf
```

2. Ajoutez le dossier bin à votre PATH (si ce n'est pas déjà fait) :
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 🎯 Utilisation

1. Naviguez vers n'importe quel projet
2. Exécutez simplement :
```bash
gf
```

Le script vous guidera à travers les étapes suivantes :
1. Initialisation de Git (si nécessaire)
2. Configuration du remote (si nécessaire)
3. Ajout de fichiers (tout ou sélection)
4. Choix du type de commit
5. Saisie du scope et de la description
6. Push des modifications

## ⚡ Fonctionnalités Avancées

### Gestion des Erreurs de Push
En cas d'erreur lors du push, le script propose plusieurs options :
1. Réessayer
2. Pull puis Push (avec rebase)
3. Force Push (avec avertissement)

### Sélection de Fichiers
Deux modes d'ajout de fichiers :
- Tout ajouter (`git add .`)
- Sélection interactive des fichiers modifiés

### Navigation
- Utilisez 'r' à n'importe quelle étape pour revenir en arrière
- Messages d'erreur et de succès colorés pour une meilleure lisibilité

## ⚠️ Notes

- Le force push est disponible mais utilisez-le avec précaution
- Les messages de commit suivent le format : `type(scope) description`
- Le script vérifie automatiquement les prérequis (Git installé, etc.)

## 🤝 Contribution

N'hésitez pas à proposer des améliorations ou à signaler des bugs !
