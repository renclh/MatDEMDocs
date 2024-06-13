
# showC
<!--introduction--><p>&#21487;&#35270;&#21270;d&#23545;&#35937;&#30340;&#36830;&#25509;&#25968;&#25454;</p><!--/introduction-->
## &#33014;&#32467;
<pre class="codeinput">load(<span class="string">'Test2D.mat'</span>);
d.calculateData();
d.setUIoutput();

d.mo.bFilter(:)=true;
d.mo.bFilter(1:5:end)=false;
d.mo.zeroBalance();

showC(d, <span class="string">'bFilter'</span>);
snapnow
</pre><pre class="codeoutput">UI output message box is not set in build.setUIoutput
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_01.png" alt=""> 
## &#20108;&#32500;&#21147;&#38142;
<pre class="codeinput">load(<span class="string">'Test2D.mat'</span>);
d.calculateData();
d.setUIoutput();
h = showC(d, <span class="string">'ForceChain'</span>);
snapnow

<span class="comment">% &#35843;&#25972;&#37197;&#33394;&#21450;&#30528;&#33394;&#26041;&#24335;</span>
set(h, <span class="string">'FaceColor'</span>, <span class="string">'flat'</span>);
snapnow;
</pre><pre class="codeoutput">UI output message box is not set in build.setUIoutput
Data is set in build.showData
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_02.png" alt=""> <img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_03.png" alt=""> 
## &#19977;&#32500;&#21147;&#38142;
<pre class="codeinput">load(<span class="string">'Test3D.mat'</span>);
d.calculateData();
d.setUIoutput();

h = showC(d, <span class="string">'ForceChain'</span>);
</pre><pre class="codeoutput">UI output message box is not set in build.setUIoutput
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_04.png" alt=""> <p>&#35843;&#25972;colormap</p><pre class="codeinput">colormap(<span class="string">"jet"</span>);snapnow;
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_05.png" alt=""> 
## &#20854;&#20182;&#23646;&#24615;&#25968;&#25454;
<pre class="codeinput">load(<span class="string">'Test3D.mat'</span>);
d.calculateData();
d.setUIoutput();

h = showC(d, <span class="string">'nFnX'</span>);
colormap(<span class="string">"jet"</span>)
</pre><pre class="codeoutput">UI output message box is not set in build.setUIoutput
</pre><img vspace="5" hspace="5" src="../../assets/images/help/Help_showC_06.png" alt=""> <p class="footer"><br><a href="https://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2023a</a><br></p><link rel="stylesheet" href="../../assets/stylesheets/matlab_publish.css">