#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables globales
GITHUB_REPO="bourtitom/GFast"
TEMP_DIR="/tmp/gfast-install"

# Fonction pour afficher les messages d'erreur
error() {
    echo -e "${RED}Erreur: $1${NC}" >&2
}

# Fonction pour afficher les messages de succès
success() {
    echo -e "${GREEN}$1${NC}"
}

# Fonction pour afficher les avertissements
warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Vérifier si l'utilisateur a les droits sudo
check_sudo() {
    if ! sudo -v &>/dev/null; then
        error "Droits sudo requis pour l'installation"
        exit 1
    fi
}

# Vérifier si Git est installé
check_git() {
    if ! command -v git >/dev/null 2>&1; then
        error "Git n'est pas installé. Installation requise."
        exit 1
    fi
    success "Git est installé ✓"
}

# Télécharger depuis GitHub
download_from_github() {
    local repo_url="https://github.com/$1"
    
    # Nettoyer le répertoire temporaire s'il existe
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    
    echo "Téléchargement depuis $repo_url..."
    if git clone --depth 1 "$repo_url" "$TEMP_DIR"; then
        success "Téléchargement réussi ✓"
        cd "$TEMP_DIR" || exit 1
    else
        error "Impossible de télécharger depuis GitHub"
        exit 1
    fi
}

# Créer les répertoires d'installation
create_directories() {
    # Créer le répertoire pour les binaires
    sudo mkdir -p /usr/local/bin
    # Créer le répertoire pour la documentation
    sudo mkdir -p /usr/local/share/doc/gfast
    # Créer le répertoire pour la complétion
    sudo mkdir -p /usr/local/share/zsh/site-functions
}

# Installer la complétion ZSH
install_completion() {
    cat > _gf << 'EOL'
#compdef gf

_gf() {
    local state

    _arguments \
        '1: :->cmds' \
        '*:: :->args'

    case $state in
        cmds)
            _values 'gf commands' \
                'help[Afficher l aide]'
            ;;
    esac
}

_gf "$@"
EOL
    sudo mv _gf /usr/local/share/zsh/site-functions/
    success "Complétion ZSH installée ✓"
}

# Installer le script principal
install_script() {
    local script_path="/usr/local/bin/gf"
    
    # Copier le script
    if [ -f "gitfast" ]; then
        sudo cp gitfast "$script_path"
    else
        sudo cp git_push.sh "$script_path"
    fi
    sudo chmod +x "$script_path"
    
    success "Script installé dans $script_path ✓"
}

# Installer la documentation
install_docs() {
    local doc_path="/usr/local/share/doc/gfast"
    
    # Créer la documentation
    cat > README.md << 'EOL'
# GFast - Script d'automatisation Git

GFast est un script shell interactif qui simplifie et standardise le processus de commit et de push Git.

## Utilisation

Simplement exécuter :
```bash
gf
```

Pour plus d'informations, visitez : https://github.com/bourtitom/GFast
EOL
    
    sudo cp README.md "$doc_path/"
    success "Documentation installée dans $doc_path ✓"
}

# Configurer le PATH si nécessaire
configure_path() {
    local shell_rc
    case "$SHELL" in
        */zsh) shell_rc="$HOME/.zshrc" ;;
        */bash) shell_rc="$HOME/.bashrc" ;;
        *) warning "Shell non reconnu. Ajoutez manuellement /usr/local/bin à votre PATH" ; return ;;
    esac

    if ! grep -q '/usr/local/bin' "$shell_rc"; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$shell_rc"
        success "PATH configuré dans $shell_rc ✓"
    fi
}

# Fonction de désinstallation
uninstall() {
    echo "Désinstallation de GFast..."
    sudo rm -f /usr/local/bin/gf
    sudo rm -f /usr/local/share/zsh/site-functions/_gf
    sudo rm -rf /usr/local/share/doc/gfast
    success "GFast désinstallé avec succès"
}

# Fonction principale d'installation
main() {
    if [ "$1" = "uninstall" ]; then
        uninstall
        exit 0
    fi

    echo "Installation de GFast..."
    
    # Vérifications préalables
    check_sudo
    check_git
    
    # Si on installe depuis GitHub
    if [ "$1" = "github" ]; then
        download_from_github "$GITHUB_REPO"
        cd "$TEMP_DIR" || exit 1
    fi
    
    # Installation
    create_directories
    install_script
    install_completion
    install_docs
    
    # Nettoyage si installation depuis GitHub
    if [ "$1" = "github" ]; then
        rm -rf "$TEMP_DIR"
    fi
    
    success "\nGFast installé avec succès! 🎉"
    warning "Redémarrez votre terminal ou exécutez 'source ~/.zshrc' pour utiliser gf"
}

# Gérer les arguments
case "$1" in
    uninstall)
        main uninstall
        ;;
    github)
        main github
        ;;
    help|-h|--help)
        echo "Usage: $0 [uninstall|github|help]"
        echo "  Sans argument : Installe GFast depuis les fichiers locaux"
        echo "  github       : Installe GFast depuis GitHub"
        echo "  uninstall    : Désinstalle GFast"
        echo "  help        : Affiche cette aide"
        exit 0
        ;;
    *)
        main
        ;;
esac
