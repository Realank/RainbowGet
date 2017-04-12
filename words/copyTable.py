#!/usr/bin/python
# -*- coding: UTF-8 -*-

import re 
import sys
import os
import leancloud
import time
def listWordOfClass(classname) :
	# print "========list:" + classname
	query = leancloud.Query(classname)
	# query = Query()
	query.add_ascending("createdAt")
	list = query.find()
	for row in list:
		rows.append(row)
def postWord(classname,obj) :
	ClassObj = leancloud.Object.extend(classname)
	classToPost = ClassObj()
	for key in obj.attributes.keys():
		if key != u"objectId" and key != u"updatedAt" and key != u"createdAt":
			classToPost.set(key,obj.get(key))
		
	classToPost.save()

if len(sys.argv) != 3:
	print "Please input table names"
	exit()

comeTable = sys.argv[1]
toTable = sys.argv[2]
rows = list()

leancloud.init("kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz", "aGRwOxwVWSaBmrPT0xrsek1O")
listWordOfClass(comeTable)
print "Loaded %s row"%(len(rows))
print "Upload to server"

i = 0
for row in rows:
	postWord(toTable,row)

print "Process Finished"





