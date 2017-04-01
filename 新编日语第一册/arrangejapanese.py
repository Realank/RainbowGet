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
	classToPost.set("tone1",word["tone1"]);
	classToPost.set("tone2",word["tone2"]);
	classToPost.save()

def processTone(tone):
	tone = tone.strip()
	if tone == u"Ⓞ" or tone == u"◎":
		return 0
	elif tone == u"①":
		return 1
	elif tone == u"②":
		return 2
	elif tone == u"③":
		return 3
	elif tone == u"④":
		return 4
	elif tone == u"⑤":
		return 5
	elif tone == u"⑥":
		return 6
	elif tone == u"⑦":
		return 7
	elif tone == u"⑧":
		return 8
	elif tone == u"⑨":
		return 9
	else:
		return -1;
	

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

def handleComponents(components):
	japanese = components[1]
	kana = components[0]
	chinese = components[4]
	isHiragana = components[5]
	types = components[2]
	tones = components[3]
	tone1Str = tones[:1]
	if len(tones) == 0:
		tone1Str = u"Ⓞ"
	tone1 = processTone(tone1Str)
	tone2 = processTone(tones[1:2])
	types = types.split(u"·")
	type1 = types[0]
	type1 = processWordType(type1)
	type2 = ""
	if len(types) > 1:
		type2 = types[1]
		type2 = processWordType(type2)
	wordDict = {
		"japanese":japanese.strip(),
		"kana":kana.strip(),
		"chinese":chinese.strip(),
		"ishiragana":isHiragana,
		"type1":type1.strip(),
		"type2":type2.strip(),
		"tone1":tone1,
		"tone2":tone2
	}
	return wordDict

def parseLine(originalLine,regex):
	pattern = re.compile(regex)
	results = pattern.findall(originalLine)
	return results;

def seperateComponent(originalLine):
	tones = u"[Ⓞ◎①②③④⑤⑥⑧⑨]"
	chineseJapanese = u"[\u4E00-\u9FA5\uF900-\uFA2D\u3040-\u309F\u30A0-\u30FF\u30A0-\u30FF]"
	regex1 =  u"(" +chineseJapanese + u"+)\s*(?:（([\W]+)）)?\W*【(\W+)】\s*(" + tones + u"{0,2})\s*：?\s*(\W*)"
	regex2 =  u"(" +chineseJapanese + u"+)\s*(?:（([\S\s]+)）)?\W*【(\W+)】\s*(" + tones + u"{0,2})\s*：?\s*(\W*)"
	isHira = True
	results = parseLine(originalLine, regex1)
	if len(results) == 0 :
		isHira = False
		results = parseLine(originalLine, regex2)

	if len(results) == 0 :
		return None

	group = results[0]
	hira = u"\t平假名"
	if isHira == False:
		hira = u"\t片假名"
	print u"假名:" + group[0] + u"\t日文:" + group[1] + u"\t词性:" + group[2] + u"\t音调:" + group[3] + u"\t中文:" + group[4] + hira
	wordProperties = list(group)
	wordProperties.append(isHira)
	return wordProperties
def replaceChars(originalLine):
	newLine = originalLine.replace(u'(',u'（')
	newLine = newLine.replace(u')',u'）')
	newLine = newLine.replace(u':',u'：')
	return newLine
def handleLine(originalLine):
	newLine = replaceChars(originalLine)
	components = seperateComponent(newLine);
	if components:
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
if originalFilePath.rfind(".txt") > 0:
	arrangeFile(originalFilePath)
	print "Loaded %s words"%(len(words))
	print "Upload to server"
	leancloud.init("kE5PXhVRVrRoKoDNMkdVE4c7-gzGzoHsz", "aGRwOxwVWSaBmrPT0xrsek1O")
	i = 0
	classIndex = os.path.basename(originalFilePath)[:-4]
	for word in words:
		i = i + 1
		print "%s/%s : %s"%(i,len(words),word["kana"])
		postWord("Class" + classIndex ,word)
		time.sleep( 1 )

	print "Process Finished"
else:
	print "Please input a file with .txt"



