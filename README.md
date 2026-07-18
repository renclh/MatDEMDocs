# MatDEMDocs

MatDEM 3.5 帮助文档，基于 [mkdocs-materialx](https://jaywhj.github.io/mkdocs-materialx/) 构建。

- 官网：<http://matdem.com>
- 文档：<https://renclh.github.io/MatDEMDocs/>

## 本地开发

```bash
pip install -r requirements.txt
mkdocs serve
```

## 项目结构

```
docs/
├── index.md                  # 首页（Hero 轮播图）
├── api/                      # API 参考（自动生成侧边栏 TOC）
├── examples/                 # 示例画廊
├── assets/
│   ├── stylesheets/          # 主题 CSS（颜色/边框/阴影）
│   ├── javascripts/          # KaTeX 数学公式
│   └── images/               # 图片资源
overrides/
├── main.html                 # Hero 区块 + 轮播图 + API TOC 脚本
└── partials/                 # Footer 自定义
mkdocs.yml                    # 站点配置
gen_api.py / gen_help.py / gen_ref.py  # 构建脚本
```

## 主题定制

仅覆盖视觉样式（颜色、背景、边框、圆角、阴影），不修改 materialx 默认布局，确保移动端适配正常。

关键样式文件：
- `matdem-theme.css` — 主主题（CSS 变量、Header/Footer/侧边栏/内容区视觉）
- `custom_admonitions.css` — API 折叠块样式
- `extra_css.css` — hoverimg 悬浮预览

## 构建脚本

| 脚本 | 功能 |
|------|------|
| `gen_api.py` | 从 MATLAB 源码提取类/属性/方法，生成 API 文档 |
| `gen_help.py` | 生成帮助页面 |
| `gen_ref.py` | 生成函数参考 |
| `export_examples.py` | 导出示例文件 |
