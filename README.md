https://streamable.com/jwpndk

# Gangs Builder

🇬🇧 **English Version**

A gang management system for FiveM servers based on ESX. This script allows you to create, manage, and administer gangs, with additional features such as stash access, vehicle management, and more.

## Requirements

- **ESX** version 1.9.4 or higher
- **OxInventory**, **QSInventory**, or **QBInventory** (optional)
- Properly configured **FiveM** server with required dependencies

## Installation

1. Download the script and place it in your server's `resources` folder.
2. Add `start GangsBuilder` to your `server.cfg` file.
3. Configure the settings in the `config.lua` file according to your preferences.
4. Start your FiveM server.

## Configuration

The `config.lua` file contains the following settings:

### General Settings

- `Locale`: Set the language (`'en'` by default).
- `setJobField`: Specify `'job'` or `'metadata'` for gangs (if `'metadata'`, allows using a second job, e.g., "job2").
- Supported inventories: `OxInventory`, `QSInventory`, `QBInventory`.
- `InventoryPrefix`: Prefix for the inventory (default `'inventory'`).

### Mafia Menu

- `mafiaMenu`: Configuration options for the gang menu.
  - `defaultKey`: Key to open the menu (e.g., `'F6'`).
  - `position`: Menu position (e.g., `'top-right'`).
  - `enabled`: Enable/disable the menu.

### Available Commands

- **Admin Commands**
  - `creategang`: Create a gang (requires admin group).
  - `dellgang`: Delete a gang (requires admin group).
  - `tpgang`: Teleport an admin to a gang's base.
  - `resetmarker`: Reset all markers.
  - `updatevehicles`: Update a gang's vehicles.

- **Gang Commands**
  - `base`: Allows players to locate their base via GPS.
  - `newmarker`: Add new markers (admin required).

- **Metadata Field Commands**
  - `setgang`, `removegang`, `mygang`: Gang management commands when `setJobField` is set to `'metadata'`.

### Stash Access

- `stashAccessEveryone`: If enabled, everyone with a password can access the stash (otherwise, reserved for gang members).

### Actions

- `freezeWhileCuffed`: Players who are cuffed cannot move.

### Stash Configuration

- `stash`: Settings for stashes, defined by level (slots and kg per level).

### Level Pricing

- `Levels`: Cost to purchase each level.

### Dealership Configuration

- `dealership`: Managed exclusively by the gang, with blip and preview options.
  - `enable`: Enable or disable the dealership.
  - `coords`: Dealership coordinates.
  - `vehiclePreview`: Position for vehicle previews.

### Impound

- `impound`: Impound configuration (coordinates, blip, etc.).
- `ImpoundPrices`: Pricing for each type of vehicle (compact, SUV, etc.).

### Vehicle Tuning

- `TuneOptions`: Tuning configuration (engine, brakes, transmission, etc.).

## Usage

- Use the in-game chat commands to administer and manage gangs.
- Access stashes, dealerships, and impounds based on configured permissions.

## Customization

The script is easily customizable. Modify the settings in `config.lua` and adjust features according to your server's needs.

## Support

For support, contact the developer or join the community on Discord.

---

🇫🇷 **Version Française**

Un système de gestion de gangs pour les serveurs FiveM basé sur ESX. Ce script permet de créer, gérer et administrer des gangs, avec des fonctionnalités supplémentaires telles que l'accès aux cachettes, la gestion des véhicules et bien plus encore.

## Prérequis

- **ESX** version 1.9.4 ou supérieure
- **OxInventory**, **QSInventory**, ou **QBInventory** (au choix)
- Serveur **FiveM** correctement configuré avec les dépendances requises

## Installation

1. Téléchargez le script et placez-le dans le dossier `resources` de votre serveur FiveM.
2. Ajoutez `start GangsBuilder` à votre fichier `server.cfg`.
3. Configurez les options dans le fichier `config.lua` selon vos préférences.
4. Démarrez votre serveur FiveM.

## Configuration

Le fichier `config.lua` contient les paramètres suivants :

### Paramètres Généraux

- `Locale`: Définir la langue (`'en'` par défaut).
- `setJobField`: Indiquer `'job'` ou `'metadata'` pour les gangs (si `'metadata'`, permet d'utiliser un deuxième emploi, par ex. "job2").
- Inventaires supportés : `OxInventory`, `QSInventory`, `QBInventory`.
- `InventoryPrefix`: Préfixe pour l'inventaire (par défaut `'inventory'`).

### Menu Mafia

- `mafiaMenu` : Options de configuration du menu de gang.
  - `defaultKey`: Touche pour ouvrir le menu (ex. `'F6'`).
  - `position`: Position du menu (ex. `'top-right'`).
  - `enabled`: Activer/désactiver le menu.

### Commandes Disponibles

- **Commandes d'Administration**
  - `creategang` : Créer un gang (nécessite un groupe admin).
  - `dellgang` : Supprimer un gang (nécessite un groupe admin).
  - `tpgang` : Téléporter un admin à la base d'un gang.
  - `resetmarker` : Réinitialiser tous les marqueurs.
  - `updatevehicles` : Mettre à jour les véhicules d'un gang.

- **Commandes pour les Gangs**
  - `base` : Permet aux joueurs de localiser leur base via GPS.
  - `newmarker` : Ajouter de nouveaux marqueurs (admin requis).

- **Commandes liées au Champ de Métadonnées**
  - `setgang`, `removegang`, `mygang` : Commandes de gestion des gangs lorsque `setJobField` est configuré sur `'metadata'`.

### Accès aux Cachettes

- `stashAccessEveryone`: Si activé, tous ceux disposant d'un mot de passe peuvent accéder aux cachettes (sinon, réservé aux membres du gang).

### Actions

- `freezeWhileCuffed`: Les joueurs menottés ne peuvent pas bouger.

### Configuration des Cachettes

- `stash`: Paramètres pour les cachettes, définis par niveau (slots et kg par niveau).

### Tarifs des Niveaux

- `Levels`: Coût d'achat pour chaque niveau.

### Configuration du Concessionnaire

- `dealership`: Gestion des véhicules par la mafia, avec options de blip et de prévisualisation.
  - `enable`: Activer ou désactiver le concessionnaire.
  - `coords`: Coordonnées du concessionnaire.
  - `vehiclePreview`: Position d'aperçu des véhicules.

### Fourrière

- `impound`: Configuration de la fourrière (coordonnées, blip, etc.).
- `ImpoundPrices`: Tarifs selon le type de véhicule (compact, SUV, etc.).

### Tuning des Véhicules

- `TuneOptions`: Configuration du tuning (moteur, freins, transmission, etc.).

## Utilisation

- Utilisez les commandes en jeu via le chat pour administrer et gérer les gangs.
- Accédez aux cachettes, concessionnaires et fourrière en fonction des permissions configurées.

## Personnalisation

Le script est facilement personnalisable. Modifiez les paramètres dans `config.lua` et ajustez les fonctionnalités selon les besoins de votre serveur.

## Support

Pour toute assistance, veuillez contacter le développeur ou rejoindre la communauté sur Discord.
