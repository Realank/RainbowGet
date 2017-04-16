#!/usr/bin/python
# -*- coding: UTF-8 -*-

import re 
import sys
import os
import leancloud
import time

def postWord(classname,word) :
	ClassObj = leancloud.Object.extend(classname)
	classToPost = ClassObj()
	classToPost.set("japanese",word["japanese"]);
	classToPost.set("kana",word["kana"]);
	classToPost.set("chinese",word["chinese"]);
	classToPost.set("ishiragana",word["ishiragana"]);
	classToPost.set("type1",word["type1"]);
	classToPost.set("type2",word["type2"]);
	classToPost.set("type3",word["type3"]);
	classToPost.set("tone1",word["tone1"]);
	classToPost.set("tone2",word["tone2"]);
	classToPost.set("tone3",word["tone3"]);
	classToPost.set("classname",word["classname"]);
	classToPost.set("wordid",word["wordid"]);
	classToPost.set("starttime",word["starttime"]);
	classToPost.set("periodtime",word["periodtime"]);
	classToPost.set("audiofile",word["audiofile"]);
	classToPost.save()
	print word["chinese"] + "uploaded"

def seperateComponent(originalLine):
	return originalLine.strip().split(',')

def handleLine(originalLine):
	components = seperateComponent(originalLine);
	if components:
		word = handleComponents(components)
		words.append(word);
	else:
		print "/// Can't parse " + originalLine
		sys.exit(1)
def handleComponents(components):
	if len(components) != 15:
		print "/// Can't parse " + components[0]
		sys.exit(1)

	japanese = components[0]
	kana = components[1]
	chinese = components[2]
	type1 = components[3]
	type2 = components[4]
	type3 = components[5]
	tone1 = components[6]
	tone2 = components[7]
	tone3 = components[8]
	isHiragana = components[9]
	classname = components[10]
	wordid = components[11]
	starttime = components[12]
	periodtime = components[13]
	audiofile = components[14]
	
	wordDict = {
		"japanese":japanese.strip(),
		"kana":kana.strip(),
		"chinese":chinese.strip(),
		"ishiragana":isHiragana,
		"type1":type1.strip(),
		"type2":type2.strip(),
		"type3":type3.strip(),
		"tone1":tone1,
		"tone2":tone2,
		"tone3":tone3,
		"classname":classname,
		"wordid":wordid,
		"starttime":starttime,
		"periodtime":periodtime,
		"audiofile":audiofile,
	}
	return wordDict

def arrangeFile(originalFilePath):
	filePathArr = os.path.split(originalFilePath)
	originalFileDirectory = filePathArr[0]
	originalFileName = filePathArr[1]
	print "Arrange file:" + originalFileName
	if len(originalFileDirectory) <= 0:
		originalFileDirectory = "."
	originalFile = open(originalFilePath)
	newLine = originalFile.readline()
	while len(newLine) > 0 :
		newLine = newLine.decode('utf-8')
		handleLine(newLine)
		newLine = originalFile.readline()
	originalFile.close()



if len(sys.argv) != 2:
	print "Please input file name"
	exit()

originalFilePath = sys.argv[1]
words = list()
if originalFilePath.rfind(".csv") > 0:
	arrangeFile(originalFilePath)
	print "Loaded %s words"%(len(words))
	print "Upload to server"
	leancloud.init("kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz", "aGRwOxwVWSaBmrPT0xrsek1O")
	i = 0
	classIndex = os.path.basename(originalFilePath)[:-4]
	for word in words:
		postWord("BOOK2_NEW",word)

	print "Process Finished"
else:
	print "Please input a file with .csv"
