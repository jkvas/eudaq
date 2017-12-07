#!/bin/bash

OUTDIR="/home/kvas/EUDAQ2.1/eudaq_cosmics_2017/eudaq/user/desytable/misc/conf/generated/"
HOR_MINPOSITION=-45
HOR_MAXPOSITION=45
# HOR_MINPOSITION=-345
# HOR_MAXPOSITION=345
HOR_STEP=30

VERT_MINPOSITION=-45
VERT_MAXPOSITION=45
# VERT_MINPOSITION=-345
# VERT_MAXPOSITION=345
VERT_STEP=30
SECONDS=1200
EVENTS=1000

rm ./generated/stage*

cp stage.ini ${OUTDIR}stage.ini

PREVFILE="${OUTDIR}stage_final.conf"
cat stage.conf |\
    sed 's/STAGEGENERATE_SECONDS/100000000/g' |\
    sed 's/STAGEGENERATE_EVENTS/100000000000/g' |\
    sed 's/STAGEGENERATE_HOR/10000000000/g' |\
    sed 's/STAGEGENERATE_VERT/10000000000/g' \
    >${PREVFILE}

x=0
for y in  `seq ${VERT_MINPOSITION} ${VERT_STEP} ${VERT_MAXPOSITION}`
do
    HFROM=${HOR_MINPOSITION}; HSTEP=${HOR_STEP} ; HTO=${HOR_MAXPOSITION}
    if [ ${x} -eq ${HOR_MAXPOSITION} ]
    then
	HFROM=${HOR_MAXPOSITION}
	(( HSTEP = ( - 1 ) * ( ${HOR_STEP} ) ))
	HTO=${HOR_MINPOSITION}
    fi
    
    for x in `seq ${HFROM} ${HSTEP} ${HTO}`
    do
	NEWFILE="${OUTDIR}stage_y${y}_x${x}.conf"
	echo "generating file for X=${x}, Y=${y}"
	cat stage.conf |\
	    sed "s#STAGEGENERATE_FILE#${PREVFILE}#g" |\
	    sed "s/STAGEGENERATE_SECONDS/${SECONDS}/g" |\
	    sed "s/STAGEGENERATE_EVENTS/${EVENTS}/g" |\
	    sed "s/STAGEGENERATE_HOR/${x}/g" |\
	    sed "s/STAGEGENERATE_VERT/${y}/g" \
		>${NEWFILE}
	PREVFILE=${NEWFILE}
    done
done
mv $PREVFILE "${OUTDIR}stage_y${y}_x${x}_first.conf"	

       
