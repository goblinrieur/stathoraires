## Commande 

psql perso < commands > output.txt
 
## output.txt

ce fichier est le fichier de sortie du graph en mode texte formaté 


## commands

ce fichier est le fichier qui contient les commandes SQL ainsi que les variables de mises en forme et enfin la commande SQL à passer 
 
## GUI MODE 

utiliser commands\_GUI

ça génère un JPEG

## JPEG

output\_graphic.jpeg

## procédure d exemple 

psql perso < commands\_GUI && firefox ./output\_graphic.jpeg
 
# exemple d'utilisation 

```
psql perso -t -c " select id,heuredepart,heuredebut,heurerepas,heurefinrepas,heurefin,heureretour,trajet,tempsjournalier from suivihoraire where date>= '2020-01-01' order by id ; " > /tmp/toto 
gnuplot --persist << EOF
set datafile separator "|"
set xlabel "measures"
set ylabel "hours"
set grid ls 24
set title font "Helvetica,20,bold"
set title "workload and roadtime : ".strftime("%d %b %Y", time(0))
set sample 1000
set yrange [0:21]
set terminal png background rgb 'dark-grey' size 1024,768
set output '/tmp/timesurvey.png'
plot "/tmp/toto" using 1:2 title "go" with lines , "/tmp/toto" using 1:3 with lines title "start" lt rgb "blue", "/tmp/toto" using 1:4  with lines lt rgb "dark-blue" smooth bezier title "lunch", "/tmp/toto" using 1:5  with lines lt rgb "dark-cyan" smooth bezier title "back" , "/tmp/toto" using 1:6  with lines lt rgb "orange" title "end", "/tmp/toto" using 1:7  with lines lt rgb "red" title "backhome" , "/tmp/toto" using 1:8  with lines lt rgb "dark-green" title "road", "/tmp/toto" using 1:9  with lines lt rgb "yellow" title "workload"
pause mouse close
EOF
```

