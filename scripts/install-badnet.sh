#! /bin/sh
if [ -h "/var/www/html" ]; then
	rm -f /var/www/html
fi
previous=`dirname /badnet/badnet*/index.php`
if [ -d "$previous" ]; then
	echo "Supprime l'ancienne version de Badnet: $previous" 
	rm -Rf $previous
fi

echo "Decompresse l'archive de la nouvelle version de Badnet" 
unzip -qq /badnet/archive/badnet*.zip -d /badnet

latest=`dirname /badnet/badnet*/index.php`
echo "Cree un lien symbolique vers la nouvelle version Badnet: $latest"
ln -s $latest /var/www/html

echo "Change les droits d'acces de la version Badnet (lecture/ecriture)"
chmod -R 777 /badnet/badnet*/
chmod 755 /var/www/html

