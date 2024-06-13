"""
Generate *docs/help* folder content from *help* folder.

The *help* folder contains html files, image files and basic stylesheet files
which published from matlab scripts

"""

import os,shutil,re,codecs

def fileread(f):
    with codecs.open(f, 'r', encoding='utf-8') as fid:
        return fid.read()

def filewrite(f,txt):
    with codecs.open(f,'w',encoding='utf-8') as fid:
        fid.write(txt)

help_input = 'help/html'

s = os.listdir(help_input)

# copy image resources
cnt = 0
for fi in s:
    if fi.endswith('.png'):
        shutil.copyfile(os.path.join(help_input, fi), os.path.join('docs','assets','images','help',fi))
        print(f'Copyfile {fi}')
        cnt+=1
print(f'Copy {cnt} images!')

# deal with raw html
for fi in s:
    if fi.endswith('.html'):
        # read html file
        txt = fileread(os.path.join(help_input, fi))
        
        css = re.findall(r'<style type="text/css">.*?</style>',txt,re.S)[0]
        # add/replace stylesheets block
        # txt = re.sub(r'<style type="text/css">.*?</style>', '<link rel="stylesheet" href="../../assets/stylesheets/matlab_publish.css">',txt,0,re.S)  # single line mode
        css = '<link rel="stylesheet" href="../../assets/stylesheets/matlab_publish.css">'

        # .content
        txt = re.findall(r'<div class="content">(.*)</div>',txt,re.S)[0]

        # remove TOC
        txt = re.sub(r'<h2>Contents</h2><div><ul>.*?</ul></div>','',txt,0,re.S)
        # update header
        txt = re.sub(r'<h1.*?>(.*?)</h1>',r'\n# \1\n',txt,0,re.S)
        txt = re.sub(r'<h2.*?>(.*?)</h2>',r'\n## \1\n',txt,0,re.S)
        txt = re.sub(r'<h3.*?>(.*?)</h3>',r'\n### \1\n',txt,0,re.S)

        # update image path
        txt = re.sub(r'src="([^"]*)"',r'src="../../assets/images/help/\1"',txt)

        txt = txt+css

        # write markdown file
        filewrite(os.path.join('docs','help',fi[0:-4]+'md'), txt)
        
        print(f'move {fi}')

