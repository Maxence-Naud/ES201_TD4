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

## 2) Evaluation des performances

Notes pour commencer :
Pour mesurer les perf, utiliser sim-cache (voir p 117) :
Réglage A7 :
```sim-cache -cache:il1 il1:32:32:2:l -cache:dl1 dl1:32:32:2:l  -cache:dl2 ul2:512:32:8:l dijkstra_small.ss```

Réglage A15 :
```sim-cache -cache:il1 il1:32:64:2:l -cache:dl1 dl1:32:64:2:l  -cache:dl2 ul2:512:64:16:l dijkstra_small.ss```

### Q4)

(LES RESULTATS SONT PEUT ETRE DEJA DANS RESULT_A7.TXT, VERIFIER QU'ON OBTIENT LA MEME CHOSE)
```-cache:il1 il1:512:32:2:l -cache:dl1 dl1:512:32:2:l -cache:dl2 ul2:2048:32:8:l -bpred bimod -bpred:btb 256 4 -fetch:mplat 8 -fetch:ifqsize 4 -decode:width 2 -issue:width 4 -commit:width 2 -ruu:size 2 -lsq:size 8 -res:ialu 1 -res:imult 1 -res:fpalu 1 -res:fpmult 1 bf.ss```

```-cache:il1 il1:16:64:2:l -cache:dl1 dl1:16:64:2:l -cache:dl2 ul2:512:64:16:l -bpred 2lev -bpred:btb 256 4 -fetch:mplat 15 -fetch:ifqsize 8 -decode:width 4 -issue:width 8 -commit:width 4 -ruu:size 16 -lsq:size 16 -res:ialu 5 -res:imult 1 -res:fpalu 1 -res:fpmult 1 bf.ss input_small.asc```