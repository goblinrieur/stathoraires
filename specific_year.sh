#! /usr/bin/env bash
function init(){
if [ $# -lt 1 ] ; then
    export flag=1
else
    export flag=0
fi
}

function choice(){
if [ $flag == 1 ] ; then
    psql francois -t -c " select id,heuredepart,heuredebut,heurerepas,heurefinrepas,heurefin,heureretour,trajet,tempsjournalier from suivihoraire where date>= '2021-01-01' order by id ; " > /tmp/toto 
else
    psql francois -t -c " select id,heuredepart,heuredebut,heurerepas,heurefinrepas,heurefin,heureretour,trajet,tempsjournalier from suivihoraire where date>= '\"$1-01-01\"' order by id ; " > /tmp/toto 
    if [ $? -ne 0 ] ; then
        echo
        echo "failed to extract datas"
        echo
        exit 1
    fi
fi
}

function drawit(){
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
set output './timesurvey.png'
plot "/tmp/toto" using 1:2 title "go" with lines , "/tmp/toto" using 1:3 with lines title "start" lt rgb "blue", "/tmp/toto" using 1:4  with lines lt rgb "dark-blue" smooth bezier title "lunch", "/tmp/toto" using 1:5  with lines lt rgb "dark-cyan" smooth bezier title "back" , "/tmp/toto" using 1:6  with lines lt rgb "orange" title "end", "/tmp/toto" using 1:7  with lines lt rgb "red" title "backhome" , "/tmp/toto" using 1:8  with lines lt rgb "dark-green" title "road", "/tmp/toto" using 1:9  with lines lt rgb "yellow" title "workload"
pause mouse close
EOF
if [ $? -ne 0 ] ; then
    echo
    echo "failed to draw data to picture"
    echo
    exit 1
fi
}

echo note : you can also ask a specific year 
echo $0 2019 # for example

init
choice "$1"
drawit
exit 0
