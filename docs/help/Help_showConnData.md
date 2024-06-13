
# showConnData
<!--introduction--><p>&#21487;&#35270;&#21270;&#39063;&#31890;&#32676;&#30340;&#36830;&#25509;&#29366;&#24577;</p><!--/introduction-->
## &#35821;&#27861;
<pre>showConnData(mPos,cList,cW,cC)
showConnData(mPos,cList)
showConnData(mPos,cList,cW)
showConnData(...,M)
showConnData(AX,...)
H = showConnData(...)</pre>
## &#25551;&#36848;
<p><tt>showConnData(mPos, cList)</tt> visualize connections defined by the points (mPos) and point pairs(cList). Mark with LINE, with the same width and black color.</p><p><tt>showConnData(mPos, cList, cW)</tt> visualize connections, mark with a narrow RECTANGLE or TUBE of different width. The width varies with cW.</p><p><tt>showConnData(mPos, cList, cW, cC)</tt> visualize connections, mark with a narrow RECTANGLE or TUBE of different width and different color. The width varies with cW, the color varies with cC. TODO: interp color along each connection.</p><p><tt>showConnData(__, M)</tt> visualize with the marker M('line','rect','tube')</p><p><tt>showConnData(AX, __)</tt> plots into AX instead of GCA</p><p><tt>H = showConnData(__)</tt> returns a PATCH or SURFACE handle in H.</p><p><tt>__ = showConnData(__, pvpairs)</tt> sets the value of the specified surface property.  Multiple property values can be set with a single statement.</p>
## &#31034;&#20363;&#8212;&#8212;&#22522;&#26412;&#22270;&#20803;&#19982;&#25968;&#25454;&#21487;&#35270;&#21270;

## &#32447;&#26465;(1&#32500;)
<p>&#26080;&#32447;&#23485;&#65292; &#25968;&#25454;&#21487;&#35270;&#21270;&#26102;&#20165;&#26144;&#23556;&#20026;&#39068;&#33394;</p><pre class="codeinput">mPos = [zeros(1,3);[sqrt(8)/3*cosd(30:120:270)',sqrt(8)/3*sind(30:120:270)',zeros(3,1)-1/3];0,0,1];
cList = [1,2;1,3;1,4;1,5];
mValue = rand(5,1);
cValue = rand(4,1);

