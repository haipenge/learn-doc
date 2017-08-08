#!/usr/bin/env python
# -*- coding: utf-8 -*-
#create multi dbs on different servers
#author:haipenge
#Date:2917.08.08
import os
import sys
import random
import shutil
import tempfile

class SchemaTools(object):
	def __init__(self):
		self.servers=['10.11.100.39','10.11.100.40','10.11.100.41','10.11.100.42']
		self.test_servers=['10.1.5.105','10.1.5.250']
		self.user_and_password={'user':'prnp','password':'prnp'}
	def generate_multi_db(self):
		for i,ip in enumerate(self.servers):
			print i,ip
			user=self.user_and_password['user']
			password=self.user_and_password['password']
			cmds=[]
			db_indexs=range(i*25,(i+1)*25)
			for i in db_indexs:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "create database dbs'+i+'"'
				cmds.append(command)
				print command
				os.system(command)
	def generate_singel_db(self):
		user=self.user_and_password['user']
		password=self.user_and_password['password']
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[0]+' -e "create database nuc_pub"'
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[1]+' -e "create database nuc_stat"'
	def generate(self):
		self.generate_multi_db()
		self.generate_singel_db()

if __name__=='__main__':
	tools=SchemaTools()
	tools.generate()