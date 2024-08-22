'''
    generate index page
'''

import os,re,codecs

cd = os.path.dirname(__file__)

with codecs.open(os.path.join(cd,'index.md'),'w',encoding='utf-8') as fid:
    fid.write('# Examples' + os.linesep)

    for k in os.listdir(cd):
        if os.path.isfile(os.path.join(cd,k)):
            continue

        fid.write('## ' + k + os.linesep*2)
        fid.write('<div class = "flex" markdown>' + os.linesep*2)
        for k2 in os.listdir(os.path.join(cd,k)):
            tag = re.match('(user_)?(\w+)(\d?)(.md)?', k2).group(2)
            fid.write(f'[{tag}]({os.path.join(k,k2)})' + '{.items}' + os.linesep*2)
        fid.write('</div>' + os.linesep*2)

