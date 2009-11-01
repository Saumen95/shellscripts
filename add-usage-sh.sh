#!/bin/sh
#
# SCRIPT: add-usage-sh.sh
# AUTHOR: Janos Gyerik <janos.gyerik@gmail.com>
# DATE:   2005-08-23
# REV:    1.0.T (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Add a sample command-line parser and usage() function to a shell 
#          script."
#
# REV LIST:
#        DATE:	DATE_of_REVISION
#        BY:	AUTHOR_of_MODIFICATION   
#        MODIFICATION: Describe what was modified, new features, etc-
#
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#          

usage() {
    test $# = 0 || echo $@
    echo "Usage: $0 [OPTION]... [FILE]..."
    echo "Add a sample command-line parser and usage() function to a shell script."
    echo
    echo "  -h, --help            Print this help"
    echo
    exit 1
}

args=
#flag=off
#param=
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    -p|--param) shift; param=$1 ;;
#    --) shift; while [ $# != 0 ]; do args="$args \"$1\""; shift; done; break ;;
    -?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
#    *) test "$arg" && usage || arg=$1 ;;  # strict with excess arguments
    esac
    shift
done

eval "set -- $args"

test $# = 0 && usage

tmp=/tmp/.add-usage-sh.$$
trap 'rm -f $tmp; echo $tmp; exit 1' 1 2 3 15
cat << "EOF" > $tmp
usage() {
    test $# = 0 || echo $@
    echo "Usage: $0 [OPTION]... [ARG]..."
    echo "BRIEF DESCRIPTION OF THE SCRIPT"
    echo
    echo "  -h, --help            Print this help"
    echo
    exit 1
}

args=
#arg=
#flag=off
#param=
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    -p|--param) shift; param=$1 ;;
#    --) shift; while [ $# != 0 ]; do args="$args \"$1\""; shift; done; break ;;
    -?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
#    *) test "$arg" && usage || arg=$1 ;;  # strict with excess arguments
#    *) arg=$1 ;;  # forgiving with excess arguments
    esac
    shift
done

eval "set -- $args"

#test $# = 0 && usage

EOF

work=$tmp.work
for i in "$@"; do
    test -f "$i" || continue
    sed -e "
/^$/ {
r $tmp
: rest
n
b rest
}
" "$i" > $work
    test $? = 0 && cp $work "$i"
done

rm -f $tmp $work

# eof
