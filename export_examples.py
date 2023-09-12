import os
import re
import codecs

SRC_DIR = 'examples'
MD_DIR = 'docs'
lang='matlab'

def mkdir2(s):
    if not os.path.exists(s):
        os.mkdir(s)

def group_files(x):
    k, m = 0, None
    while k < x.__len__():
        if m is None:
            m = re.match('(.*)([0-9])(\.m)',x[k])
            k+=1
        else:
            pattern = f'({m.group(1)})([0-9])({m.group(3)})'
            m = re.match(pattern, x[k])
            if m:
                if isinstance(x[k-1],tuple):
                    x[k-1] = (*x[k-1], x[k])
                else:
                    x[k-1] = (x[k-1], x[k])
                x.pop(k)
    return x

def export2md(src_dir, md_dir):
    if isinstance(src_dir, list): # multi-files
        p,f = os.path.split(src_dir[0])
        md = f'# {f}' + os.linesep + os.linesep
        indent='    '
        for s in src_dir:
            md+=f'=== "Step"' + os.linesep + os.linesep \
            + f'{indent}```{lang} title="{f}" linenums="1"' + os.linesep \
            + f'{indent}--8<-- "{os.path.relpath(s, SRC_DIR)}"' + os.linesep \
            + f'{indent}```' + os.linesep

        with codecs.open(os.path.join(md_dir,p,f+'.md'),'w',encoding='utf-8') as fid:
            fid.write(md)
    elif os.path.isdir(src_dir):
        mkdir2(os.path.join(MD_DIR, os.path.relpath(src_dir)))
        x = os.listdir(src_dir)
        x = group_files(x)
        # breakpoint()
        for fi in x:
            if isinstance(fi, tuple):
                export2md([os.path.join(src_dir, fk) for fk in fi], md_dir)
                continue
            export2md(os.path.join(src_dir, fi), md_dir)
    elif os.path.isfile(src_dir):
        p,f = os.path.split(src_dir)
        md = f'# {f}' + os.linesep \
        + os.linesep \
        + f'```{lang} title="{f}" linenums="1"' + os.linesep \
        + f'--8<-- "{os.path.relpath(src_dir, SRC_DIR)}"' + os.linesep \
        + '```'

        with codecs.open(os.path.join(md_dir,p,f+'.md'),'w',encoding='utf-8') as fid:
            fid.write(md)
    else:
        assert AssertionError

# export2md(SRC_DIR, MD_DIR)

#######################################
import json

def export2md2(config, md_dir):    
    # deal with pages
    s = config['folder']
    if config['pages']:
        p = config['pages']
        for pi in p:
            md = f'# {pi["title"]}' + os.linesep*2
            indent = ' '*4

            if not isinstance(pi["files"],list):
                pi["files"]=[pi["files"]]
                
            n = pi["files"].__len__()
            for k in range(n):
                t = pi["files"][k]
                t2 = os.path.join(s,t)
                md+=f'=== "Step {k+1}"' + os.linesep*2 \
                + f'{indent}``` matlab title="{t}" linenums="1"' + os.linesep \
                + f'{indent}--8<-- "{t2}"' + os.linesep \
                + f'{indent}```' + os.linesep*2
            
            path = os.path.join(md_dir, s)
            mkdir2(path)
            with codecs.open(os.path.join(path,pi["title"]+'.md'),'w',encoding='utf-8') as fid:
                fid.write(md)

    # deal with subfolders
    if config['subfolder']:
        for k in config['subfolder']:
            k['folder'] = os.path.join(s, k['folder'])
            export2md2(k, md_dir)
    

with codecs.open('./examples.json','r',encoding='utf-8') as fid:
    config = json.load(fid)

export2md2(config, MD_DIR)


