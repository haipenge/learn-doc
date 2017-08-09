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
		self.test_servers=['10.1.5.105','10.1.5.250','10.1.5.126','10.1.5.127']
		self.dev_servers=['10.12.12.140','10.12.12.141','10.12.12.142','10.12.12.143']
		self.user_and_password={'user':'prnp','password':'prnp'}
		self.test_user_and_password={'user':'prnp','password':'Mysql@105'}
	#创建生产库，库名：dbs0-99,四台，每台25片
	def generate_multi_db(self):
		for i,ip in enumerate(self.servers):
			print i,ip
			user=self.user_and_password['user']
			password=self.user_and_password['password']
			cmds=[]
			db_indexs=range(i*25,(i+1)*25)
			for i in db_indexs:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "create database dbs'+str(i)+'"'
				cmds.append(command)
				print command
				os.system(command)
	def generate_dev_multi_db(self):
		for i,ip in enumerate(self.dev_servers):
			print i,ip
			user=self.user_and_password['user']
			password=self.user_and_password['password']
			cmds=[]
			db_indexs=range(i*25,(i+1)*25)
			for i in db_indexs:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "create database dbs'+str(i)+'"'
				cmds.append(command)
				print command
				os.system(command)
	#创建测试库，库名：dbs0-99,四台，每台25片
	def generate_test_multi_db(self):
		for i,ip in enumerate(self.test_servers):
			print i,ip
			user=self.test_user_and_password['user']
			password=self.test_user_and_password['password']
			cmds=[]
			db_indexs=range(i*25,(i+1)*25)
			for i in db_indexs:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "create database dbs'+str(i)+'"'
				cmds.append(command)
				print command
				os.system(command)
	#创建生产公共库与统计库
	def generate_singel_db(self):
		user=self.user_and_password['user']
		password=self.user_and_password['password']
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[0]+' -e "create database nuc_pub"'
		os.system(command)	
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[1]+' -e "create database nuc_stat"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[2]+' -e "create database nuc_indivuser"'
		os.system(command)
	def generate_dev_singel_db(self):
		user=self.user_and_password['user']
		password=self.user_and_password['password']
		command='mysql -u '+user+' -p'+password+' -h '+self.dev_servers[0]+' -e "create database nuc_pub"'
		os.system(command)	
		command='mysql -u '+user+' -p'+password+' -h '+self.dev_servers[1]+' -e "create database nuc_stat"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+self.dev_servers[2]+' -e "create database nuc_indivuser"'
		os.system(command)
	#创建测试公共库，统计库
	def generate_test_singel_db(self):
		user=self.user_and_password['user']
		password=self.test_user_and_password['password']
		command='mysql -u '+user+' -p'+password+' -h '+self.test_servers[0]+' -e "create database nuc_pub"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+self.test_servers[1]+' -e "create database nuc_stat"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+self.servers[2]+' -e "create database nuc_indivuser"'
		os.system(command)
	#删除测试库
	def drop_test_dbs(self):
		for ip in self.test_servers:
			user=self.test_user_and_password['user']
			password=self.test_user_and_password['password']
			db_indexes=range(0,100)
			for i in db_indexes:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database dbs'+str(i)+'"'
				os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database nuc_pub"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database nuc_stat"'
		os.system(command)
	#删除生产库
	def drop_prod_dbs(self):
		for ip in self.servers:
			user=self.user_and_password['user']
			password=self.user_and_password['password']
			db_indexes=range(0,100)
			for i in db_indexes:
				command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database dbs'+str(i)+'"'
		command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database nuc_pub"'
		os.system(command)
		command='mysql -u '+user+' -p'+password+' -h '+ip+' -e "drop database nuc_stat"'
		os.system(command)

	def generate(self,set_env):
		if set_env == 'test':
			self.generate_test_singel_db()
			self.generate_test_multi_db()
		elif set_env =='dev':
			self.generate_dev_multi_db()
			self.generate_dev_singel_db()
		else:
			self.generate_multi_db()
			self.generate_singel_db()

if __name__=='__main__':
	tools=SchemaTools()
	set_env=raw_input('初始化环境[test,dev,prod,drop_test,drop_prod]:')
	if set_env == 'drop_test':
		tools.drop_test_dbs()
	elif set_env == 'drop_prod':
		tools.drop_prod_dbs()
	else:
		tools.generate(set_env)