nexttile
showConnData(mPos, cList, <span class="string">'line'</span>);
title(<span class="string">'&#32447;&#26465;&#65292; &#32479;&#19968;&#30528;&#33394;&#65288;&#40664;&#35748;&#20026;&#32511;&#33394;&#65289;'</span>);
nexttile
showConnData(mPos, cList, 0, cValue, <span class="string">'EdgeColor'</span>, <span class="string">'flat'</span>);
colormap(gca, [0,1,0;1,0,0]);
title(<span class="string">'&#32447;&#26465;&#65292; &#22522;&#20110;&#36830;&#25509;&#23646;&#24615;&#21333;&#19968;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, 0, mValue);
title(<span class="string">'&#32447;&#26465;&#65292; &#22522;&#20110;&#39063;&#31890;&#23646;&#24615;&#21333;&#19968;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, 0, mValue,<span class="string">'EdgeColor'</span>,<span class="string">'interp'</span>);
title(<span class="string">'&#32447;&#26465;&#65292; &#22522;&#20110;&#39063;&#31890;&#23646;&#24615;&#25554;&#20540;&#30528;&#33394;'</span>);
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_01.png" alt=""> 
## &#30697;&#24418;&#65288;2&#32500;&#65289;
<p>&#25968;&#25454;&#21487;&#35270;&#21270;&#26102;&#21487;&#26144;&#23556;&#20026;&#23485;&#24230;&#12289;&#39068;&#33394;&#25110;&#65288;&#36879;&#26126;&#24230;&#65289;</p><pre class="codeinput">mPos = [zeros(1,3);[sqrt(8)/3*cosd(30:120:270)',sqrt(8)/3*sind(30:120:270)',zeros(3,1)-1/3];0,0,1];
cList = [1,2;1,3;1,4;1,5];
mValue = rand(5,1);
cValue = rand(4,1);

figure;
nexttile
showConnData(mPos, cList, <span class="string">'rect'</span>);
title(<span class="string">'&#30697;&#24418;, &#32447;&#23485; + &#40657;&#33394;'</span>);
nexttile
showConnData(mPos, cList, 1, cValue, <span class="string">'rect'</span>, <span class="string">'FaceColor'</span>, <span class="string">'flat'</span>);
title(<span class="string">'&#30697;&#24418;&#65292; &#22266;&#23450;&#32447;&#23485; + &#21333;&#19968;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, 1, mValue, <span class="string">'rect'</span>);
title(<span class="string">'&#30697;&#24418;&#65292; &#22266;&#23450;&#32447;&#23485; + &#25554;&#20540;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, cValue, mValue, <span class="string">'rect'</span>,<span class="string">'FaceColor'</span>,<span class="string">'interp'</span>);
title(<span class="string">'&#30697;&#24418;&#65292; &#32447;&#23485; + &#25554;&#20540;&#30528;&#33394;'</span>);
snapnow;
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_02.png" alt=""> 
## &#22278;&#26609;
<p>&#25968;&#25454;&#21487;&#35270;&#21270;&#26102;&#21487;&#26144;&#23556;&#20026;&#23485;&#24230;&#12289;&#39068;&#33394;&#25110;&#65288;&#36879;&#26126;&#24230;&#65289; &#19977;&#32500;&#26102;&#21487;&#32771;&#34385;&#20809;&#29031;&#22686;&#24378;&#31435;&#20307;&#24863;</p><pre class="codeinput">figure;
mPos = [zeros(1,3);[sqrt(8)/3*cosd(30:120:270)',sqrt(8)/3*sind(30:120:270)',zeros(3,1)-1/3];0,0,1];
cList = [1,2;1,3;1,4;1,5];
mValue = rand(5,1);
cValue = rand(4,1);

nexttile
showConnData(mPos, cList, cValue);
camlight;
title(<span class="string">'&#22278;&#26609;, &#32447;&#23485;'</span>);
nexttile
showConnData(mPos, cList, 1, cValue,<span class="string">'FaceColor'</span>, <span class="string">'flat'</span>);
camlight;
title(<span class="string">'&#22278;&#26609;&#65292; &#22266;&#23450;&#32447;&#23485; + &#22522;&#20110;&#36830;&#25509;&#23646;&#24615;&#21333;&#19968;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, 1, mValue);
camlight;
title(<span class="string">'&#22278;&#26609;&#65292; &#22266;&#23450;&#32447;&#23485; + &#22522;&#20110;&#39063;&#31890;&#23646;&#24615;&#20004;&#27573;&#30528;&#33394;'</span>);
nexttile
showConnData(mPos, cList, cValue, mValue,<span class="string">'FaceColor'</span>,<span class="string">'interp'</span>);
camlight;
title(<span class="string">'&#22278;&#26609;&#65292; &#32447;&#23485; + &#22522;&#20110;&#39063;&#31890;&#23646;&#24615;&#25554;&#20540;&#30528;&#33394;'</span>);
snapnow;
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_03.png" alt=""> 
## CH4&#29699;&#26829;&#27169;&#22411;
<pre class="codeinput">mPos = [zeros(1,3);[sqrt(8)/3*cosd(30:120:270)',sqrt(8)/3*sind(30:120:270)',zeros(3,1)-1/3];0,0,1];
cList = [1,2;1,3;1,4;1,5];
mValue = [2,1,1,1,1]';

figure
s = struct(<span class="string">'X'</span>,mPos(:,1),<span class="string">'Y'</span>,mPos(:,2),<span class="string">'Z'</span>,mPos(:,3),<span class="string">'R'</span>,0.2*[1.5;ones(4,1)],<span class="string">'groupId'</span>,mValue);
bfs.show(s);

hold <span class="string">on</span>
showConnData(mPos, cList, 1, mValue, <span class="string">'tube'</span>,<span class="string">'FaceLighting'</span>,<span class="string">'gouraud'</span>);
colormap([1,0,0;1,1,1]);axis <span class="string">off</span>;
hold <span class="string">off</span>;
<span class="comment">% snapnow;</span>
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_04.png" alt=""> 
## NaCl&#29699;&#26829;&#27169;&#22411;
<pre class="codeinput">n=3;
[mX,mY,mZ]=ndgrid(1:n);
mPos=[mX(:),mY(:),mZ(:)];

mI=reshape(1:length(mPos),size(mX));
cList=[reshape(mI(1:end-1,:,:),[],1),reshape(mI(2:end,:,:),[],1);
    reshape(mI(:,1:end-1,:),[],1),reshape(mI(:,2:end,:),[],1);
    reshape(mI(:,:,1:end-1),[],1),reshape(mI(:,:,2:end),[],1)];

mValue =  mod(mI(:),2)+1;
s = struct(<span class="string">'X'</span>,mPos(:,1),<span class="string">'Y'</span>,mPos(:,2),<span class="string">'Z'</span>,mPos(:,3),<span class="string">'R'</span>,0.2*(mValue/2+0.5),<span class="string">'groupId'</span>,mValue);

<span class="comment">% subplot(1,2,1)</span>
bfs.show(s);
hold <span class="string">on</span>
showConnData(mPos, cList, 1/2, mValue,<span class="string">'FaceLighting'</span>,<span class="string">'gouraud'</span>);
colormap([1,0,1;0,1,0]);axis <span class="string">off</span>;
hold <span class="string">off</span>;
snapnow;

<span class="comment">% subplot(1,2,2)</span>
bfs.show(s);
hold <span class="string">on</span>
h = showConnData(mPos, cList, 1/2, 3,<span class="string">'FaceLighting'</span>,<span class="string">'gouraud'</span>);
colormap([1,0,1;0,1,0;1,1,1]);axis <span class="string">off</span>;
hold <span class="string">off</span>;
snapnow;

<span class="comment">%}</span>
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_05.png" alt=""> <img vspace="5" hspace="5" src="../../assets/images/help/Help_showConnData_06.png" alt=""> 
## &#21478;&#35831;&#21442;&#38405;
<p>coneplot, scatter, scatter3</p><p>Copyright 2018-2024 The MatDEM teams.</p><p class="footer"><br><a href="https://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2023a</a><br></p><link rel="stylesheet" href="../../assets/stylesheets/matlab_publish.css">