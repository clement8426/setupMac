# Configuration de l'environnement de développement sur macOS

Ce script `setupMac.sh` automatise la configuration d'un environnement de développement sur macOS. Il installe les outils de ligne de commande essentiels, les langages de programmation, ainsi que des applications graphiques utiles.

## Prérequis

- macOS
- Homebrew (si non installé, le script l'installera automatiquement)

## Fonctionnalités

- Installation des outils CLI essentiels :
  - `git`, `tree`, `wget`, `htop`, `curl`, `unzip`, `gnupg`, `php`, `openssl`

- Installation de Node.js et npm via NVM (Node Version Manager)

- Installation de langages et outils supplémentaires :
  - Python, Ruby, Go, Java, Composer pour PHP

- Installation d'applications GUI utiles :
  - `Cursor`, `Google Chrome`, `Firefox`, `Slack`, `Discord`, `FileZilla`, `Visual Studio Code`, `iTerm2`, `Postman`, `Docker`, `Raycast`

## Utilisation

1. Clonez ce dépôt ou téléchargez le fichier `setupMac.sh`.
2. Ouvrez un terminal.
3. Rendez le script exécutable :
   ```bash
   chmod +x setupMac.sh
   ```
4. Exécutez le script :
   ```bash
   ./setupMac.sh
   ```

Le script vous demandera confirmation avant de réinstaller des outils déjà présents sur votre système.

## Personnalisation

Vous pouvez modifier les tableaux `cli_tools` et `gui_apps` dans le script pour ajouter ou supprimer des outils et applications selon vos besoins.

## Avertissements

- Assurez-vous d'avoir une connexion Internet active, car le script téléchargera des fichiers depuis Internet.
- Certaines installations peuvent nécessiter des privilèges administratifs (sudo).

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre des demandes de tirage ou à signaler des problèmes.

## License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
# setupMac
