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

```sim-profiling -iclass djikstra_small input.dat```

| type | load | store | uncond branch | cond branch | int computation | fp computation | trap |
|------|------|-------|---------------|-------------|-----------------|----------------|------|
|  %   | 24.13| 10.34 |     1.06      |    14.69    |      49.77      |      0.00      | 0.00 |

`sim-profile bf.ss input_small.asc`

| type | load | store | uncond branch | cond branch | int computation | fp computation | trap |
|------|------|-------|---------------|-------------|-----------------|----------------|------|
|  %   | 8.12 | 45.61 |     2.18      |    11.37    |      32.62      |      0.00      | 0.10 |

### Q2)

