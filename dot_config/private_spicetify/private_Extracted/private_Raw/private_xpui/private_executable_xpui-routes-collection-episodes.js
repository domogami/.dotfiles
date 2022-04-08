"use strict";(("undefined"!=typeof self?self:global).webpackChunkopen=("undefined"!=typeof self?self:global).webpackChunkopen||[]).push([[289],{90110:(e,t,a)=>{a.d(t,{q:()=>D,o:()=>A});var n=a(63038),r=a.n(n),l=a(59713),i=a.n(l),o=a(67294),c=a.n(o),s=a(94184),u=a.n(s),m=a(69518),d=a.n(m),f=a(50020),g=a(96895),p=a(20657),E=a(83692),y=a(24656),v=a(69010),b=a(80946),h=a(6116),w=a(38209),k=a(40080);const C="l_MW0G9qeeCKlVJwBykT",P="BKsbV2Xl786X9a09XROH",N="HbKLiGoYM4dpuK8L4TMX",O="_APVWqivXc4YqgsnpFkP",S="VmwiDoU6RpqyzK_n7XRO",x="rEx3EYgBzS8SoY7dmC6x",L="z3zia5snl987x676qe5w";var D;!function(e){e[e.sm=24]="sm",e[e.md=32]="md"}(D||(D={}));var I=function(e){var t=e.currentTarget;e.detail>0&&t&&t.blur()},A=function(e){var t=e.uri,a=e.isFollowing,n=e.onFollow,l=e.size,s=void 0===l?D.sm:l,m=e.className,A=e.onClick,R=void 0===A?function(){}:A,_=i()({},"--size","".concat(s,"px")),M=(0,o.useContext)(y.I),z=M.useDownloading,T=M.useDownloadCapability,F=(0,o.useState)(!1),U=r()(F,2),Y=U[0],q=U[1],B=T(d().isEpisode(t)),j=r()(B,2),W=j[0],G=j[1],Z=(0,o.useState)(!1),K=r()(Z,2),V=K[0],X=K[1],Q=z(t),H=Q.currentAvailability,$=Q.progress,J=Q.beginDownload,ee=Q.clearDownload;!function(e,t){var a=(0,w.r)(),n=(0,o.useRef)(!1);(0,o.useEffect)((function(){e===v.V8.DOWNLOADING&&!1===n.current&&(n.current=!0,a.say(p.ag.get("download.downloading",t.totalItems)))}),[a,e,t]);var r=(0,k.D)(e);(0,o.useEffect)((function(){r===v.V8.DOWNLOADING&&e===v.V8.YES&&(n.current=!1,a.say(p.ag.get("download.complete")))}),[a,r,e])}(H,$);var te=(0,o.useCallback)((function(e){G===v.v$.DOWNLOADING_NOT_ALLOWED?X(!0):!1===a?(n(),q(!0)):J(),R(e),I(e)}),[J,G,a,R,n]),ae=(0,o.useCallback)((function(e){ee(),I(e),R(e)}),[ee,R]);return(0,o.useEffect)((function(){!0===Y&&!0===a&&(J(),q(!1))}),[a,Y,J]),W===v.PQ.NO_DOWNLOAD_CAPABILITY?null:G===v.v$.DOWNLOADING_NOT_ALLOWED?c().createElement("div",{className:P},c().createElement(E.w,{label:p.ag.get("download.download")},c().createElement("button",{className:u()(N,m),role:"switch",onClick:te,"aria-label":p.ag.get("download.download"),"aria-checked":!1},c().createElement(f.a,{iconSize:s}))),V&&c().createElement("div",{className:L},c().createElement(b.E,{withTopLeftPointer:!0,horizontal:!0,onClose:function(){X(!1)}},p.ag.get("download.upsell")))):H===v.V8.YES?c().createElement(E.w,{label:p.ag.get("download.remove")},c().createElement("button",{className:u()(N,m,O),role:"switch",onClick:ae,"aria-label":p.ag.get("download.remove"),"aria-checked":!0},c().createElement(g.C,{iconSize:s}))):H===v.V8.NO?c().createElement(E.w,{label:p.ag.get("download.download")},c().createElement("button",{className:u()(N,m),role:"switch",onClick:te,"aria-label":p.ag.get("download.download"),"aria-checked":!1},c().createElement(f.a,{iconSize:s}))):c().createElement("div",{className:u()(S,m),role:"switch","aria-checked":!0},c().createElement(E.w,{label:p.ag.get("download.cancel")},c().createElement("button",{style:_,className:u()(N,C,m),onClick:ae,"aria-label":p.ag.get("download.cancel")})),c().createElement("span",{style:_,className:u()(x,C)},c().createElement(h.e,{"aria-valuetext":p.ag.get("progress.downloading-tracks"),percentage:$.percentage,size:s})))}},37483:(e,t,a)=>{a.d(t,{p:()=>f,q:()=>m.q});var n=a(63038),r=a.n(n),l=a(67294),i=a.n(l),o=a(65858),c=a(4383),s=a(8475),u=a(56802),m=a(90110),d=i().memo((function(e){var t=e.uri,a=e.size,n=void 0===a?m.q.md:a,d=e.className,f=(0,c.Z)(t),g=r()(f,2),p=g[0],E=g[1],y=(0,o.I0)(),v=(0,u.o)(),b=(0,l.useCallback)((function(){v({targetUri:t,intent:p?"remove-from-library":"add-to-library",type:"click"}),E(!p),y(p?(0,s.SS)():(0,s.kK)())}),[v,t,p,E,y]);return i().createElement(m.o,{className:d,isFollowing:p,onFollow:b,uri:t,size:n})})),f=i().memo((function(e){return i().createElement(d,e)}))},14590:(e,t,a)=>{a.d(t,{Q:()=>o,$:()=>c});var n=a(67294),r=a.n(n),l=a(22583),i=a(5292),o=(0,n.createContext)({setSortState:function(){throw new Error("setSortState must be used within a LibrarySortProvider")},sortState:i.oT.ADDED_AT}),c=r().memo((function(e){var t=e.uri,a=e.children,n=e.defaultSortOption;return r().createElement(l.r,{uri:t,defaultState:n,sortContext:o},a)}))},88852:(e,t,a)=>{a.d(t,{E:()=>g});var n=a(67294),r=a.n(n),l=a(98816),i=a(45342),o=a(1496),c=a(61048),s=(a(21249),a(95289)),u=a(5292),m=a(14590),d=r().memo((function(e){var t=e.sortOptions,a=e.onSort,l=(0,n.useContext)(m.Q),i=l.sortState,o=l.setSortState,c=(0,n.useCallback)((function(e){var t=u.ei[e];null==a||a(t),o(t)}),[a,o]),d=t.map((function(e){return u.MY[e]})),f=u.MY[i];return r().createElement(s.A,{options:d,onSelect:c,selected:f})}));const f="QhF9ZR7YOiJeFiEnfkOr";var g=r().memo((function(e){var t=e.filterPlaceholder,a=e.sortOptions,s=(0,o.fU)(l.createDesktopSearchBarEventFactory,{}),u=s.spec,m=s.logger,g=(0,n.useContext)(i.H),p=(0,n.useCallback)((function(){m.logInteraction(u.filterFieldFactory().keyStrokeFilter())}),[m,u]),E=(0,n.useCallback)((function(){m.logInteraction(u.filterFieldFactory().hitClearFilter())}),[m,u]),y=(0,n.useCallback)((function(){m.logInteraction(u.sortButtonFactory().hitSort())}),[m,u]);return r().createElement("div",{className:f},null!=g&&g.getCapabilities().canFilter?r().createElement(n.Suspense,{fallback:null},r().createElement(c.K,{placeholder:t,onFilter:p,onClear:E})):null,null!=g&&g.getCapabilities().canSort?r().createElement(d,{sortOptions:a,onSort:y}):null)}))},72831:(e,t,a)=>{a.r(t),a.d(t,{YourEpisodes:()=>pe,YourEpisodesContainer:()=>Ee,default:()=>ye});var n=a(59713),r=a.n(n),l=(a(57327),a(41539),a(68309),a(67294)),i=a.n(l),o=a(9296),c=a(20657),s=a(30947),u=a(55911),m=a(44887),d=a(53646),f=a(45342),g=a(84242),p=a(89952),E=a(4236),y=a(36132),v=a(14590),b=a(88852),h=a(19565),w=a(42273),k=a(59482),C=a(72907),P=a(1663),N=a(55120),O=a(22423),S=a(5292),x=a(56347),L=a(64624),D=a(319),I=a.n(D),A=a(48926),R=a.n(A),_=a(63038),M=a.n(_),z=a(87757),T=a.n(z),F=(a(9653),a(40561),a(92222),a(21249),a(47941),a(82526),a(38880),a(89554),a(54747),a(49337),a(33321),a(69070),a(33241)),U=a(42922),Y=a(18864),q=(a(41817),a(83710),a(39714),a(37763)),B=a.n(q),j=a(20246),W=a(18261),G=a(87257),Z=a(57978),K=a(75016),V=a(4383),X=a(24656),Q=a(8341),H=a(5944),$=a(42781),J=a(84788),ee=a(15212),te=a(56802),ae=a(95661),ne=a(25988),re=a(63133),le=a(95806),ie=a(96525),oe=a(16783),ce={small:64,standard:300,large:640,xlarge:1024},se=i().memo((function(e){var t,a,n,r,o=e.index,s=e.contextUri,u=e.episode,m=e.onRemove,d=e.usePlayContextItem,f=(0,l.useRef)(u.duration.milliseconds-u.timeLeft.milliseconds),p=u.uri,y=(0,l.useState)(0===u.timeLeft.milliseconds),v=M()(y,2),b=v[0],h=v[1],w=(0,l.useContext)(O.fo).filter,k=(0,ie.P)(),C=(0,ee.O1)(),P=(0,Y.jh)(),N=(0,te.o)(),S=(0,V.Z)(p,!0),x=M()(S,1)[0],L=(0,(0,l.useContext)(X.I).useCurrentAvailability)(p),D=M()(L,1)[0],I=(0,E.k)(),A=(0,Q.Y)((function(e){var t;if((null==e||null===(t=e.item)||void 0===t?void 0:t.uri)===u.uri){var a,n=null!==(a=(0,H.k)(e))&&void 0!==a?a:0;return f.current=n,n}return 0})),R=d({uri:p,index:o}),_=R.isPlaying,z=R.isActive,T=R.togglePlay,F=(0,g.n)({uri:p,pages:[{items:[{type:$.p.EPISODE,uri:p,uid:null,provider:null}]}]},{featureIdentifier:"your_library",referrerIdentifier:"your_library"}),q=F.isPlaying,se=F.isActive,ue=F.togglePlay;(0,l.useEffect)((function(){x||m()}),[x,m]),(0,l.useEffect)((function(){_||u.duration.milliseconds<=f.current&&h(!0)}),[_,u.duration.milliseconds]);var me=(0,l.useCallback)((function(e){e||(f.current=0),h(e)}),[]),de=(0,l.useCallback)((function(){N({type:"click",targetUri:p,intent:"navigate"})}),[p,N]),fe=(0,l.useCallback)((function(){I?(N({type:"click",intent:_?"pause":"play"}),T()):(N({type:"click",intent:q?"pause":"play"}),ue())}),[I,_,q,N,T,ue]),ge=(0,l.useCallback)((function(e){return i().createElement(B(),{searchWords:[w],textToHighlight:e,findChunks:k,highlightClassName:oe.Z.filterHighlight})}),[w,k]),pe=null!==(t=null===(a=u.podcastSubscription)||void 0===a?void 0:a.isPaywalled)&&void 0!==t&&t,Ee=null!==(n=null===(r=u.podcastSubscription)||void 0===r?void 0:r.isUserSubscribed)&&void 0!==n&&n,ye=(0,J.r)({isExplicit:u.isExplicit,isMOGEFRestricted:u.is19PlusOnly,isPaywalled:pe}).badges,ve=!1;return(z||!I&&se)&&(ve=!0),x?i().createElement(U.ZP,{value:"row",index:o},i().createElement(W._,{menu:i().createElement(ne.k,{uri:p,showUri:u.show.uri,isPlayed:b,onMarkAsPlayed:me})},i().createElement(re.X,{index:o,uri:p,uid:p,size:P,images:u.images.map((function(e){return{url:e.url,width:e.width||(e.label?ce[e.label]:null),height:e.height||(e.label?ce[e.label]:null)}})),isPaywalled:pe,isUserSubscribed:Ee,name:u.name,highlightText:ge,showName:u.show.name,showUri:u.show.uri,description:u.description,isPlayable:u.isPlayable&&D,fullyPlayed:b,durationMs:u.duration.milliseconds,releaseDate:u.release.date.toString()||"",resumePositionMs:f.current,handleDragStart:function(e){if(e.target===e.currentTarget){var t="".concat(u.name," · ").concat(u.show.name);C(e,[p],t,s)}},handlePlaybackClick:fe,handleClick:de,isCurrentlyPlaying:ve,isPlaying:I?_:q,position:ve?A:void 0,episodeSharingInfo:null,onMarkAsPlayed:me,badges:i().createElement(i().Fragment,null,ye.explicit&&i().createElement(G.N,null),ye.paid&&i().createElement(K.g,null),ye.nineteen&&i().createElement(Z.X,{size:16})),playButtonWrapper:function(e){return i().createElement(le.l,{enabled:pe&&!Ee,showUri:u.show.uri},e)},topActionButtons:i().createElement(j.y,{menu:i().createElement(ne.k,{uri:p,showUri:u.show.uri,isPlayed:b,onMarkAsPlayed:me})},i().createElement(ae.z,{size:ae.q.sm,label:c.ag.get("more.label.context",u.name)}))}))):null}));const ue="ybohLfAC_k3fYjRJHzKA",me="rQL2Hxclr2PkKkrBfr8T";function de(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function fe(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?de(Object(a),!0).forEach((function(t){r()(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):de(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}var ge=i().memo((function(e){var t,a=e.contextUri,n=e.usePlayContextItem,o=(0,l.useContext)(f.H),c=(0,l.useContext)(v.Q).sortState,s=(0,l.useState)({totalLength:0,offset:0,items:[],limit:50}),u=M()(s,2),m=u[0],d=u[1],g=(0,l.useRef)(!1),p=(0,l.useRef)(0),E=(0,l.useRef)(0),y=(0,l.useContext)(O.fo).filter,b=(0,l.useCallback)((function(){E.current++}),[]),h=(0,Y.Db)((t={},r()(t,Y.Uo.MEDIUM,0),r()(t,Y.Uo.LARGE,600),t)),w=h.ref,k=h.breakpoint,C=(0,l.useCallback)((function(){var e=arguments.length>0&&void 0!==arguments[0]&&arguments[0],t=function(){var e=R()(T().mark((function e(t){var a;return T().wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.next=2,o.getEpisodes({offset:t-E.current,limit:50,sort:(0,S.sv)(c),filter:y});case 2:return a=e.sent,E.current=0,e.abrupt("return",a);case 5:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),a=p.current;null!==a&&(g.current||(g.current=!0,t(Number(a)).then((function(t){d((function(n){var r=Number(t.offset)+t.items.length,l=e?[]:I()(n.items);return l.splice.apply(l,[Number(a),t.items.length].concat(I()(t.items))),p.current=r<t.totalLength?r:null,fe(fe({},t),{},{items:l})})),g.current=!1}))))}),[y,o,c]);return(0,l.useEffect)((function(){p.current=0,C(!0)}),[C]),i().createElement(Y.ZU.Provider,{value:k},i().createElement(U.ZP,{value:"track-list"},i().createElement("div",{ref:w},i().createElement(F.C,{onReachBottom:C,triggerOnInitialLoad:!0},m.items.map((function(e,t){return i().createElement("div",{className:me,key:"".concat(t).concat(e.uri)},i().createElement("hr",{className:ue,"aria-hidden":!0}),i().createElement(se,{key:"".concat(e.uri,"/").concat(t),index:t,episode:e,contextUri:a,onRemove:b,usePlayContextItem:n}))}))))))})),pe=function(e){var t,a=e.metadata,n=e.canSort,f=(0,d.Y5)("#006450"),P=(0,l.useContext)(v.Q).sortState,x=(0,l.useContext)(O.fo).filter,D=(0,E.k)(),I=(0,g.n)({uri:a.uri,metadata:(t={},r()(t,p.sb.SORTING_CRITERIA,(0,S._s)(P)),r()(t,p.sb.FILTERING_PREDICATE,(0,y.aK)(x)),t)},{featureIdentifier:"your_library",referrerIdentifier:"your_library"}),A=I.isPlaying,R=I.togglePlay,_=I.usePlayContextItem,M=function(){return R()},z=a.uri,T=a.name,F=a.images,U=a.totalLength,Y=a.owner,q=(0,l.useMemo)((function(){return{id:Y.username,uri:Y.uri,name:Y.username,displayName:Y.displayName||void 0,images:Y.images||[]}}),[Y]),B=a.totalLength>0;return i().createElement("section",{className:oe.Z.yourEpisodes,"data-testid":"your-episodes-page"},i().createElement(w.gF,{backgroundColor:f},i().createElement(k.W,null,i().createElement(N.$,{size:u.qE.sm,onClick:M,isPlaying:A,uri:z,disabled:!D,ariaPlayLabel:c.ag.get("playlist.a11y.play",T),ariaPauseLabel:c.ag.get("playlist.a11y.pause",T)}),i().createElement(C.i,{text:T})),i().createElement(w.Oz,{images:F,name:T,shape:m.K.ROUNDED_CORNERS,renderImage:function(){return i().createElement(L.$,null)}}),i().createElement(w.sP,null,i().createElement(w.dy,{small:!0,uppercase:!0},c.ag.get("playlist")),i().createElement(w.xd,{canEdit:!1,onClick:function(){}},T),i().createElement(w.QS,{creators:[q],totalEpisodes:U}))),i().createElement("div",{className:oe.Z.yourEpisodesContentWrapper},i().createElement(s.o,{backgroundColor:f},i().createElement(s.F,null,B&&i().createElement(N.$,{onClick:M,isPlaying:A,size:u.qE.lg,uri:z,disabled:!D,ariaPlayLabel:c.ag.get("playlist.a11y.play",T),ariaPauseLabel:c.ag.get("playlist.a11y.pause",T)}),n&&i().createElement("div",{className:oe.Z.searchBoxContainer},i().createElement(b.E,{filterPlaceholder:c.ag.get("playlist.search_in_playlist"),sortOptions:S.$2})))),i().createElement("div",{className:"contentSpacing"},a.totalLength>0&&i().createElement(ge,{contextUri:z,usePlayContextItem:_}))),0===a.totalLength&&i().createElement("div",{className:"contentSpacing"},i().createElement(h.u,{message:c.ag.get("collection.empty-page.episodes-subtitle"),title:c.ag.get("collection.empty-page.episodes-title"),linkTo:"/genre/podcasts-web",linkTitle:c.ag.get("collection.empty-page.shows-cta"),renderInline:!0},i().createElement(o.Z,null))))},Ee=i().memo((function(){var e=(0,l.useContext)(f.H).getCapabilities(),t=(0,x.x)();return t?i().createElement(v.$,{uri:t.uri,defaultSortOption:S.oT.ADDED_AT},i().createElement(O.hz,{uri:t.uri},i().createElement(pe,{metadata:t,canSort:e.canSort&&t.totalLength>0}))):i().createElement(P.h,{hasError:!1,errorMessage:c.ag.get("error.not_found.title.page"),loadOffline:e.canModifyOffline})}));const ye=Ee},40080:(e,t,a)=>{a.d(t,{D:()=>r});var n=a(67294);function r(e){var t=(0,n.useRef)();return(0,n.useEffect)((function(){t.current=e}),[e]),t.current}},92408:(e,t,a)=>{a.d(t,{E:()=>U,$:()=>A});var n=a(59713),r=a.n(n),l=a(67294),i=a.n(l),o=a(43315),c=(a(41539),a(12419),a(34575)),s=a.n(c),u=a(93913),m=a.n(u),d=a(2205),f=a.n(d),g=a(78585),p=a.n(g),E=a(29754),y=a.n(E);const v="wIA_5Ypq0rltNPeZQpM4",b="Swi6YtNEFCCVz8l4y75v",h="pklLPOhfigdytL9bPoth",w="sb24Y8kdMZInJ8aI8dXT";function k(e){var t=function(){if("undefined"==typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"==typeof Proxy)return!0;try{return Boolean.prototype.valueOf.call(Reflect.construct(Boolean,[],(function(){}))),!0}catch(e){return!1}}();return function(){var a,n=y()(e);if(t){var r=y()(this).constructor;a=Reflect.construct(n,arguments,r)}else a=n.apply(this,arguments);return p()(this,a)}}var C=function(e){f()(a,e);var t=k(a);function a(){return s()(this,a),t.apply(this,arguments)}return m()(a,[{key:"render",value:function(){var e=this.props,t=e.ariaValueText,a=e.max,n=e.current,r=a&&n?100*Math.min(1,n/a):0,l={transform:"translateX(-".concat(100-r,"%)")},o=t||"".concat(Math.round(r),"%");return i().createElement("div",{className:v,role:"progressbar",tabIndex:0,"aria-valuenow":n,"aria-valuemin":0,"aria-valuemax":a,"aria-valuetext":o},i().createElement("div",{className:b}),i().createElement("div",{className:h},i().createElement("div",{"data-testid":"progressBarFg",className:w,style:l})))}}]),a}(l.PureComponent);r()(C,"defaultProps",{current:0,max:1});const P=C,N="qfYkuLpETFW3axnfMntO",O="jOd7lbjiyc_kvRJaAbeL",S="_q93agegdE655O5zPz6l",x="z7Yl7CIT1AB0y91f_moh",L="iLIlkUcfIq56KncGtX7u",D="nV50yZ6BR_TIuWP3l7b1",I="qLjIx_SzBEpDRA_q7kxQ";var A,R=a(28760),_=a(40378),M=a(20657),z=a(94184),T=a.n(z),F=a(33985);!function(e){e[e.LARGE=0]="LARGE",e[e.SMALL=1]="SMALL"}(A||(A={}));var U=function(e){var t=e.resumePositionMs,a=void 0===t?0:t,n=e.releaseDate,l=e.isPlaying,c=e.fullyPlayed,s=e.durationMs,u=e.size,m=void 0===u?A.SMALL:u,d=e.position,f=void 0===d?a:d;return i().createElement("div",{className:T()(N,r()({},O,m===A.LARGE))},n?i().createElement(R.Dy,{as:"p",variant:"mesto",className:S},(0,o.rL)((0,o.RX)(n))):null,function(){if(c&&!l)return i().createElement("div",{className:L},i().createElement(R.Dy,{as:"p",variant:"mesto",className:x},M.ag.get("episode.played")),i().createElement(_.R,{iconSize:16,className:I}));if(f>0||l){var e=Math.ceil(Math.max(s-f,0));return i().createElement("div",{className:L},i().createElement(R.Dy,{as:"p",variant:"mesto",className:x},i().createElement(F.ng,{durationMs:e})))}return i().createElement(R.Dy,{as:"p",variant:"mesto",className:S},i().createElement(F.nL,{durationMs:s}))}(),!c&&f>0||l?i().createElement("div",{className:D},i().createElement(P,{current:f,max:s,isEnabled:!1})):null)}}}]);
//# sourceMappingURL=xpui-routes-collection-episodes.js.map