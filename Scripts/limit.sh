path=$1

python $path/arrange_victim.py

for id in `cat $path/victim.log`; do
	if [ -f $path/DataSet/$id* ]; then
		ls $path/DataSet/$id*
		rm -f $path/DataSet/$id*
	fi
done
