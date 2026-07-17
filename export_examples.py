import os
import re
import codecs
import json

SRC_DIR = 'examples'
MD_DIR = 'docs'
LANG = 'matlab'


def mkdir2(s):
    os.makedirs(s, exist_ok=True)


def group_files(x):
    k, m = 0, None
    while k < len(x):
        if m is None:
            m = re.match(r'(.*)([0-9])(\.m)', x[k])
            k += 1
        else:
            pattern = f'({m.group(1)})([0-9])({m.group(3)})'
            m = re.match(pattern, x[k])
            if m:
                if isinstance(x[k - 1], tuple):
                    x[k - 1] = (*x[k - 1], x[k])
                else:
                    x[k - 1] = (x[k - 1], x[k])
                x.pop(k)
    return x


def export2md(src_dir, md_dir):
    if isinstance(src_dir, list):
        p, f = os.path.split(src_dir[0])
        md = f'# {f}{os.linesep * 2}'
        indent = '    '
        for s in src_dir:
            md += (
                f'=== "Step"{os.linesep * 2}'
                f'{indent}```{LANG} title="{f}" linenums="1"{os.linesep}'
                f'{indent}--8<-- "{os.path.relpath(s, SRC_DIR)}"{os.linesep}'
                f'{indent}```{os.linesep}'
            )
        mkdir2(os.path.join(md_dir, p))
        with codecs.open(os.path.join(md_dir, p, f + '.md'), 'w', encoding='utf-8') as fid:
            fid.write(md)
    elif os.path.isdir(src_dir):
        mkdir2(os.path.join(MD_DIR, os.path.relpath(src_dir)))
        x = sorted(os.listdir(src_dir))
        x = group_files(x)
        for fi in x:
            if isinstance(fi, tuple):
                export2md([os.path.join(src_dir, fk) for fk in fi], md_dir)
                continue
            export2md(os.path.join(src_dir, fi), md_dir)
    elif os.path.isfile(src_dir):
        p, f = os.path.split(src_dir)
        md = (
            f'# {f}{os.linesep * 2}'
            f'```{LANG} title="{f}" linenums="1"{os.linesep}'
            f'--8<-- "{os.path.relpath(src_dir, SRC_DIR)}"{os.linesep}'
            f'```'
        )
        mkdir2(os.path.join(md_dir, p))
        with codecs.open(os.path.join(md_dir, p, f + '.md'), 'w', encoding='utf-8') as fid:
            fid.write(md)
    else:
        raise FileNotFoundError(f"Path not found: {src_dir}")


def export2md2(config, md_dir):
    s = config['folder']
    if config.get('pages'):
        pages = config['pages']
        for pi in pages:
            md = f'# {pi["title"]}{os.linesep * 2}'
            indent = ' ' * 4

            files = pi["files"]
            if not isinstance(files, list):
                files = [files]

            for k, t in enumerate(files):
                t2 = s + "/" + t
                md += (
                    f'=== "Step {k + 1}"{os.linesep * 2}'
                    f'{indent}``` matlab title="{t}" linenums="1"{os.linesep}'
                    f'{indent}--8<-- "{t2}"{os.linesep}'
                    f'{indent}```{os.linesep * 2}'
                )

            path = os.path.join(md_dir, s)
            mkdir2(path)
            with codecs.open(os.path.join(path, pi["title"] + '.md'), 'w', encoding='utf-8') as fid:
                fid.write(md)

    if config.get('subfolder'):
        for k in config['subfolder']:
            k['folder'] = s + "/" + k['folder']
            export2md2(k, md_dir)


if __name__ == '__main__':
    with codecs.open('./examples.json', 'r', encoding='utf-8') as fid:
        config = json.load(fid)
    export2md2(config, MD_DIR)
