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
fieldnames = ['video-name','f-init','n-frames','video-frames','label-idx']
writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
writer.writeheader()
os.chdir(path_d)
for line in File.readlines():
	key = line.split(".")[0]
	if(key in data['database'].keys()):
		vid = cv2.VideoCapture(line.split("\n")[0])
		vid_frames = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
		FPS = vid.get(cv2.CAP_PROP_FPS)
		start_tim = data['database'][key]['annotations'][0]['segment'][0] 
		end_tim = data['database'][key]['annotations'][0]['segment'][1] 
		f_init = int(FPS * start_tim)
		n_frames = int(FPS * (end_tim -start_tim))
		#print("%s %s"%(vid_frames/vid.get(cv2.CAP_PROP_FPS),data['database'][key]['url']))
		writer.writerow({'video-name': "v_%s"%key, 'f-init':f_init, 'n-frames':n_frames, 'video-frames': vid_frames, 'label-idx':data['database'][key]['annotations'][0]['label']})
File.close()

