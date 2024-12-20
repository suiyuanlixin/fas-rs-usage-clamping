let e=0;function t(t,a){return void 0===a&&(a={}),new Promise((r,s)=>{let n=`exec_callback_${Date.now()}_${e++}`;function l(e){delete window[e]}window[n]=(e,t,a)=>{r({errno:e,stdout:t,stderr:a}),l(n)};try{ksu.exec(t,JSON.stringify(a),n)}catch(e){s(e),l(n)}})}function a(){this.listeners={}}function r(){this.listeners={},this.stdin=new a,this.stdout=new a,this.stderr=new a}function s(e){ksu.toast(e)}a.prototype.on=function(e,t){this.listeners[e]||(this.listeners[e]=[]),this.listeners[e].push(t)},a.prototype.emit=function(e,...t){this.listeners[e]&&this.listeners[e].forEach(e=>e(...t))},r.prototype.on=function(e,t){this.listeners[e]||(this.listeners[e]=[]),this.listeners[e].push(t)},r.prototype.emit=function(e,...t){this.listeners[e]&&this.listeners[e].forEach(e=>e(...t))};const n={interval_ms:"/sys/module/cpufreq_clamping/parameters/interval_ms",boost_app_switch_ms:"/sys/module/cpufreq_clamping/parameters/boost_app_switch_ms",baseline_freq:"/sys/module/cpufreq_clamping/parameters/baseline_freq",margin:"/sys/module/cpufreq_clamping/parameters/margin",boost_baseline_freq:"/sys/module/cpufreq_clamping/parameters/boost_baseline_freq",max_freq:"/sys/module/cpufreq_clamping/parameters/max_freq",nr_cluster:"/sys/module/cpufreq_clamping/parameters/nr_cluster"};async function l(e){let{errno:a,stdout:r}=await t(`cat ${e}`);return 0===a?r.trim():""}async function i(){let e=await Promise.all(Object.entries(n).map(async([e,t])=>({name:e,value:await l(t)}))),t=e.find(e=>"interval_ms"===e.name);t&&(document.getElementById("interval_ms").value=t.value);let a=e.find(e=>"boost_app_switch_ms"===e.name);a&&(document.getElementById("boost_app_switch_ms").value=a.value);let r=parseInt(e.find(e=>"nr_cluster"===e.name)?.value||"0",10),s=(e.find(e=>"baseline_freq"===e.name)?.value||"").split("\n"),i=(e.find(e=>"margin"===e.name)?.value||"").split("\n"),u=(e.find(e=>"boost_baseline_freq"===e.name)?.value||"").split("\n"),o=(e.find(e=>"max_freq"===e.name)?.value||"").split("\n"),c=document.getElementById("cluster-parameters");c.innerHTML="";for(let e=0;e<r;e++){let t=s.find(t=>t.startsWith(`${e} `))?.split(" ")[1]||"",a=t?Math.floor(parseInt(t)/1e3).toString():"",r=i.find(t=>t.startsWith(`${e} `))?.split(" ")[1]||"",n=r?Math.floor(parseInt(r)/1e3).toString():"",l=u.find(t=>t.startsWith(`${e} `))?.split(" ")[1]||"",p=l?Math.floor(parseInt(l)/1e3).toString():"",m=o.find(t=>t.startsWith(`${e} `))?.split(" ")[1]||"",_=m?Math.floor(parseInt(m)/1e3).toString():"",d=document.createElement("div");d.classList.add("parameter-card"),d.innerHTML=`
        <div class="cluster-container">
            <h3>Cluster ${e}:</h3>
            <div class="input-row">
                <div class="input-group">
                    <label for="baseline_freq_${e}" class="parameter-label">\u{57FA}\u{51C6}\u{9891}\u{7387}\u{FF08}MHz\u{FF09}:</label>
                    <input type="number" id="baseline_freq_${e}" class="parameter-input" placeholder="\u{8F93}\u{5165}\u{57FA}\u{51C6}\u{9891}\u{7387}\u{FF08}MHz\u{FF09}" value="${a}">
                </div>
                
                <div class="input-group">
                    <label for="margin_${e}" class="parameter-label">\u{4F59}\u{91CF}\u{FF08}MHz\u{FF09}:</label>
                    <input type="number" id="margin_${e}" class="parameter-input" placeholder="\u{8F93}\u{5165}\u{4F59}\u{91CF}\u{FF08}MHz\u{FF09}" value="${n}">
                </div>
            </div>

            <div class="input-row">
                <div class="input-group">
                    <label for="boost_baseline_freq_${e}" class="parameter-label">boost \u{9891}\u{7387}\u{FF08}MHz\u{FF09}:</label>
                    <input type="number" id="boost_baseline_freq_${e}" class="parameter-input" placeholder="\u{8F93}\u{5165} boost \u{9891}\u{7387}\u{FF08}MHz\u{FF09}" value="${p}">
                </div>

                <div class="input-group">
                    <label for="max_freq_${e}" class="parameter-label">\u{6700}\u{5927}\u{9891}\u{7387}\u{FF08}MHz\u{FF09}:</label>
                    <input type="number" id="max_freq_${e}" class="parameter-input" placeholder="\u{8F93}\u{5165}\u{6700}\u{5927}\u{9891}\u{7387}\u{FF08}MHz\u{FF09}" value="${_}">
                </div>
            </div>
        </div>
    `,c.appendChild(d)}}async function u(e,a){await t(`echo "${a}" > ${e}`)}async function o(){let e=document.getElementById("interval_ms").value,a=document.getElementById("boost_app_switch_ms").value,r=document.getElementById("cluster-parameters").querySelectorAll(".parameter-card");try{let l;await u(n.interval_ms,e),await u(n.boost_app_switch_ms,a);for(let e=0;e<r.length;e++){let t=r[e].querySelector(`#baseline_freq_${e}`).value,a=t?(1e3*parseInt(t)).toString():"";await u(n.baseline_freq,`${e} ${a}`)}for(let e=0;e<r.length;e++){let t=r[e].querySelector(`#margin_${e}`).value,a=t?(1e3*parseInt(t)).toString():"";await u(n.margin,`${e} ${a}`)}for(let e=0;e<r.length;e++){let t=r[e].querySelector(`#boost_baseline_freq_${e}`).value,a=t?(1e3*parseInt(t)).toString():"";await u(n.boost_baseline_freq,`${e} ${a}`)}for(let e=0;e<r.length;e++){let t=r[e].querySelector(`#boost_baseline_freq_${e}`).value,a=t?(1e3*parseInt(t)).toString():"";await u(n.boost_baseline_freq,`${e} ${a}`)}for(let e=0;e<r.length;e++){let t=r[e].querySelector(`#max_freq_${e}`).value,a=t?(1e3*parseInt(t)).toString():"";await u(n.max_freq,`${e} ${a}`)}let o=(l=`interval_ms=${e}
boost_app_switch_ms=${a}
`,r.forEach((e,t)=>{let a=e.querySelector(`#baseline_freq_${t}`).value,r=e.querySelector(`#boost_baseline_freq_${t}`).value,s=e.querySelector(`#max_freq_${t}`).value,n=e.querySelector(`#margin_${t}`).value;l+=`#cluster${t}
baseline_freq=${a}
margin=${n}
boost_baseline_freq=${r}
max_freq=${s}
`}),l),{errno:c}=await t(`echo "${o}" > /data/cpufreq_clamping.conf`);0===c?(s("参数更新成功!"),i()):s("参数更新失败！")}catch(e){s("参数更新失败！")}}document.addEventListener("DOMContentLoaded",i),document.getElementById("confirm-parameters").addEventListener("click",o),document.getElementById("refresh-parameters").addEventListener("click",i);