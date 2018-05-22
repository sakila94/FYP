#python arrange.py
path_s=/home/supunK/Scripts
path_d=/home/supunK/DataSet
rm -f $path_s/exist.log $path_s/exist_file.log
touch $path_s/exist.log
touch $path_s/exist_file.log
cd $path_d
for id in `cat $path_s/Ids.log`; do
	exist=`find $path_d -name "$id*" -exec echo 1 \;`
	if [ "$exist" == "1" ]
	then
		echo $id >> $path_s/exist.log
		ls $id* >> $path_s/exist_file.log
	fi
cd -
	
done

