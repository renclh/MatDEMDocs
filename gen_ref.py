import os
import codecs

EXAMPLES_DIR = 'docs/examples'
IMAGES_DIR = 'docs/assets/images'
OUT_FILE = 'index_code_img.md'

EXAMPLE_SUBDIRS = ['examples2018', 'examples2019', 'examples2020', 'examples2021', 'examplesModel']


def generate_code_index():
    if not os.path.exists(EXAMPLES_DIR):
        print(f"Directory not found: {EXAMPLES_DIR}")
        return

    idx = ''
    cnt = 1
    for di in sorted(os.listdir(EXAMPLES_DIR)):
        pi = os.path.join(EXAMPLES_DIR, di)
        if os.path.isfile(pi):
            continue
        for fi in sorted(os.listdir(pi)):
            fi_full = os.path.join(pi, fi)
            if os.path.isdir(fi_full):
                continue
            tag = 'code' + str(cnt).zfill(3)
            ref = os.path.join(di, fi)
            idx += f'[{tag}]: {ref}{os.linesep}'
            cnt += 1
        idx += os.linesep
    return idx


def generate_image_index():
    idx2 = ''
    cnt = 1
    for di in EXAMPLE_SUBDIRS:
        pi = os.path.join(IMAGES_DIR, di)
        if not os.path.exists(pi) or os.path.isfile(pi):
            continue
        for fi in sorted(os.listdir(pi)):
            fi_full = os.path.join(pi, fi)
            if os.path.isdir(fi_full):
                continue
            tag = 'img' + str(cnt).zfill(3)
            ref = os.path.join(di, fi)
            idx2 += f'[{tag}]: ../assets/images/{ref}{os.linesep}'
            cnt += 1
        idx2 += os.linesep
    return idx2


if __name__ == '__main__':
    code_idx = generate_code_index()
    img_idx = generate_image_index()
    with codecs.open(OUT_FILE, 'w', encoding='utf-8') as fid:
        fid.write(code_idx or '')
        fid.write(img_idx or '')
