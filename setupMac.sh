#!/bin/bash

# Couleurs
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

echo -e "${BLUE}=== Configuration de l'environnement de développement ===${RESET}"

# === Détection du système d'exploitation ===
OS_TYPE="unknown"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS_TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS_TYPE="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  OS_TYPE="windows"
else
  echo -e "${RED}Système d'exploitation non supporté : $OSTYPE${RESET}"
  exit 1
fi

echo -e "${GREEN}Système détecté : $OS_TYPE${RESET}"

# === Trap pour gérer les interruptions ===
trap 'echo -e "${RED}Interruption détectée. Nettoyage...${RESET}"; exit 1' INT TERM

# === Fonctions générales ===

# Fonction pour exécuter une commande en tant qu'utilisateur non-root
function run_as_user() {
  local cmd=$1

  if [[ "$EUID" -eq 0 ]]; then
    sudo -u $(logname) bash -c "$cmd"
  else
    bash -c "$cmd"
  fi
}

# Fonction pour demander confirmation
function confirm_installation() {
  local name=$1
  echo -e "Voulez-vous installer ${YELLOW}$name${RESET} ? (Y/N): "
  read response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

# Fonction pour vérifier si un outil est installé
function is_installed() {
  local check_cmd=$1
  eval "$check_cmd" &>/dev/null
  return $?
}

# Fonction d'installation générique
function install_tool() {
  local name=$1
  local install_cmd=$2

  if confirm_installation "$name"; then
    echo -e "${GREEN}Installation de $name...${RESET}"
    eval "$install_cmd"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}$name installé avec succès.${RESET}"
    else
      echo -e "${RED}Échec de l'installation de $name.${RESET}"
    fi
  else
    echo -e "${CYAN}Installation de $name ignorée.${RESET}"
  fi
}

# === Vérification et installation des outils CLI ===
cli_tools=(git tree wget htop curl unzip gnupg php)

echo -e "${GREEN}=== Vérification et installation des outils CLI ===${RESET}"
for tool in "${cli_tools[@]}"; do
  echo -e "${YELLOW}Vérification de $tool...${RESET}"
  if is_installed "command -v $tool"; then
    echo -e "${GREEN}$tool est déjà installé.${RESET}"
    # Vérifier les mises à jour
    if [[ "$OS_TYPE" == "macos" ]]; then
      echo -e "${YELLOW}Vérification des mises à jour pour $tool...${RESET}"
      if brew outdated "$tool" &>/dev/null; then
        brew upgrade "$tool"
        echo -e "${GREEN}$tool a été mis à jour.${RESET}"
      else
        echo -e "${GREEN}$tool est déjà à jour.${RESET}"
      fi
    fi
  else
    install_tool "$tool" "brew install $tool"
  fi
done

# === Vérification et installation des applications GUI ===
gui_apps=(cursor google-chrome firefox slack discord filezilla visual-studio-code iterm2 postman docker raycast)

echo -e "${GREEN}=== Vérification et installation des applications GUI ===${RESET}"
for app in "${gui_apps[@]}"; do
  echo -e "${YELLOW}Vérification de $app...${RESET}"

  # Vérifier si l'application est installée via Homebrew Cask
  if is_installed "brew list --cask | grep -q $app"; then
    echo -e "${GREEN}$app est déjà installé via Homebrew.${RESET}"
  # Vérifier si l'application est installée dans le dossier Applications
  elif [[ -d "/Applications/$app.app" ]]; then
    echo -e "${GREEN}$app est déjà installé dans le dossier Applications.${RESET}"
  else
    install_tool "$app" "brew install --cask $app"
  fi
done

# === Vérification des langages ===
languages=(
  "Python|command -v python3|install_python"
  "Ruby|command -v ruby|install_ruby"
  "Node.js|command -v node|install_node"
  "PHP|command -v php|install_php"
  "Go|command -v go|install_go"
  "Java|command -v java|install_java"
  "Rust|command -v rustc|install_rust"
)

# === Vérification des frameworks ===
frameworks=(
  "Django|pip3 show django|install_django"
  "Flask|pip3 show flask|install_flask"
  "Rails|gem list -i rails|install_rails"
  "Express|npm list -g express|install_express"
  "Laravel|composer global show laravel/installer|install_laravel"
  "Gin|go list -m github.com/gin-gonic/gin|install_gin"
  "Spring Boot CLI|command -v spring|install_spring_boot"
  "Rocket|cargo install --list | grep rocket|install_rocket"
)

# === Installateurs pour les langages ===
function install_python() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install python"
      ;;
    "linux")
      apt install -y python3 python3-pip
      ;;
    "windows")
      winget install -e --id Python.Python.3
      ;;
  esac
}

function install_ruby() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install ruby"
      ;;
    "linux")
      apt install -y ruby-full
      ;;
    "windows")
      winget install -e --id RubyInstallerTeam.Ruby
      ;;
  esac
}

function install_node() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install node"
      ;;
    "linux")
      curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
      apt install -y nodejs
      ;;
    "windows")
      winget install -e --id OpenJS.NodeJS
      ;;
  esac
}

function install_php() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install php composer"
      ;;
    "linux")
      apt install -y php-cli composer
      ;;
    "windows")
      winget install -e --id PHP.PHP
      winget install -e --id Composer.Composer
      ;;
  esac
}

function install_go() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install go"
      ;;
    "linux")
      apt install -y golang
      ;;
    "windows")
      winget install -e --id Golang.Go
      ;;
  esac
}

function install_java() {
  case "$OS_TYPE" in
    "macos")
      run_as_user "brew install openjdk@17"
      ;;
    "linux")
      apt install -y openjdk-17-jdk
      ;;
    "windows")
      winget install -e --id Oracle.JavaRuntimeEnvironment
      ;;
  esac
}

function install_rust() {
  case "$OS_TYPE" in
    "macos"|"linux")
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      ;;
    "windows")
      winget install -e --id Rustlang.Rustup
      ;;
  esac
}

# === Installateurs pour les frameworks ===
function install_django() {
  pip3 install --user django
}

function install_flask() {
  pip3 install --user flask
}

function install_rails() {
  gem install rails
}

function install_express() {
  npm install -g express-generator
}

function install_laravel() {
  composer global require laravel/installer
}

function install_gin() {
  go install github.com/gin-gonic/gin@latest
}

function install_spring_boot() {
  curl -fsSL https://start.spring.io | bash
}

function install_rocket() {
  cargo install rocket
}

# === Vérification et installation des langages ===
echo -e "${GREEN}=== Vérification et installation des langages ===${RESET}"
for item in "${languages[@]}"; do
  IFS="|" read -r name check_cmd install_func <<< "$item"
  echo -e "${YELLOW}Vérification de $name...${RESET}"
  if is_installed "$check_cmd"; then
    echo -e "${GREEN}$name est déjà installé.${RESET}"
  else
    install_tool "$name" "$install_func"
  fi
done

# === Vérification et installation des frameworks ===
echo -e "${GREEN}=== Vérification et installation des frameworks ===${RESET}"
for item in "${frameworks[@]}"; do
  IFS="|" read -r name check_cmd install_func <<< "$item"
  echo -e "${YELLOW}Vérification de $name...${RESET}"
  if is_installed "$check_cmd"; then
    echo -e "${GREEN}$name est déjà installé.${RESET}"
  else
    install_tool "$name" "$install_func"
  fi

done

echo -e "${GREEN}=== Script terminé avec succès ===${RESET}"
