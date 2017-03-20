#!/usr/bin/python
# -*- coding: UTF-8 -*-

import re 
import sys
import os

def processWordType(type):
	type = type.strip()
	if type == u"名":
		return u"名词"
	return type

def handleComponents(components):
	japanese = components[1]
	kana = components[0]
	chinese = components[4]
	isHiragana = components[5]
	types = components[2]
	tones = components[3]
	tone1 = tones[:1]
	tone2 = tones[1:2]
	types = types.split(u"·")
	type1 = types[0]
	type1 = processWordType(type1)
	type2 = ""
	if len(types) > 1:
		type2 = types[1]
		type2 = processWordType(type2)
	hira = u"\t平假名"
	if isHiragana == False:
		hira = u"\t片假名"

	print type1 + " " + type2
	return None

def parseLine(originalLine,regex):
	pattern = re.compile(regex)
	results = pattern.findall(originalLine)
	return results;

def seperateComponent(originalLine):
	chineseJapanese = u"[\u4E00-\u9FA5\uF900-\uFA2D\u3040-\u309F\u30A0-\u30FF\u30A0-\u30FF]"
	regex1 =  u"(" +chineseJapanese + u"+)\s*(?:（([\W]+)）)?\W*【(\W+)】\s*(\W*)：\s*(\W*)"
	regex2 =  u"(" +chineseJapanese + u"+)\s*(?:（([\S\s]+)）)?\W*【(\W+)】\s*(\W*)：\s*(\W*)"
	isHira = True
	results = parseLine(originalLine, regex1)
	if len(results) == 0 :
		isHira = False
		results = parseLine(originalLine, regex2)

	if len(results) == 0 :
		print "///can't parse + " + originalLine
		return None

	group = results[0]
	hira = u"\t平假名"
	if isHira == False:
		hira = u"\t片假名"
	# return u"假名:" + group[0] + u"\t日文:" + group[1] + u"\t词性:" + group[2] + u"\t音调:" + group[3] + u"\t中文:" + group[4] + hira
	wordProperties = list(group)
	wordProperties.append(isHira)
	return wordProperties

def handleLine(originalLine):
	components = seperateComponent(originalLine);
	if components:
		word = handleComponents(components)
		words.append(word);
	else:
		print "/// Can't parse " + originalLine

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
if os.path.isdir(originalFilePath):
	print "is directory "
	def callback(arg,top,names):
		for i in xrange(0,len(names)):
			fileName = top + "/" + names[i]
			if fileName.rfind(".txt") > 0:
				# print fileName
				arrangeFile(fileName)
		return;
	os.path.walk(originalFilePath,callback,0)
			
else:
	if originalFilePath.rfind(".txt") > 0:
		arrangeFile(originalFilePath)

print words
print "Upload to server"

print "Process Finished"


