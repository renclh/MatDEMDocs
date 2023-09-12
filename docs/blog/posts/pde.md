---
draft: true
date: 2023-06-15
authors:
    - renc
categories:
    - pde
    - cfd
---

# 偏微分方程

## 微分方程
1.渗流方程
$$
\nabla\cdot(\frac{k}{\mu}\nabla{P})=
\frac{\partial\rho}{\partial t}
$$
2.不可压流体N-S方程
$$
\nabla\cdot\vec{v}=0\\
\rho\frac{\partial\vec{v}}{\partial{t}}+\nabla{P}=\mu\nabla{\vec{v}}+\rho\vec{f}
$$

<!-- more -->

## 离散方程与线性方程组

1.渗流方程
$$
\sum_{faces}k\frac{(P_{fj}-P_{fi})\vec{h}_{ij}}
{\vec{h}_{ij}\cdot\vec{h}_{ij}}\cdot \vec{A}_{ij}\\
k_{ij}P_j=Q_i
$$

$$
\nabla P=[\frac{\partial P}{\partial x},\frac{\partial P}{\partial y},\frac{\partial P}{\partial z}]^T\\

\Delta P = \nabla\cdot\nabla P=\frac{\partial^2 P}{\partial x^2}+
\frac{\partial^2 P}{\partial y^2}+
\frac{\partial^2 P}{\partial z^2}\\

\nabla\cdot\vec{v}=\frac{\partial u}{\partial x}+
\frac{\partial v}{\partial y}+
\frac{\partial w}{\partial z}\\

\Delta\vec{v}=\nabla(\nabla\cdot \vec{v})\\
\\

\nabla\times\vec{v}=[\frac{\partial v}{\partial y}-\frac{\partial w}{\partial z},
\frac{\partial w}{\partial z}-\frac{\partial u}{\partial x},
\frac{\partial u}{\partial x}-\frac{\partial v}{\partial y}]^T\\

\nabla\times\nabla P
$$
