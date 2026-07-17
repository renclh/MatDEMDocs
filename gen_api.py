import os
import re
import codecs
import json

import pandas as pd

IO = 'MatDEM帮助3.50（中文）.xlsx'
META = 'api-meta.json'
OUT_DIR = 'docs/api'
NAV_FILE = os.path.join(OUT_DIR, 'nav.yml')


def load_meta():
    if not os.path.exists(META):
        raise FileNotFoundError(f"Meta file not found: {META}")
    with codecs.open(META, 'r', encoding='utf-8') as fid:
        return json.load(fid)


def is_nan(value):
    return pd.isna(value)


def generate():
    if not os.path.exists(IO):
        raise FileNotFoundError(f"Excel file not found: {IO}")

    os.makedirs(OUT_DIR, exist_ok=True)
    meta = load_meta()

    with codecs.open(NAV_FILE, 'w+', encoding='utf-8') as fnav:
        for api, api_meta in meta.items():
            api_props = pd.read_excel(io=IO, sheet_name=api_meta['sheet_name'], **api_meta['props'])
            api_methods = pd.read_excel(io=IO, sheet_name=api_meta['sheet_name'], **api_meta['methods'])

            md = f'# {api}{os.linesep * 2}'
            md += f'!!! api "class <span id="{api}-{api}">{api}</span>"{os.linesep}'

            md += f'    ???+ api "<span id="{api}-props">Properties</span>"{os.linesep}'
            nav_props = ''
            cols = api_props.columns
            for ri in api_props.index:
                mem = api_props[cols[0]][ri]
                md += f'        !!! api "<span id="{api}-{mem}">{mem}</span>"{os.linesep}'
                nav_props += f' - {mem}: api/{api}.md/#{api}-{mem}{os.linesep}'
                for ci in range(len(cols) - 1):
                    des = api_props[cols[ci + 1]][ri]
                    if is_nan(des):
                        des = ''
                    md += f'            {des}{os.linesep * 2}'

            md += f'    ???+ api "<span id="{api}-methods">Methods</span>"{os.linesep}'
            nav_methods = ''
            cols = api_methods.columns
            for ri in api_methods.index:
                mem = api_methods[cols[0]][ri]
                md += f'        !!! api "<span id="{api}-{mem}">{mem}</span>"{os.linesep}'
                nav_methods += f' - {mem}: api/{api}.md/#{api}-{mem}{os.linesep}'
                for ci in range(len(cols) - 1):
                    des = api_methods[cols[ci + 1]][ri]
                    if is_nan(des):
                        des = ''
                    md += f'            {des}{os.linesep * 2}'

            out_file = os.path.join(OUT_DIR, f'{api}.md')
            with codecs.open(out_file, 'w', encoding='utf-8') as fid:
                fid.write(md)

            fnav.write(f'{api}:{os.linesep} - api/{api}.md/#{api}-{api}{os.linesep}')
            fnav.write(f'{nav_props}{os.linesep}{nav_methods}')


if __name__ == '__main__':
    generate()
