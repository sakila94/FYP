import json
path_s = "/home/supunK/Scripts"
path_d = "/home/supunK/DataSet"

with open('%s/dataset.json'%(path_s)) as f:
	data = json.load(f)
File = open("%s/victim.log"%(path_s),"w")
for video in data['database']:
	if(data['database'][video]['subset'] != "training"):
		File.write("%s\n"%(video))
File.close()
