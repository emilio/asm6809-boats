<?php ini_set('display_errors', 1); ?><!DOCTYPE html>
<!--[if lt IE 7 & (!IEMobile)]>
<html class="ie ie6 lt-ie7 lt-ie8 lt-ie9 no-js">
<![endif]-->
<!--[if (IE 7) & (!IEMobile)]>
<html class="ie ie7 lt-ie8 lt-ie9 no-js">
<![endif]-->
<!--[if (IE 8) & (!IEMobile)]>
<html class="ie ie8 lt-ie9 no-js">
<![endif]-->
<!--[if IE 9 & (!IEMobile)]>
<html class="ie ie9 no-js">
<![endif]-->
<!--[if (gt IE 9) | (IEMobile) | !(IE)  ]><!-->
<html class="no-js">
<!--<![endif]-->
<head prefix="og: http://ogp.me/ns# article: http://ogp.me/ns/article#">
	<meta charset="utf-8">

	<title></title>
	<style>
body {
	font-family: sans-serif;
	color: #252525;
	width: 960px;
	margin: 0 auto;
	max-width: 100%;
}
blockquote {
	background: #eee;
	font-style: italic;
	font-family: Times, serif;
	padding: .5em;
	border: 1px solid #ddd;
	border-left-width: 3px;
}

blockquote p {
	margin: 0;
	margin-top: 1em;
}

blockquote p:first-child {
	margin-top: 0;
}

blockquote cite {
	color: #666;
	display: block;
	text-align: right;
	font-size: .85em;
}
blockquote cite:before {
	content: "\2014 \2009";
}
@media print {
	blockquote {
		background: none;
	}
}
/**
 * prism.js default theme for JavaScript, CSS and HTML
 * Based on dabblet (http://dabblet.com)
 * @author Lea Verou
 */

code[class*="language-"],
pre[class*="language-"] {
	color: black;
	text-shadow: 0 1px white;
	font-family: Consolas, Monaco, 'Andale Mono', monospace;
	direction: ltr;
	text-align: left;
	white-space: pre;
	word-spacing: normal;
	
	-moz-tab-size: 8;
	-o-tab-size: 8;
	tab-size: 8;
	
	-webkit-hyphens: none;
	-moz-hyphens: none;
	-ms-hyphens: none;
	hyphens: none;
}

@media print {
	code[class*="language-"],
	pre[class*="language-"] {
		text-shadow: none;
	}
}

/* Code blocks */
pre[class*="language-"] {
	padding: 1em;
	margin: .5em 0;
	overflow: auto;	
}

:not(pre) > code[class*="language-"],
pre[class*="language-"] {
	/*background: #f5f2f0;*/
	border: 1px solid #ccc;
	border-width: 1px 0;
}

/* Inline code */
:not(pre) > code[class*="language-"] {
	padding: .1em;
	border-radius: .3em;
}

.token.comment,
.token.prolog,
.token.doctype,
.token.cdata {
	color: slategray;
}

.token.punctuation {
	color: #999;
}

.namespace {
	opacity: .7;
}

.token.property,
.token.tag,
.token.boolean,
.token.number {
	color: #905;
}

.token.selector,
.token.attr-name,
.token.string {
	color: #690;
}

.token.operator,
.token.entity,
.token.url,
.language-css .token.string,
.style .token.string {
	color: #a67f59;
	background: hsla(0,0%,100%,.5);
}

.token.atrule,
.token.attr-value,
.token.keyword {
	color: #07a;
}


.token.regex,
.token.important {
	color: #e90;
}

.token.important {
	font-weight: bold;
}

.token.entity {
	cursor: help;
}
.language-asm {
	font-size: .85em;
}
	</style>
</head>
<body>
	<?php $files = ['main', 'presentation', 'game_loop', 'game_io', 'rand', 'IO', 'rand_test']; ?>
	<div class="content">
		<h1 id="TOC">Contenidos</h1>
		<ul >
			<?php foreach ($files as $file): ?>
				<li><a href="#<?= $file ?>"><?= $file ?>.asm</a></li>
			<?php endforeach; ?>
		</ul>
		<?php foreach ($files as $file): ?>
			<h2 id="<?= $file ?>"><?= $file ?>.asm</h2>
			<pre data-language="asm" class="language-asm"><code><?= htmlspecialchars(file_get_contents($file . '.asm')); ?></code></pre>
			<a href="#TOC">Volver arriba</a>
		<?php endforeach; ?>
	</div>
