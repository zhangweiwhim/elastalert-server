# -*- coding:utf-8 -*-
# !/usr/bin/env python3
# -*- coding: utf-8 -*-

import json

'''
#################################################################
# python2->3 json.dumps失效解决编码                             #
#                                                               #
# 作者: zhangweiwhim <zhangweiwhim@gmail.com>                   #
# Github: https://github.com/zhangweiwhim/elastalert-server     #
#                                                               #
#################################################################
'''

class MyEncoder(json.JSONEncoder):

    def default(self, obj):
        """
        check the was bytes that convertto str
        :param obj:
        :return:
        """
        if isinstance(obj, bytes):
            return str(obj, encoding='latin-1')
        return json.JSONEncoder.default(self, obj)
