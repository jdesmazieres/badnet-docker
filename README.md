jdesmazieres/badnet
===================

Image Docker pour l'application de gestion de tournoi de badminton Badnet
http://www.badnet.org

Conteneur:
* PHP
* MySQL
* Apache 2
* Badnet


Création de votre conteneur docker Badnet
-----------------------------------------

Pour créer un conteneur à partir de l'image 'jdesmazieres/badnet', utiliser la commande 'run'

Démarrer votre image en bindant le port 80

	docker run -d -p 80:80 jdesmazieres/badnet

Si vous voulez pouvoir accéder à la base MySql en dehors du conteneur, binder le port MySql

	docker run -d -p 80:80 -p 3306:3306 jdesmazieres/badnet

ou plus simplement

	docker run -d -P jdesmazieres/badnet

Afin de pouvoir faciliter l'accès à votre conteneur, il est pratique de le nommer

	docker run -d -P -name mybadnet jdesmazieres/badnet

Il sera ainsi plus aisé d'interagir avec ce dernier

	docker stop mybadnet

Pour tester le déploiement depuis un browser:

	http://localhost/


Configuration Badnet
--------------------

Lors de la création de l'image docker, la base MySql a été configurée avec un user root sans mot de passe, mais avec un accès local uniquement.
Par conséquent lors du premier accès à l'application, il est demandé de spécifier la configuration Badnet. Dans celle-ci, utiliser le user root et laisser le mot de passe à vide 
(laisser les options par défaut sur les deux premiers écrans).

Une fois la configuration Badnet terminée, il est conseillé de sauvegarder cette dernière afin de pouvoir la réutiliser lors de la création de nouveaux conteneurs.

Pour cela il 'commiter' les modifications localement dans docker, et créer pour cela une nouvelle image 'my_badnet'

	docker commit -m="Badnet configure" -a="Jacques" badnet my_badnet:v1

Si par la suite, des modifications sont apportées à la configuration de cette nouvelle image, il est possible d'en créer une nouvelle version

	docker commit -m="Ajout des utilisateurs" -a="Jacques" badnet my_badnet:v2

Attention la commande 'run' recrée un conteneur à partir de l'image. Par conséquent, un nouveau conteneur créé à partir de l'image 'jdesmazieres/badnet' nécessitera de reconfigurer l'application.


Arrêt / démarrage d'un conteneur 
--------------------------------

Une fois le conteneur créé par la commande 'run', ce dernier est automatiquement exécuté.

Pour arrêter ce dernier, on utilise la commande 
	
	docker stop badnet 

Pour redémarrer ce dernier dans l'état où il a été arrêté, on utilise la commande 
	
	docker start badnet 


Configuration avancée du conteneur
----------------------------------

Lors de la création de l'image docker, la base MySql a été configurée avec un user root sans mot de passe, mais avec un accès local uniquement.
Par conséquent:
* lors de la configuration Badnet, utliser le user root et laisser le mot de passe à vide (laisser les options par défaut sur les deux premiers écrans)
* pour un accès externe à la base MySql, utiliser le user admin, dont le mot de passe est précisé lors de l'exécution du conteneur (docker run)

Pour récupérer le mot de passe du l'utilisateur admin (celui-ci est généré aléatoirement lors de la création du conteneur), utiliser la commande:

	docker logs $CONTAINER_ID

La commande vous affichera une sortie du genre:

	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

Dans ce cas, `47nnf4FweaKu` est le mot de passe du user `admin`.

Vous pouvez alors vous connecter à MySQL:

	 mysql -uadmin -p47nnf4FweaKu

Rappelez-vous que le user `root` n'accepte pas les connexion en dehors du conteneur - 
vous devez utiliser le user `admin` à la place!


Définir un mot de passe spécifique pour le compte d'administration de MySQL
---------------------------------------------------------------------------

Si vous voulez forcer un mot de passe pour le compte d'administration de MySql plutôt qu'en générer
un aléatoirement, vous pouvez définir la variable d'environnement `MYSQL_PASS` avec votre mot de passe
spécifique lors de l'exécution du conteneur:

	docker run -d -P -e MYSQL_PASS="mypass" jdesmazieres/badnet

Vous pouvez alors tester votre nouveau mot de passe d'administration:

	mysql -uadmin -p"mypass"

Mettre à jour la version de Badnet
----------------------------------

La première version de l'image 'jdesmazieres/badnet' intégre la version 2.9r2 de Badnet.

Lors des mises à jour de l'application, il est intéressant de pouvoir faire évoluer les images docker en même temps.

Pour cela, le plus simple est de créer une nouvelle image, se basant sur l'image précédente, en ne modifiant que la
version de l'application. 

Dans un nouveau répertoire, stocker le fichier zip de l'application badnet, et créer un nouveau `Dockerfile` avec le contenu suivant:

	FROM jdesmazieres/badnet:latest
	RUN rm -fr /badnet/archive/badnet*.zip
	ADD *.zip /badnet/archive/
	RUN /badnet/scripts/install-badnet.sh
	EXPOSE 80 3306
	CMD ["/run.sh"]

Ensuite, builder le `Dockerfile`:

	docker build -t my-badnet .

Et crer un conteneur:

	docker run -d -P --name mynewbadnet my-badnet

Et tester ce dernier dans un browser:

	http://localhost/


Licences - remerciements
------------------------

Ce conteneur est construit à partir du conteneur tutum/lamp: https://raw.githubusercontent.com/tutumcloud/tutum-docker-lamp

L'application Badnet est disponible en téléchargement sur le site: http://www.badnet.org

**by Jacques Desmazières**

