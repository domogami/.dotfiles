"use strict";(("undefined"!=typeof self?self:global).webpackChunkopen=("undefined"!=typeof self?self:global).webpackChunkopen||[]).push([[133],{63133:(e,t,n)=>{n.d(t,{X:()=>ne});var a=n(59713),i=n.n(a),r=(n(68309),n(82526),n(41817),n(69600),n(67294)),o=n.n(r),s=n(94184),l=n.n(s),c=n(40160),u=n(16528),m=n(69518),d=n.n(m),E=n(28760),S=n(28342),p=n(20657),I=n(46245),_=n(32626),Z=n(44887),f=n(7469),h=n(34325),g=n(18864),v=n(48926),y=n.n(v),N=n(63038),C=n.n(N),b=n(87757),w=n.n(b),x=n(54280);var k=n(42781),D=n(92408),O=n(95661),A=n(25988),U=(n(26699),n(32023),n(11414)),P=n(24656),R=n(69010),T=n(37483),L=n(51871),M=n(60417),B=n(8716),j=n(22819);const z="pvGZ831aNzHTQMZ8CA_u";var V=o().memo((function(e){var t=e.onClick,n=void 0===t?function(){}:t,a=e.size,i=e.className,s=e.uri,c=e.sharingInfo,u=e.interactionData,m=(0,j.y)({sharingInfo:c,uri:s,interactionData:u}).onCopyLink,d=(0,r.useCallback)((function(){m(),n()}),[n,m]);return o().createElement(B.E,{ariaLabel:p.ag.get("mwp.list.item.share"),size:a,onClick:d,className:l()(z,i),icon:M.M})})),H=n(45063),G={intent:"share",type:"click",itemIdSuffix:"contextmenu/episode/share"},W=o().memo((function(e){var t=e.episodeUri,n=e.showUri,a=e.sharingInfo,s=e.canDownload,c=(0,(0,r.useContext)(P.I).useDownloading)(t).currentAvailability,u=[R.V8.YES,R.V8.DOWNLOADING,R.V8.WAITING].includes(c),m=(0,r.useMemo)((function(){return o().createElement(T.p,{uri:t,size:T.q.sm,showUri:n,className:l()(i()({},H.Z.visibleDownloadButton,u))})}),[t,n,u]),d=(0,r.useMemo)((function(){return o().createElement(V,{uri:t,sharingInfo:a,interactionData:G})}),[t,a]),E=(0,r.useMemo)((function(){return o().createElement(L.w,{uri:t,size:U.q.sm,className:H.Z.saveButton})}),[t]);return o().createElement(o().Fragment,null,d,s&&m,E)})),q=n(96483),F=n(87577),Q=n(44503),Y=n(62890);const K="rFwxt8s8DYY8p1O7tYZW",J="sA2HogGQNi8R_zpCWei5",X="HcKLQt9vikKg7rs8bK5H",$="H92pPTuqDR5DcoTtjcb3";var ee=function(e){var t=e.cardHeaderText,n=e.buttonText,a=e.buttonTarget,i=e.className,s=(0,F.W6)(Q.Xd),c=(0,r.useCallback)((function(e){e.stopPropagation()}),[]);return s?o().createElement("div",{className:l()(K,i)},o().createElement("div",{className:J},o().createElement(q.V,{className:$,iconSize:16,semanticColor:"textBase"}),o().createElement(E.Dy,{as:"span",variant:"balladBold",semanticColor:"textBase"},t)),o().createElement(Y.z,{version:"secondary",linkTo:d().from(a).toURLPath(!0),className:X,onClick:c},n)):null};const te={episodeBlock:"TT1tIewS2iI8Uz8kLuQB",isActive:"Mn93NeoqnZzVnPIP83_9",title:"bG5fSAAS6rRL8xxU5iyG",titleLink:"g5gZaZVzR0tGT4pK6iEU",selected:"u9GYp1CdMSk8BG9i2o1n",topActions:"Xga3T31ofx1oxxRVrMdW",actions:"DbMYFmOEEz9PH1h1zK9n",titleContainer:"HLixBI5DbVZNC6lrUbAB",musicAndTalkArtistContainer:"YhOAZFuFU1oI_YQSof4z",musicAndTalkArtists:"DKIjGP8CcZyjr2O2HNST",playlistIcon:"A7qeQBIk3sqr7bYadWA8",noHover:"_IJaGA3ZdVU0NiTxbGsI",imageContainer:"ij5_Bi2LfqgWwHzQBXJS",showImage:"o_TP9z7A8LQvMXujJC7N",description:"LbePDApGej12_NyRphHu",metadata:"y9kEPjDek0J80YRf8JJw",badges:"hFCGY5gjCjN10WzV2VQ4",medium:"gk0rZwqBxJjSeiWV5lgV",large:"te8hrsPnSvx9SUkzV0ME",header:"V0pEigrddg3VxP_sTdAJ",descriptionContainer:"upo8sAflD1byxWObSkgn",playerActions:"DyuLxip2Kl8P7H8fW62u",contentInformationBanner:"vak8N953oXaq9F7jZDsD"};var ne=o().memo((function(e){var t,n,a=e.uri,s=e.name,m=e.showName,v=e.showUri,N=e.size,b=e.description,U=e.durationMs,P=e.images,R=e.badges,T=e.fullyPlayed,L=e.releaseDate,M=e.resumePositionMs,B=e.isCurrentlyPlaying,j=e.isPlaying,z=e.onContextMenu,V=e.onTouchStart,H=e.onTouchEnd,G=e.handlePlaybackClick,q=e.handleDragStart,F=e.handleClick,Q=e.position,Y=e.index,K=e.isPlayable,J=e.isPaywalled,X=e.isUserSubscribed,$=e.episodeSharingInfo,ne=e.playButtonWrapper,ae=void 0===ne?null:ne,ie=e.highlightText,re=void 0===ie?function(e){return e}:ie,oe=e.onMarkAsPlayed,se=e.contentInformation,le=(0,u.k6)(),ce=B&&j,ue=d().from(a).toURLPath(!0),me=null===(t=d().from(v))||void 0===t?void 0:t.toURLPath(!0),de=function(e){var t=e.episodeUri,n=(0,r.useState)([]),a=C()(n,2),i=a[0],o=a[1],s=(0,x.G)();return(0,r.useEffect)((function(){var e=!0;function n(){return(n=y()(w().mark((function n(){var a;return w().wrap((function(n){for(;;)switch(n.prev=n.next){case 0:return n.next=2,s.getArtists(t);case 2:a=n.sent,e&&o(a);case 4:case"end":return n.stop()}}),n)})))).apply(this,arguments)}return function(){n.apply(this,arguments)}(),function(){e=!1}}),[t,s]),i}({episodeUri:a}),Ee=(0,h.G3)(a,L,M,T),Se=(0,r.useCallback)((function(e){e.stopPropagation(),e.preventDefault(),le.push(ue),F&&F(e)}),[ue,le,F]),pe=(0,r.useCallback)((function(e){e.stopPropagation(),e.preventDefault(),me&&le.push(me)}),[me,le]),Ie=J&&!X,_e=(0,r.useCallback)((function(e){e.stopPropagation(),Ie||G(e)}),[G,Ie]),Ze=function(e){e.stopPropagation()},fe=Ie||K,he=p.ag.get("tracklist.a11y.play",s,m),ge=p.ag.get("tracklist.a11y.pause",s,m),ve=o().createElement(I.fh,{size:"sm",version:I.ul.secondary,onClick:_e,isPlaying:ce,disabled:!fe,locked:Ie,ariaPlayLabel:he,ariaPauseLabel:ge}),ye=ae?ae(ve):ve;return o().createElement("div",{className:l()(te.episodeBlock,(n={},i()(n,te.isActive,B),i()(n,te.medium,N===g.Uo.MEDIUM),i()(n,te.large,N===g.Uo.LARGE),i()(n,te.noHover,N===g.Uo.XSMALL),n)),"data-testid":"episode-".concat(Y),draggable:!!q,onDragStart:q,onClick:Se,onContextMenu:z,onTouchStart:V,onTouchEnd:H},se&&o().createElement(ee,{className:te.contentInformationBanner,cardHeaderText:se.cardHeaderText,buttonText:se.buttonText,buttonTarget:se.buttonTarget}),o().createElement("div",{className:te.imageContainer},o().createElement(Z.O,{className:l()(te.entityImage,te.showImage),type:k.p.EPISODE,size:function(e){switch(e){case g.Uo.LARGE:return f.m$.SIZE_112;case g.Uo.MEDIUM:return f.m$.SIZE_64;default:return f.m$.SIZE_48}}(N),title:s,shape:Z.K.ROUNDED_CORNERS,images:P})),o().createElement("div",{className:te.header},o().createElement("div",{className:te.titleContainer},o().createElement(c.rU,{className:te.titleLink,to:ue,onClick:Se},o().createElement(E.Dy,{as:"h4",variant:"balladBold",className:te.title,"data-testid":"episodeTitle"},Ee&&o().createElement(h.Rd,null),re(s))),de.length>0&&o().createElement("div",{className:te.musicAndTalkArtistContainer},o().createElement(S.e,{iconSize:16,className:te.playlistIcon}),o().createElement(E.Dy,{as:"p",variant:"mesto",className:te.musicAndTalkArtists},re(de.join(", "))))),m&&me&&o().createElement(c.rU,{className:te.titleLink,to:me,onClick:pe},o().createElement(E.Dy,{as:"h4",variant:"mestoBold",className:te.title},re(m)))),o().createElement("div",{className:te.descriptionContainer},o().createElement(E.Dy,{as:"p",variant:"mesto",className:te.description},re(null!=b?b:""))),o().createElement("div",{className:te.metadata},o().createElement("div",{className:te.badges},R),o().createElement(D.E,{isPlaying:ce,fullyPlayed:T,durationMs:U,releaseDate:L,resumePositionMs:M,position:B?Q:void 0})),o().createElement("div",{onClick:Ze,className:te.topActions,"data-testid":"action-buttons"},o().createElement(_.yj,{menu:o().createElement(A.k,{uri:a,showUri:v,isPlayed:T,onMarkAsPlayed:oe})},o().createElement(O.z,{size:O.q.sm,label:p.ag.get("more.label.context",s)}))),o().createElement("div",{onClick:Ze,className:te.actions},o().createElement(W,{episodeUri:a,showUri:null!=v?v:"",sharingInfo:$,canDownload:!J||J&&X})),o().createElement("div",{className:te.playerActions},ye))}))},44887:(e,t,n)=>{n.d(t,{O:()=>N,K:()=>S});var a=n(59713),i=n.n(a),r=(n(57327),n(41539),n(2707),n(69600),n(21249),n(92222),n(26699),n(32023),n(37268),n(47941),n(82526),n(38880),n(89554),n(54747),n(49337),n(33321),n(69070),n(67294)),o=n.n(r),s=n(94184),l=n.n(s),c=n(80418),u=n(7469);const m={xsmall:"g3kBhX1E4EYEC2NFhhxG",small:"O5_0cReFdHe81E0xFAD1",medium:"H71KtIrytVayf_dFofu7",large:"SBpny8HrUTBzSjk7Vtk1",square:"CxurIfvXVb_TqGF4q8Yf",circle:"OadpZJiOaGfX6Qp4j6n5",image:"iJp40IxKg6emF6KYJ414",imageContainer:"vreceNX3ABcxyddeS83B",imagePlaceholder:"p6xU6jAgF1YQ43M1zZbV"},d="Ozitxbqs1vcOukDz3GDw",E="AeEoI6ueagbJtaHl2cRd";var S,p=n(42781),I=n(45322),_=n(68101),Z=n(28151),f=n(79458),h=n(68251),g=function(e){var t=e.title,n=e.type,a=e.className,i=function(e){switch(e){case p.p.ALBUM:return o().createElement(I.c,{className:E});case p.p.ARTIST:return o().createElement(_.a,{className:E});case p.p.SHOW:case p.p.EPISODE:return o().createElement(Z.J,{className:E});case p.p.USER:return o().createElement(f.f,{className:E});case p.p.PLAYLIST:default:return o().createElement(h.U,{className:E})}}(n);return o().createElement("div",{"aria-label":t,className:l()(d,a)},i)};function v(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function y(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?v(Object(n),!0).forEach((function(t){i()(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):v(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}!function(e){e[e.ROUNDED_CORNERS=0]="ROUNDED_CORNERS",e[e.CIRCLE=1]="CIRCLE",e[e.SQUARE=2]="SQUARE"}(S||(S={}));var N=o().memo((function(e){var t,n,a=e.loadingMode,r=void 0===a?"lazy":a,s=e.type,d=e.title,E=e.images,p=void 0===E?[]:E,I=e.shape,_=void 0===I?S.SQUARE:I,Z=e.size,f=void 0===Z?u.m$.SIZE_56:Z,h=e.className,v=e.onContextMenu,N=void 0===v?function(){}:v,C=e.onTouchStart,b=void 0===C?function(){}:C,w=e.onTouchEnd,x=void 0===w?function(){}:w,k=function(){var e=(arguments.length>0&&void 0!==arguments[0]?arguments[0]:[]).filter((function(e){return Boolean(e.width)})),t=e.filter((function(e){return e.url&&e.width&&e.width>=u.eM[u.m$.SIZE_56]})).sort((function(e,t){return e.width-t.width}));return t.length?t:e}(p),D=k.length>0?k[0].url:"",O=k.map((function(e){var t=e.url,n=e.width;return"".concat(t," ").concat(n/2,"w, ").concat(t," ").concat(n,"w")})).join(", "),A=function(){var e;return e={},i()(e,m.xsmall,u.pj.includes(f)),i()(e,m.small,u.wL.includes(f)),i()(e,m.medium,u.VZ.includes(f)),i()(e,m.large,u.B_.includes(f)),e};return o().createElement("div",{className:l()(m.imageContainer,h),onContextMenu:N,onTouchStart:b,onTouchEnd:x,style:{width:"".concat(u.eM[f],"px"),height:"".concat(u.eM[f],"px")}},o().createElement(c.E,{loading:r,src:D,alt:d,ariaHidden:!0,className:l()(m.image,y((t={},i()(t,m.roundedCorners,_===S.ROUNDED_CORNERS),i()(t,m.circle,_===S.CIRCLE),i()(t,m.square,_===S.SQUARE),t),A())),srcSet:O||void 0,testid:"entity-image"},o().createElement(g,{title:d,type:s,className:l()(y((n={},i()(n,m.roundedCorners,_===S.ROUNDED_CORNERS),i()(n,m.circle,_===S.CIRCLE),i()(n,m.square,_===S.SQUARE),n),A()))})))}))},7469:(e,t,n)=>{n.d(t,{m$:()=>i,eM:()=>s,pj:()=>l,wL:()=>c,VZ:()=>u,B_:()=>m});var a,i,r=n(59713),o=n.n(r);!function(e){e[e.SIZE_48=0]="SIZE_48",e[e.SIZE_56=1]="SIZE_56",e[e.SIZE_64=2]="SIZE_64",e[e.SIZE_72=3]="SIZE_72",e[e.SIZE_80=4]="SIZE_80",e[e.SIZE_96=5]="SIZE_96",e[e.SIZE_104=6]="SIZE_104",e[e.SIZE_112=7]="SIZE_112",e[e.SIZE_120=8]="SIZE_120",e[e.SIZE_128=9]="SIZE_128",e[e.SIZE_136=10]="SIZE_136",e[e.SIZE_144=11]="SIZE_144",e[e.SIZE_152=12]="SIZE_152",e[e.SIZE_160=13]="SIZE_160",e[e.SIZE_168=14]="SIZE_168",e[e.SIZE_176=15]="SIZE_176",e[e.SIZE_184=16]="SIZE_184",e[e.SIZE_200=17]="SIZE_200",e[e.SIZE_232=18]="SIZE_232"}(i||(i={}));var s=(a={},o()(a,i.SIZE_48,48),o()(a,i.SIZE_56,56),o()(a,i.SIZE_64,64),o()(a,i.SIZE_72,72),o()(a,i.SIZE_80,80),o()(a,i.SIZE_96,96),o()(a,i.SIZE_104,104),o()(a,i.SIZE_112,112),o()(a,i.SIZE_120,120),o()(a,i.SIZE_128,128),o()(a,i.SIZE_136,136),o()(a,i.SIZE_144,144),o()(a,i.SIZE_152,152),o()(a,i.SIZE_160,160),o()(a,i.SIZE_168,168),o()(a,i.SIZE_176,176),o()(a,i.SIZE_184,184),o()(a,i.SIZE_200,200),o()(a,i.SIZE_232,232),a),l=[i.SIZE_48,i.SIZE_56,i.SIZE_64],c=[i.SIZE_72,i.SIZE_80,i.SIZE_96,i.SIZE_104,i.SIZE_112,i.SIZE_120,i.SIZE_128],u=[i.SIZE_136,i.SIZE_144,i.SIZE_152,i.SIZE_160,i.SIZE_168,i.SIZE_176],m=[i.SIZE_184,i.SIZE_200,i.SIZE_232]},45063:(e,t,n)=>{n.d(t,{Z:()=>a});const a={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",ShowPage:"WqWFt0mTksL5L4pUOWTS",ShowContent:"d7DdhdSX1B_lzF6FLcT9",metadata:"uqOauyB7i5l_aA1Ct5eM",imageContainer:"mKVHiOws_N3sLMMHZq0Z",episodes:"aRegzSN92VRBnOaKWcoy",episodesHeader:"Q3wDjXPNY4lACLUxARrd",episodesSort:"bVv9NxcVuCEckfjjhS_g",episodesFilter:"hnwOA4WIO0QtXV868bO5",subtitle:"DvU6cwnEIZKsddh3VNjI",sectionTitle:"Eo3ux1gW87Uo72mONLUD",trailer:"_qWdC55CmfELMEV2YhuO",visibleDownloadButton:"zl5f8pJKfv0nfWMdN9rR",moreButton:"wKp6QJCIuhU4GEBCk9NY",saveButton:"Aw84eLe9FlAD8xXL2ehv"}}}]);
//# sourceMappingURL=133.js.map