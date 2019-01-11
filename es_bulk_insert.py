#!/usr/bin/env python2.7
#encoding:utf-8

import json
from elasticsearch import Elasticsearch

def gendata(array_content):
    for word in array_content:
        yield {
            "_index": "mywords",
            "_type": "document",
            "doc": {"word": word},
        }


es = Elasticsearch()
with open('opendata/starbuck.txt', 'r') as large_file:
    #parser = ijson.parse(large_file)
    data = large_file.readlines()
    tmp = []
    for line in data:
        #print line
        if len(tmp) > 1001:
            print "upload data"
            #bulk(es, gendata(tmp))
            tmp = []
        else:
            tmp.append(line)
    print "upload final data"
    #bulk(es, gendata(tmp))