<script type="text/javascript">
/**
 * Prism: Lightweight, robust, elegant syntax highlighting
 * MIT license http://www.opensource.org/licenses/mit-license.php/
 * @author Lea Verou http://lea.verou.me
 */(function(){var e=/\blang(?:uage)?-(?!\*)(\w+)\b/i,t=self.Prism={util:{type:function(e){return Object.prototype.toString.call(e).match(/\[object (\w+)\]/)[1]},clone:function(e){var n=t.util.type(e);switch(n){case"Object":var r={};for(var i in e)e.hasOwnProperty(i)&&(r[i]=t.util.clone(e[i]));return r;case"Array":return e.slice()}return e}},languages:{extend:function(e,n){var r=t.util.clone(t.languages[e]);for(var i in n)r[i]=n[i];return r},insertBefore:function(e,n,r,i){i=i||t.languages;var s=i[e],o={};for(var u in s)if(s.hasOwnProperty(u)){if(u==n)for(var a in r)r.hasOwnProperty(a)&&(o[a]=r[a]);o[u]=s[u]}return i[e]=o},DFS:function(e,n){for(var r in e){n.call(e,r,e[r]);t.util.type(e)==="Object"&&t.languages.DFS(e[r],n)}}},highlightAll:function(e,n){var r=document.querySelectorAll('code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code');for(var i=0,s;s=r[i++];)t.highlightElement(s,e===!0,n)},highlightElement:function(r,i,s){var o,u,a=r;while(a&&!e.test(a.className))a=a.parentNode;if(a){o=(a.className.match(e)||[,""])[1];u=t.languages[o]}if(!u)return;r.className=r.className.replace(e,"").replace(/\s+/g," ")+" language-"+o;a=r.parentNode;/pre/i.test(a.nodeName)&&(a.className=a.className.replace(e,"").replace(/\s+/g," ")+" language-"+o);var f=r.textContent;if(!f)return;f=f.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\u00a0/g," ");var l={element:r,language:o,grammar:u,code:f};t.hooks.run("before-highlight",l);if(i&&self.Worker){var c=new Worker(t.filename);c.onmessage=function(e){l.highlightedCode=n.stringify(JSON.parse(e.data));l.element.innerHTML=l.highlightedCode;s&&s.call(l.element);t.hooks.run("after-highlight",l)};c.postMessage(JSON.stringify({language:l.language,code:l.code}))}else{l.highlightedCode=t.highlight(l.code,l.grammar);l.element.innerHTML=l.highlightedCode;s&&s.call(r);t.hooks.run("after-highlight",l)}},highlight:function(e,r){return n.stringify(t.tokenize(e,r))},tokenize:function(e,n){var r=t.Token,i=[e],s=n.rest;if(s){for(var o in s)n[o]=s[o];delete n.rest}e:for(var o in n){if(!n.hasOwnProperty(o)||!n[o])continue;var u=n[o],a=u.inside,f=!!u.lookbehind||0;u=u.pattern||u;for(var l=0;l<i.length;l++){var c=i[l];if(i.length>e.length)break e;if(c instanceof r)continue;u.lastIndex=0;var h=u.exec(c);if(h){f&&(f=h[1].length);var p=h.index-1+f,h=h[0].slice(f),d=h.length,v=p+d,m=c.slice(0,p+1),g=c.slice(v+1),y=[l,1];m&&y.push(m);var b=new r(o,a?t.tokenize(h,a):h);y.push(b);g&&y.push(g);Array.prototype.splice.apply(i,y)}}}return i},hooks:{all:{},add:function(e,n){var r=t.hooks.all;r[e]=r[e]||[];r[e].push(n)},run:function(e,n){var r=t.hooks.all[e];if(!r||!r.length)return;for(var i=0,s;s=r[i++];)s(n)}}},n=t.Token=function(e,t){this.type=e;this.content=t};n.stringify=function(e){if(typeof e=="string")return e;if(Object.prototype.toString.call(e)=="[object Array]")return e.map(n.stringify).join("");var r={type:e.type,content:n.stringify(e.content),tag:"span",classes:["token",e.type],attributes:{}};r.type=="comment"&&(r.attributes.spellcheck="true");t.hooks.run("wrap",r);var i="";for(var s in r.attributes)i+=s+'="'+(r.attributes[s]||"")+'"';return"<"+r.tag+' class="'+r.classes.join(" ")+'" '+i+">"+r.content+"</"+r.tag+">"};if(!self.document){self.addEventListener("message",function(e){var n=JSON.parse(e.data),r=n.language,i=n.code;self.postMessage(JSON.stringify(t.tokenize(i,t.languages[r])));self.close()},!1);return}var r=document.getElementsByTagName("script");r=r[r.length-1];if(r){t.filename=r.src;document.addEventListener&&!r.hasAttribute("data-manual")&&document.addEventListener("DOMContentLoaded",t.highlightAll)}})();;
Prism.languages.asm = {
	comment: /;.*(\r?\n|$)/g,
	keyword: /\b(bra|beq|rts|abx|adca|adcb|adda|addb|addd|anda|andb|andcc|asla|aslb|asl|asra|asrb|asr|bita|bitb|clra|clrb|clr|cmpa|cmpb|cmpd|cmps|cmpu|cmpx|cmpy|coma|comb|com|cwai|daa|deca|decb|dec|eora|eorb|exg|inca|incb|inc|jmp|jsr|lda|ldb|ldd|lds|ldu|ldx|ldy|leas|leau|leax|leay|lsl|asl|asla|aslb|lsla|lslb|lsra|lsrb|mul|nega|negb|neg|nop|ora|orb|orcc|pshs|pshu|puls|pulu|rola|rolb|rol|rora|rorb|ror|sbca|sbcb|sex|sta|stb|std|stu|stx|sty|suba|subb|subd|tfr)\b/,
	string:/(")(\\?.)*?\1|'[a-zA-Z0-9\\]+/g,
	number:/\b-?(0x)?\d*\.?[\da-f]+\b/gi,
	directive:/\b\.(area|org|byte|word|ascii|asciz)\b/gi,
	punctuation:/[[\],.:\#]/g
}
</script>
</body>
