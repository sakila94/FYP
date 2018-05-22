path_s = "/home/supunK/Scripts"
path_d = "/home/supunK/DataSet"

source activate tensorflow
python $path_s/arrange.py 
for url in `cat $path_s/Urls.log`; do
	youtube-dl -o $path_d'/DataSet/%(id)s.%(ext)s'  $url 
done
lines=`cat Ids.log | wc - l`
echo $lines were downloaded
source deactivate
