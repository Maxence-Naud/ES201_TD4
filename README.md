# Mémoire cache - Évaluation des différentes performaces de mémoire cache

## Travailler sur les ordi de l'ENSTA depuis chez soi avec ssh

`ssh -tX <username>@relais.ensta.fr salle`
<Entrer votre mot de passe de session>

Puis réactiver le dossier .bashrc crée avec :
`source .bashrc`

## Préparation

`cd /home/g/gbusnot/ES201/`
```cp tools/blowfish_modified.tar.gz ~/<votre dossier de destination>```
```cp -r tools/Cacti ~/<votre dossier de destination>```
```cp -r TPs/TP5 ~/<votre dossier de destination>```

```cd  ~/<votre dossier de destination>```
```tar -xzvf ./blowfish_modified.tar.gz```

## 1) Profiling de l'application

### Q1)

```sim-profile -iclass dijkstra_small.ss input.dat```

| type | load | store | uncond branch | cond branch | int computation | fp computation | trap |
|------|------|-------|---------------|-------------|-----------------|----------------|------|
|  %   | 24.13| 10.34 |     1.06      |    14.69    |      49.77      |      0.00      | 0.00 |

```sim-profile bf.ss input_small.asc```

| type | load | store | uncond branch | cond branch | int computation | fp computation | trap |
|------|------|-------|---------------|-------------|-----------------|----------------|------|
|  %   | 8.12 | 45.61 |     2.18      |    11.37    |      32.62      |      0.00      | 0.10 |

### Q2)

Pour Djikstra, on constate que plus de 45% des instructions exécutées sont des instructions de calcul entier.
En effet, l'algorithme utilise des boucles qui prennent du temps à être gérées. Ils faut donc chercher à optimiser le code au niveau de ces boucles. Il est également possible d'ajouter du parallélisme afin d'améliorer les performances de l'algorithme.

Pour blowfish, la part des instructions de calcul entier est également non négligeable (32.62%). Les mêmes améliorations que celles évoquées précédemment peuvent donc être utilsées. Cependant, ce sont les instructions d'écriture qui occupent ici le plus le temps d'exécution. Il faut donc en priorité améliorer les accès mémoire.

### Q3)

P2 -> SCA2-BCS
P1 -> produit de polynomes (p.74)
SHA 1 -> aller dans le répertoire sha, puis ```sim-profile -iclass sha.ss input_small.asc```

| type | load | store | uncond branch | cond branch | int computation | fp computation | trap |
|------|------|-------|---------------|-------------|-----------------|----------------|------|
|  %   |16.72 | 8.12  |     0.08      |    6.10     |      68.99      |       0.0      | 0.0  |

#

## 2) Evaluation des performances

### Q4)

(LES RESULTATS SONT PEUT ETRE DEJA DANS RESULT_A7.TXT, VERIFIER QU'ON OBTIENT LA MEME CHOSE)

```-cache:il1 il1:32:32:2:l -cache:dl1 dl1:32:32:2:l -cache:dl2 ul2:2048:32:8:l -bpred bimod -bpred:btb 256 4 -fetch:mplat 8 -fetch:ifqsize 4 -decode:width 2 -issue:width 4 -commit:width 2 -ruu:size 2 -lsq:size 8 -res:ialu 1 -res:imult 1 -res:fpalu 1 -res:fpmult 1 bf.ss input_small.asc```
(Voir réponses sur document excel)

### Q5)

```-cache:il1 il1:16:64:2:l -cache:dl1 dl1:16:64:2:l -cache:dl2 ul2:512:64:16:l -bpred 2lev -bpred:btb 256 4 -fetch:mplat 15 -fetch:ifqsize 8 -decode:width 4 -issue:width 8 -commit:width 4 -ruu:size 16 -lsq:size 16 -res:ialu 5 -res:imult 1 -res:fpalu 1 -res:fpmult 1 bf.ss input_small.asc```
(Voir réponses sur document excel)

#

## 3) Efficacité Surfacique

### Q6) Paramètres de cache par défaut
	
* **Taille de cache**: 134217728 bytes
* **Taille de bloc**: 64 bytes
* **Associativité**:  1
* **Technologie**: 0.000032 nm


### Q7) Surface des caches L1 (Tableau 14)
[Google Sheets Calculs](https://docs.google.com/spreadsheets/d/1iSC1euwixXFIzijyxn1Y2PYIEXpdgLjwwPu0X-UspfE/edit?usp=sharing)


| - |A15 |A7|
|---|---|---|
|Surface des caches L1| 0,09331925309  |  0,09296325931 |
|Surface du Cortex|  2 | 0,45  |
|Pourcentage de la surface occupé L1| 4,665962654  |  20,65850207 |
|Taille du Cortex hors L1| 1,906680747  | 0,3570367407  |


**Analyse**:


### Q8) Surfaces Totales du Cortex A7 et Cortex A15  + L1 (Taille variable) + L2

[Google Sheets Calculs](https://docs.google.com/spreadsheets/d/1iSC1euwixXFIzijyxn1Y2PYIEXpdgLjwwPu0X-UspfE/edit?usp=sharing)


| Taille |- |Surfaces|
|---|---|---|
| - |A15 |A7|
|1| -----------  |  0,8520783492 |
|2|  2,349974136 | 0,8675189534  |
|4| 2,336626858  |  0,8567088511 |
|8| 2,357860259  | 0,8748594901  |
|16| 2,361590406  |  0,891898881 |
|32|  2,417846398 | 0,934599328  |

### Q9) Efficacité surfacique de chaque processeur


#

## 4) Éfficacité Énergétique

### Q10)

À la fréquence maximale, la consommation des processeurs est :
Cortex A7 : 100 mW (0.1*1000)
Cortex A15 : 500 mW (0.2 * 2500)

### Q11)



## 5) Architecture Système big.LITTLE

### Q12)