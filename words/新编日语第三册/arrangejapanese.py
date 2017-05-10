#!/usr/bin/python
# -*- coding: UTF-8 -*-

import re 
import sys
import os
import leancloud
import time

def processWordType(type):
	type = type.strip()
	if type == u"名":
		return u"名词"
	elif type == u"数":
		return u"数词"
	elif type == u"代":
		return u"代词"
	elif type == u"副":
		return u"副词"
	elif type == u"形":
		return u"形容词"
	elif type == u"形动":
		return u"形容动词"
	elif type == u"组":
		return u"词组"
	elif type == u"叹":
		return u"叹词"
	elif type == u"接":
		return u"接词"
	elif type == u"专":
		return u"专有名词"
	elif type == u"连体":
		return u"连体词"
	return type

def containEnglish(string):
	regex =  r"[a-zA-Z]+"
	pattern = re.compile(regex)
	results = pattern.search(string)
	if results:
		return True;
	else:
		return False;

def handleComponents(components):

	japanese = components[1].strip()
	kana = components[2].strip()
	chinese = components[5].strip()
	classname = components[0].strip()
	# isHiragana = components[5]
	types = components[4].split(u'，')
	tones = components[3].split(u'，')
	tone1 = -1
	tone2 = -1
	tone3 = -1
	if len(tones) >= 1:
		tone1 = tones[0]
	if len(tones) >= 2:
		tone2 = tones[1]
	if len(tones) >= 3:
		tone3 = tones[2]
	type1 = ""
	type2 = ""
	type3 = ""
	if len(types) >= 1:
		type1 = processWordType(types[0].strip())
	if len(types) >= 2:
		type2 = processWordType(types[1].strip())
	if len(types) >= 3:
		type3 = processWordType(types[2].strip())

	isHiragana = containEnglish(kana)
	if isHiragana:
		temp = kana
		kana = japanese
		japanese = temp

	hira = "no"
	if isHiragana:
		hira = "yes"

	print japanese + "," + kana  + "," +  chinese + "," + type1 + "," + type2 + "," + type3 + "," + "%s,%s,%s"%(tone1,tone2,tone3)  + "," + hira  + ",Class" + classname

	# wordDict = {
	# 	"japanese":japanese.strip(),
	# 	"kana":kana.strip(),
	# 	"chinese":chinese.strip(),
	# 	"ishiragana":isHiragana,
	# 	"type1":type1.strip(),
	# 	"type2":type2.strip(),
	# 	"tone1":tone1,
	# 	"tone2":tone2
	# }
	# return wordDict


def seperateComponent(originalLine):
	
	components = originalLine.split(',')
	return components
def replaceChars(originalLine):
	newLine = originalLine.replace(u'(',u'（')
	newLine = newLine.replace(u')',u'）')
	newLine = newLine.replace(u':',u'：')
	return newLine
def handleLine(originalLine):
	newLine = replaceChars(originalLine)
	components = seperateComponent(newLine);
	if len(components) == 6:
		word = handleComponents(components)
		words.append(word);
	else:
		print "/// Can't parse " + originalLine
		sys.exit(1)

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
	# print "Upload to server"
	# leancloud.init("kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz", "aGRwOxwVWSaBmrPT0xrsek1O")
	# i = 0
	# classIndex = os.path.basename(originalFilePath)[:-4]
	# for word in words:
	# 	i = i + 1
	# 	print "%s/%s : %s"%(i,len(words),word["kana"])
	# 	postWord("Class" + classIndex ,word)
	# 	time.sleep( 1 )

	print "Process Finished"
else:
	print "Please input a file with .csv"



