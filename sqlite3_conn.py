# -*- coding: UTF-8 -*-
#__author__ = 'li90.com'
import sqlite3


def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d
class SQLite:
    def __init__(self,dbname):
        self.dbname=dbname
        try:
            self.conn=sqlite3.connect(self.dbname)
            self.cur=self.conn.cursor()
            self.cur.row_factory=dict_factory
        except sqlite3.Error as e:
            print(e)
    def __del__(self):
#        self.close()
        self.cur.close()
        self.conn.close()
    def query(self,selectColumn,table,likeColumn,likeString):
        sql  = 'select ' + selectColumn + ' from ' + table + ' where ' + likeColumn + ' like ' + "'%%%s%%'" % likeString
        try:
            n=self.cur.execute(sql)
            return n
        except sqlite3.Error as e:
            print("Sqlite3 Error:%s\nSQL:%s" %(e,sql))
    def fetchall(self):
        result = self.cur.fetchall()
        return result
#    def close(self):
#        self.cur.close()
#        self.conn.close()
