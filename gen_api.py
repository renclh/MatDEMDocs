import os,re,codecs
import json
import pandas as pd

io='MatDEM帮助3.50（中文）.xlsx'
with codecs.open('api-meta.json','r',encoding='utf-8') as fid:
    meta = json.load(fid)

# props_header = ('属性','功能','备注')
# methods_header = ('函数','功能','输入','输出','示例')

with codecs.open('docs/api/nav.yml','w+',encoding='utf-8') as fnav:
    for api in meta:
        api_meta = meta[api]
        api_props = pd.read_excel(io=io, sheet_name=api_meta['sheet_name'],**api_meta['props'])
        api_methods = pd.read_excel(io=io, sheet_name=api_meta['sheet_name'],**api_meta['methods'])

        # md header
        md=f'# {api}' + os.linesep*2

        # class header
        md+='!!! api "' + f'class <span id="{api}-{api}">{api}</span>"' + os.linesep

        # properties header
        md+=' '*4 + '???+ api "' + f'<span id="{api}-props">Properties</span>"' + os.linesep

        nav_props=''
        cs = api_props.columns
        for ri in api_props.index:
            mem = api_props[cs[0]][ri]
            md += ' '*4*2 + '!!! api "' + f'<span id="{api}-{mem}">{mem}</span>"' + os.linesep
            nav_props += ' - ' + f'{mem}: api/{api}.md/#{api}-{mem}' + os.linesep
            for ci in range(cs.__len__()-1):
                des = api_props[cs[ci+1]][ri]
                if str(des) == 'nan':
                    des=''
                md += ' '*4*3 + des + os.linesep*2

        # methods header
        md+=' '*4 + '???+ api "' + f'<span id="{api}-methods">Methods</span>"' + os.linesep

        nav_methods=''
        cs = api_methods.columns
        for ri in api_methods.index:
            mem = api_methods[cs[0]][ri]
            md += ' '*4*2 + '!!! api "' + f'<span id="{api}-{mem}">{mem}</span>"' + os.linesep
            nav_methods += ' - ' + f'{mem}: api/{api}.md/#{api}-{mem}' + os.linesep
            for ci in range(cs.__len__()-1):
                des = api_methods[cs[ci+1]][ri]
                if str(des) == 'nan':
                    des=''
                md += ' '*4*3 + des + os.linesep*2

        with codecs.open('docs/api/' + api + '.md','w',encoding='utf-8') as fid:
            fid.write(md)

        fnav.write(f'{api}: {os.linesep} - api/{api}.md/#{api}-{api}{os.linesep}')
        fnav.write(f'{nav_props}{os.linesep}{nav_methods}')
