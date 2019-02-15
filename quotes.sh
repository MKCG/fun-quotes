#!/bin/bash

[ $(which strfile) ] || exit 1
[ $(which fortune) ] || exit 1

makeFortunes () {
    local FORTUNES_DIRECTORY=$(cd `dirname $0` && pwd)/fortunes

    if [ -d $FORTUNES_DIRECTORY ] ; then
        for FORTUNE_NAME in $(ls -A $FORTUNES_DIRECTORY | grep -v -E ".*\.dat$" ) ; do
            local DAT_FORTUNE="${FORTUNES_DIRECTORY}/${FORTUNE_NAME}.dat"

            if [ -f $DAT_FORTUNE ] ; then
                continue
            fi

            echo "Generating fortunes for $FORTUNE_NAME"
            strfile ${FORTUNES_DIRECTORY}/${FORTUNE_NAME} > /dev/null
        done
    fi
}

exportAliases () {
    local ALIASES_FILE=$(cd `dirname $0` && pwd)/aliases.sh
    local FORTUNES_DIRECTORY=$(cd `dirname $0` && pwd)/fortunes

    touch $ALIASES_FILE
    chmod 777 $ALIASES_FILE

    echo "#!/bin/sh" > $ALIASES_FILE

    if [ -d $FORTUNES_DIRECTORY ] ; then
        for FORTUNE in $(ls -A $FORTUNES_DIRECTORY | grep -E ".*\.dat$" ) ; do
            FORTUNE_NAME=$(echo $FORTUNE | sed -e "s/.dat//")
            echo "alias quote_${FORTUNE_NAME}=\"fortune ${FORTUNES_DIRECTORY}/${FORTUNE_NAME}\"" >> $ALIASES_FILE
            echo "alias cow_quote_${FORTUNE_NAME}=\"quote_${FORTUNE_NAME} | cowsay\"" >> $ALIASES_FILE
        done
    fi
}

makeFortunes
exportAliases
