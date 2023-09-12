---
draft: true
date: 2023-07-31
categories:
    - sph
    - cfd
---

# SPH & MPS

Smoothed Particle Hydrodynamics(SPH)  & Moving Particle Simulation(MPS)

## 一、SPH理论基础[^1]

1. 密度与光滑和函数

   $$
   \rho_i=\sum_j{m_jW(r_i-r_j,h)}
   $$

   注：此密度似乎不是流体密度？？

   poly6光滑核函数：

   $$
   \rho=m\frac{315}{64\pi h^9}\sum(h^2-|r_i-r_j|^2)^3,i \ne j\\
   \mathbf{a}_i^{pre}=-\frac{\nabla P}{\rho_i}=m\frac{45}{\pi h^6}\sum_j{(\frac{p_i+p_j}{2\rho_i\rho_j}(h-r)^2\frac{r_i-r_j}{r})},i \neq j\\
   $$

   $$
   \mathbf{a}_i^{vis}=-\frac{\nabla P}{\rho_i}=m\mu\frac{45}{\pi h^6}\sum_j{(\frac{u_j-u_i}{\rho_i\rho_j}(h-|r_i-r_j|))},i \neq j\\
   $$

   $$
   n(r_i)=\nabla Cs(r_i)=-m\frac{945}{32\pi h^9}\sum_j{\frac{(h^2-r^2)^2(r_i-r_j)}{\rho_j}}\\
   $$

2. 粒子受力

$$
\rho\mathbf{a}=f_{ext}+f_{pre}+f_{vis}\\
\\
\begin{cases}
f_{ext}=\rho \cdot g\\
f_i^{pre}=-\sum_j{m_j\frac{p_i+p_j}{2\rho_j}\nabla W(r_i-r_j,h)},\quad p=K(\rho-\rho_0)\\
f_i^{vis}=\mu\nabla^2u_i=\mu\sum_j{(u_j-u_i)\frac{m_j}{\rho_j}\nabla^2W(r_i-r_j,h)}\\
\end{cases}
$$

3. 表面张力

Colorfield函数：

$$
Cs(r)=\sum_j{m_j\frac{1}{\rho_i}W(r_i-r_j,h)},i \ne j
$$

表面张力方向为其梯度方向

4. 边界条件
   $$
   v^{n+1}=-\alpha v^n
   $$

## 二、SPH表面重建与渲染

浮沫，描边，深度图

Marching Cube算法表面重建，平滑

光照模型

液体渲染：一种屏幕空间方法[^2]

Screen Space Fluid Rendering, Position Based Fluids

局部区域重构，椭球形粒子

深度纹理，厚度纹理，表面法线

[^1]: [SPH 3D流体模拟及其卡通化渲染 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/95102715)
    
[^2]: [液体渲染：一种屏幕空间方法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/38280537)
