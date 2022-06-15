# biblionantes

![icon](https://user-images.githubusercontent.com/841858/154953703-c9a067aa-fb1d-4c10-92d8-a4f33d1280e9.png)

Bibliothèque de Nantes

Application permettant de gérer sur son mobile son compte de bibliothèque à la bibliothèque municipale de Nantes.

- Recherche de livre dans le catalogue de la bibliothèque
- Ajouter ensemble des cartes de bibliothèques de la famille
- Voir la liste des documents qui ont été emprunté et savoir quand on doit les rendre.
- Réserver des livres

![Page de recherche](./images/search.png)
![Carte de bibliothèque](./images/cartes.png)
![Liste des emprunts](./images/emprunt.png)
![Detail d'un ligne](./images/detail.png)

## Getting Started

Utiliser Android Studio, et lancer l'application en mode Android ou IOS.


## Developpement

Lorsque l'on modifier une route (ajout de parametre, nouvelles routes, etc...), il faut relancer la commande suivante.

```sh
flutter packages pub run build_runner build
```
