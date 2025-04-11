#!/bin/bash

# Couleurs
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN}=== Recherche de mises à jour sur macOS ===${RESET}"

# === Vérification des mises à jour du système ===
echo -e "${GREEN}Vérification des mises à jour du système...${RESET}"
softwareupdate -l

# === Vérification des mises à jour de Homebrew ===
echo -e "${GREEN}Vérification des mises à jour de Homebrew...${RESET}"
if command -v brew &>/dev/null; then
  brew update
  echo -e "${GREEN}Mises à jour de Homebrew effectuées.${RESET}"

  # Vérification des mises à jour des formules
  echo -e "${GREEN}Vérification des mises à jour des formules...${RESET}"
  brew outdated

  # Mise à jour des formules
  echo -e "${GREEN}Mise à jour des formules...${RESET}"
  brew upgrade
else
  echo -e "${RED}Homebrew n'est pas installé.${RESET}"
fi

# === Vérification des mises à jour des applications installées via Cask ===
echo -e "${GREEN}Vérification des mises à jour des applications GUI...${RESET}"
if brew list --cask &>/dev/null; then
  brew outdated --cask
  echo -e "${GREEN}Mises à jour des applications GUI effectuées.${RESET}"
else
  echo -e "${RED}Aucune application GUI installée via Homebrew Cask.${RESET}"
fi

# === Vérification des applications installées dans le dossier Applications ===
echo -e "${GREEN}=== Vérification des applications installées ===${RESET}"
installed_apps=(
  "Google Chrome"
  "Firefox"
  "Slack"
  "Discord"
  "FileZilla"
  "Visual Studio Code"
  "Postman"
  "Docker"
  "Raycast"
)

for app in "${installed_apps[@]}"; do
  if [[ -d "/Applications/$app.app" ]]; then
    echo -e "${GREEN}$app est déjà installé dans le dossier Applications.${RESET}"
  else
    echo -e "${YELLOW}$app n'est pas installé.${RESET}"
  fi
done

echo -e "${GREEN}=== Recherche de mises à jour terminée ===${RESET}"
