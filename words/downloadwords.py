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
	for word in list:
		japanese = word.get("japanese").strip()
		kana = word.get("kana").strip()
		chinese = word.get("chinese").strip()
		type1 = word.get("type1").strip()
		type2 = word.get("type2").strip()
		tone1 = word.get("tone1")
		tone2 = word.get("tone2")
		isHiragana = word.get("ishiragana")
		hira = "no"
		if isHiragana:
			hira = "yes"
		print japanese + "," + kana  + "," +  chinese + "," + type1 + "," + type2 + "," + "%s,%s"%(tone1,tone2)  + "," + hira  + "," + classname + ",,"

def updateChineseOfClass(classname) :
	print "update:" + classname
	query = leancloud.Query(classname)
	# query = Query()
	query.add_ascending("createdAt")
	list = query.find()
	for word in list:
		chinese = word.get("chinese").strip()
		print chinese
		word.set("chinese",chinese);
		word.save()

def addBookName(classID,className,bookName):
	ClassObj = leancloud.Object.extend("ClassList")
	classToPost = ClassObj()
	classToPost.set("ClassID",classID);
	classToPost.set("ClassName",className);
	classToPost.set("Book",bookName);
	classToPost.save()


print "Update server"
leancloud.init("kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz", "aGRwOxwVWSaBmrPT0xrsek1O")
for x in xrange(1,21):
	listWordOfClass("Class" + str(x))
# for x in xrange(1,21):
# 	time.sleep(1)
# 	addBookName("Class"+str(x),u"第"+str(x)+u"课",u"新编日语第一册")
print "Process Finished"




