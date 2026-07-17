import os
import re
import codecs
import shutil

HELP_INPUT = 'help/html'
HELP_IMAGES_OUT = os.path.join('docs', 'assets', 'images', 'help')
HELP_MD_OUT = os.path.join('docs', 'help')


def fileread(f):
    with codecs.open(f, 'r', encoding='utf-8') as fid:
        return fid.read()


def filewrite(f, txt):
    with codecs.open(f, 'w', encoding='utf-8') as fid:
        fid.write(txt)


def copy_images():
    if not os.path.exists(HELP_INPUT):
        print(f"Input directory not found: {HELP_INPUT}")
        return 0

    os.makedirs(HELP_IMAGES_OUT, exist_ok=True)
    cnt = 0
    for fi in os.listdir(HELP_INPUT):
        if fi.endswith('.png'):
            shutil.copyfile(
                os.path.join(HELP_INPUT, fi),
                os.path.join(HELP_IMAGES_OUT, fi)
            )
            print(f'Copyfile {fi}')
            cnt += 1
    print(f'Copy {cnt} images!')
    return cnt


def convert_html():
    if not os.path.exists(HELP_INPUT):
        return

    os.makedirs(HELP_MD_OUT, exist_ok=True)

    for fi in os.listdir(HELP_INPUT):
        if not fi.endswith('.html'):
            continue

        txt = fileread(os.path.join(HELP_INPUT, fi))

        style_matches = re.findall(r'<style type="text/css">.*?</style>', txt, re.S)
        if not style_matches:
            print(f'Skip {fi}: no <style> tag found')
            continue

        css = '<link rel="stylesheet" href="../../assets/stylesheets/matlab_publish.css">'

        content_matches = re.findall(r'<div class="content">(.*)</div>', txt, re.S)
        if not content_matches:
            print(f'Skip {fi}: no content div found')
            continue
        txt = content_matches[0]

        txt = re.sub(r'<h2>Contents</h2><div><ul>.*?</ul></div>', '', txt, 0, re.S)
        txt = re.sub(r'<h1.*?>(.*?)</h1>', r'\n# \1\n', txt, 0, re.S)
        txt = re.sub(r'<h2.*?>(.*?)</h2>', r'\n## \1\n', txt, 0, re.S)
        txt = re.sub(r'<h3.*?>(.*?)</h3>', r'\n### \1\n', txt, 0, re.S)
        txt = re.sub(r'src="([^"]*)"', r'src="../../assets/images/help/\1"', txt)

        txt = txt + css

        out_file = os.path.join(HELP_MD_OUT, fi[:-4] + 'md')
        filewrite(out_file, txt)
        print(f'Converted {fi}')


if __name__ == '__main__':
    copy_images()
    convert_html()
