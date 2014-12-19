#! /bin/sh
if [ -h "/var/www/html" ]; then
	rm -f /var/www/html
fi
previous=`dirname /badnet/badnet*/index.php`
if [ -d "$previous" ]; then
	echo "Supprime l'ancienne version de Badnet: $previous" 
	rm -Rf $previous
fi

BADNET_URL=${BADNET_URL:="http://www.badnet.org/badnet/src/index.php?bnAction=65542&file=badnet_v2.9r3.zip&ajax=false"}
echo "Telecharge l'archive de la nouvelle version de Badnet $BADNET_URL" 
wget -O /badnet/archive/badnet.zip "$BADNET_URL"
unzip -qq /badnet/archive/badnet.zip -d /badnet

latest=`dirname /badnet/badnet*/index.php`
echo "Cree un lien symbolique vers la nouvelle version Badnet: $latest"
ln -s $latest /var/www/html

echo "Change les droits d'acces de la version Badnet (lecture/ecriture)"
chmod -R 777 /badnet/badnet*/
chmod 755 /var/www/html

