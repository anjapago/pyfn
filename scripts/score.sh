#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/setup.sh"

show_help() {
cat << EOF
Usage: ${0##*/} [-h] -x XP_NUM -s {dev,test}
Score frame semantic parsing with the SEMEVAL scoring scripts modified by Kshirsagar et al. (2015).

  -h, --help                display this help and exit
  -x, --xp      XP_NUM      xp number written as 3 digits (e.g. 001)
  -s, --splits  {dev,test}  which splits to score: dev or test
EOF
}

is_xp_set=FALSE
is_splits_set=FALSE

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
        -s|--splits)
            if [ "$2" ]; then
                is_splits_set=TRUE
                splits=$2
                shift
            else
                die "ERROR: '--splits' requires a non-empty option argument"
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

if [ "${is_splits_set}" = FALSE ]; then
    die "ERROR: '--splits' parameter is required."
fi

case "${splits}" in
    dev )
        ;;
    test )
        ;;
    * )
        die "Invalid splits '${splits}': should be 'dev' or 'test'"
esac

mkdir ${XP_DIR}/${xp}/score 2> /dev/null

echo "Scoring with Kshirsagar et al. (2015) ACL perl script..."
perl ${SEMEVAL_HOME}/score.acl.pl \
    -c "${XP_DIR}/${xp}/score" \
    -l \
    -n \
    -e \
    -a \
    -v \
    "${XP_DIR}/${xp}/data/frames.xml" \
    "${XP_DIR}/${xp}/data/frRelations.xml" \
    "${XP_DIR}/${xp}/data/${splits}.gold.xml" \
    "${XP_DIR}/${xp}/data/${splits}.predicted.xml" > "${XP_DIR}/${xp}/score/${splits}.score.acl.semeval"
echo "Done"