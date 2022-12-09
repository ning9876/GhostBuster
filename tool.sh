taskrunner_prefix="_test/"
taskrunner_suffix=".sh"

__DIR__=$(dirname $(readlink -f $0))
. $(dirname $__DIR__)/bin/taskrunner
