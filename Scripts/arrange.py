import json
path_s = "/home/supunK/Scripts"
path_d = "/home/supunK/DataSet"
with open('%s/dataset.json'%(path_s)) as f:
	data = json.load(f)
Url_File = open("%s/Urls.log"%(path_s),"w")
Id_File = open("%s/Ids.log"%(path_s),"w")
for video in data['database']:
	Url_File.write("%s\n"%(data['database'][video]['url']))
	Id_File.write("%s\n"%(video))
Url_File.close()
Id_File.close()
