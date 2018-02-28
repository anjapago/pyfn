#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/setup.sh"

show_help() {
cat << EOF
Usage: ${0##*/} [-h] -x XP_NUM -p {rofames,open-sesame} -s {dev,test} -f FN_DATA_DIR
Preprocess FrameNet train/dev/test splits.

  -h, --help                           display this help and exit
  -x, --xp      XP_NUM                 xp number written as 3 digits (e.g. 001)
  -p, --parser  {rofames,open-sesame}  frame semantic parser to be used: 'rofames' or 'open-sesame'
  -s, --splits  {dev,test}             which splits to score: dev or test
  -f, --fn      FN_DATA_DIR            absolute path to FrameNet data directory
EOF
}

is_xp_set=FALSE
is_parser_set=FALSE
is_splits_set=FALSE
is_fndir_set=FALSE

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
        -x|--xp)
            if [ "$2" ]; then
                is_xp_set=TRUE
                xp="xp_$2"
                shift
            else
                die "ERROR: '--xp' requires a non-empty option argument"
            fi
            ;;
        -p|--parser)
            if [ "$2" ]; then
                is_parser_set=TRUE
                parser=$2
                shift
            else
                die "ERROR: '--parser' requires a non-empty option argument"
            fi
            ;;
        -s|--splits)
            if [ "$2" ]; then
                is_splits_set=TRUE
                splits=$2
                shift
            else
                die "ERROR: '--splits' requires a non-empty option argument"
            fi
            ;;
        -f|--fn)
            if [ "$2" ]; then
                is_fndir_set=TRUE
                FN_DATA_DIR=$2
                shift
            else
                die "ERROR: '--fn' requires a non-empty option argument"
            fi
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac
    shift
done

if [ "${is_xp_set}" = FALSE ]; then
    die "ERROR: '--xp' parameter is required."
fi

if [ "${is_parser_set}" = FALSE ]; then
    die "ERROR: '--parser' parameter is required."
fi

if [ "${is_splits_set}" = FALSE ]; then
    die "ERROR: '--splits' parameter is required."
fi

if [ "${is_fndir_set}" = FALSE ]; then
    die "ERROR: '--fn' parameter is required."
fi

case "${splits}" in
    dev )
        ;;
    test )
        ;;
    * )
        die "Invalid splits '${splits}': should be 'dev' or 'test'"
esac

case "${parser}" in
    rofames )
        ;;   #fallthru
    open-sesame )
        ;;   #fallthru
    * )
        die "Invalid frame semantic parser '${parser}': Should be 'rofames' or 'open-sesame'"
esac

echo "Generating gold SEMEVAL XML file..."
pyfn convert \
  --from fnxml \
  --to semeval \
  --source "${FN_DATA_DIR}" \
  --target "${XP_DIR}/${xp}/data"
echo "Done"

if [ "${parser}" = "rofames" ]; then
  echo "Copying framenet.frame.element.map file to XP data directory"
  cp ${FN_DATA_DIR}/framenet.frame.element.map ${XP_DIR}/${xp}/data
  echo "Copying frames.xml file to XP data directory"
  cp ${FN_DATA_DIR}/frames.xml ${XP_DIR}/${xp}/data
  echo "Copying frRelations.xml file to XP data directory"
  cp ${FN_DATA_DIR}/frRelations.xml ${XP_DIR}/${xp}/data
fi

if [ "${parser}" = "open-sesame" ]; then
  echo "Copying glove.6B.100d.framevocab.txt file to XP data directory"
  cp ${FN_DATA_DIR}/glove.6B.100d.framevocab.txt ${XP_DIR}/${xp}/data
  echo "Copying frames.xml file to XP data directory"
  cp ${FN_DATA_DIR}/frames.xml ${XP_DIR}/${xp}/data
  echo "Copying frRelations.xml file to XP data directory"
  cp ${FN_DATA_DIR}/frRelations.xml ${XP_DIR}/${xp}/data
fi