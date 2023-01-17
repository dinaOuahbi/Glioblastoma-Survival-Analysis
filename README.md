# Gliome-survival-analysis-clinical-data

Le glioblastome (GBM) est la tumeur cérébrale intraparenchymateuse primitive la plus fréquente, mais aussi la plus grave


Il existe une hiérarchie entre ces différentes options thérapeutiques, en faveur du traitement local sur le traitement systémique, et de la chirurgie sur la radiothérapie stéréotaxique. La chirurgie est de niveau de preuve 2A tandis que la radiothérapie de récidive est de niveau de preuve 2B20, c’est pourquoi aujourd’hui, lorsqu’un patient est théoriquement opérable, la reprise chirurgicale est systématiquement proposée en première intention en RCP.


C’est à la lumière de ces informations sur la réalité du glioblastome, notamment le peu d’amélioration du pronostic et la fragilité des patients, que l’on souhaite comparer la reprise chirurgicale et la radiothérapie stéréotaxique de la progression tumorale sur la survie globale, la survie sans deuxième progression, et la qualité de vie.


## Objectif
Analyse descriptive et comparaison des variables entre les 2 cohortes 
Analyse de survies: 
Comparaison de la survie dans les 2 cohortes
Sélection de variables pronostiques dans chaque cohorte

## données disponibles
2 cohortes différentes : 
Chirurgie (TheseAudrey.xlsx); n=29
Radio thérapie (TheseAudreyCGFL.xlsx); n=22

## Méthodes
Chaque variable est testée de manière univariée dans un modèle de Cox. On considère qu’une variable est significativement liée à la survie si sa p-value est inférieure à 0,10. 
Les variables significatives en univarié sont intégrées dans un modèle de Cox multivarié. 
Prédicteur linéaire : model =  X1𝛽1+𝑋2𝛽2+…+𝑋𝑛𝛽𝑛
Chaque ‘beta 'représente le poids de la variable X, autrement dit, son importance pour la prédiction de la survie. En calcule le produit X∗𝛽 pour touts les exemple (patients), nous obtenant une liste de valeur continue qui représente le prédicteur linéaire. 
   Enfin, le prédicteur linéaire est dichotomisé sur la médiane


## Notions importantes
### courbes de survie
Une courbe de survie va définir deux notions :Un risque de décès à un t donnait que l’on nomme R. (t)Une probe d’être encore en vie à un t donnée que l’on nomme S(t)

La méthode Kaplan Meier (KM) est une méthode d’estimation de la fonction de survie S (t) non-paramétrique. L’estimation est sous forme d’une courbe décroissante en escalier, ou chaque pas signifie la survenu de l’événement chez un ou plusieurs patients. (selon la grandeur du pas)


### Interprétation du risque relatif : 
HR > 1 : risque de la survenue de l’événement est proportionnel à la variable.

HR < 1 : risque de la survenue de l’événement est inversement proportionnel à la variable

HR = 1 : la variable n’a pas à impacter sur le risque instantané.

























