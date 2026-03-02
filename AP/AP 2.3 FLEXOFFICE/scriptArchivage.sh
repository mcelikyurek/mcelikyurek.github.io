#Repertoires
USER_DIR="/home"
BACKUP_DIR="/home/archives"
LOG_FILE="/var/log/archives.log"
# Nom du fichier de sauvegarde avec la date actuelle
DATE=$(date +%Y-%m-%d)
BACKUP_FLE="backup_$DATE.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$BACKUP_FILE"
# Cree le fichier tar.gz contenant les documents des utilisateurs
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$USER_DIR" .

# Verifie si la compression a reussi
if [ $? -eq 0 ]; then
    echo "Sauvegarde reussie : $BACKUP_FILE"
else
    echo "Erreur de sauvegarde"
    exit 1
fi

#cree le dossier backup
mkdir -p "$BACKUP_DIR"

echo "[$(date +%F_%T)] Fin du script" >> "$LOG_FILE"
