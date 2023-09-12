"""
Generate Index for api and images
"""

import os,re,codecs

examples = 'docs/examples'
s = os.listdir(examples)

idx=''
cnt=1
for di in s:
    pi = os.path.join(examples, di)
    if os.path.isfile(pi):
        continue
    for fi in os.listdir(pi):
        fi_full = os.path.join(pi, fi)
        if os.path.isdir(fi_full):
            continue
        id = '0'*(3-str(cnt).__len__())+str(cnt)
        # tag = di[8:] + id + os.path.splitext(fi)[0]
        tag = 'code' + id
        ref = os.path.join(di,fi)
        idx += f'[{tag}]:{ref}'+os.linesep
        cnt+=1
    idx += os.linesep

# print(idx)


images = 'docs/assets/images'
s = ['examples2018','examples2019','examples2020','examples2021','examplesModel']

cnt=1
idx2=''
for di in s:
    pi = os.path.join(images, di)
    if os.path.isfile(pi):
        continue
    for fi in os.listdir(pi):
        fi_full = os.path.join(pi, fi)
        if os.path.isdir(fi_full):
            continue
        id = '0'*(3-str(cnt).__len__())+str(cnt)
        # tag = di[8:] + id + os.path.splitext(fi)[0]
        tag = 'img' + id
        ref = os.path.join(di,fi)
        idx2 += f'[{tag}]:..\\assets\\images\\{ref}'+os.linesep
        cnt+=1
    idx2 += os.linesep

# print(idx2)

with codecs.open('index_code_img.md','w',encoding='utf-8') as fid:
    fid.write(idx)
    fid.write(idx2)
