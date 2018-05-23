import json
import os
import csv
import cv2

path_s = "/home/supunK/FYP-activityNet/Scripts"
path_d = "/home/supunK/DataSet"
#os.system("sh %s/exist.sh"%(path_s))
#os.system('ls')

with open('%s/dataset.json'%(path_s)) as f:
	data = json.load(f)
File = open("%s/exist_file.log"%(path_s),"r")
csv_file = open("%s/labels.csv"%(path_s),"w")
fieldnames = ['video_name','f-init','n-frames','video-frames','label-idx']
writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
writer.writeheader()
os.chdir(path_d)
for line in File.readlines():
	key = line.split(".")[0]
	if(key in data['database'].keys()):
		vid = cv2.VideoCapture(line.split("\n")[0])
		n_frames = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
		writer.writerow({'video_name': line, 'f-init':0, 'n-frames':n_frames, 'video-frames': 0, 'label-idx':data['database'][key]['annotations'][0]['label']})
File.close()

