# -*- coding: UTF-8 -*-
#__author__ = 'li90.com'
import MySQLdb
import MySQLdb.cursors
OperationalError = MySQLdb.OperationalError
class MySQL:
    def __init__(self,host,user,password,port=3306,charset="utf8"):
        self.host=host
        self.port=port
        self.user=user
        self.password=password
        self.charset=charset
        try:
            self.conn=MySQLdb.connect(host=self.host,port=self.port,user=self.user,passwd=self.password,cursorclass=MySQLdb.cursors.DictCursor)
            self.conn.autocommit(False)
            self.conn.set_character_set(self.charset)
            self.cur=self.conn.cursor()
        except MySQLdb.Error as e:
            print("Mysql Error %d: %s" % (e.args[0], e.args[1]))
    def __del__(self):
        self.close()
    def selectDb(self,db):
        try:
            self.conn.select_db(db)
        except MySQLdb.Error as e:
            print("Mysql Error %d: %s" % (e.args[0], e.args[1]))
    def query(self,selectColumn,table,likeColumn,likeString):
        sql  = 'select ' + selectColumn + ' from ' + table + ' where ' + likeColumn + ' like ' + "'%%%s%%'" % likeString
        try:
            n=self.cur.execute(sql)
            return n
        except MySQLdb.Error as e:
            print("Mysql Error:%s\nSQL:%s" %(e,sql))
    def fetchall(self):
        result = self.cur.fetchall()
        return result
    def close(self):
        self.cur.close()
        self.conn.close()
