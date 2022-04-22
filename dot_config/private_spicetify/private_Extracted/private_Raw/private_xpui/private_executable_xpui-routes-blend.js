"use strict";(("undefined"!=typeof self?self:global).webpackChunkopen=("undefined"!=typeof self?self:global).webpackChunkopen||[]).push([[123],{66590:(e,t,n)=>{n.r(t),n.d(t,{default:()=>x});n(47941),n(82526),n(57327),n(41539),n(38880),n(89554),n(54747),n(49337),n(33321),n(69070);var i=n(59713),r=n.n(i),l=n(67294),a=n.n(l),o=n(65858),c=n(87577),u=n(44503),s=n(70369),d=n(29255),m=n(20657),b=n(18864),v=n(15429),E=n(49961),g=n(22250),f=n(52201),p=n(60210),h=n(26610),w=n(16528),y=n(79858),A=n(326),O=n(19258),I=function(){var e=(0,w.k6)();return a().createElement("div",{className:O.Z.container},a().createElement(y.I,{iconSize:64}),a().createElement(A.l,{title:m.ag.get("blend.only-on-mobile.title"),subtitle:m.ag.get("blend.only-on-mobile.subtitle"),buttonText:m.ag.get("pwa.understood"),footnote:null,callToActionClicked:function(){return e.push("/")}}))};function _(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function T(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?_(Object(n),!0).forEach((function(t){r()(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):_(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var k={page_type:g.V3.PENDING_INVITATION,title:m.ag.get("web-player.blend.group-invite.header"),subtitle:m.ag.get("web-player.blend.duo-invite.description"),button_text:m.ag.get("web-player.blend.invite.button-title"),footnote:null,members:[],recipient:null,members_title:null,playlist_uri:null};const x=function(){var e,t=(0,p.i)(),n=(0,f.j)(),i=n.ref,r=n.breakpoint,g=(0,c.W6)(u.c$),w=(0,o.v9)(d.Gg).user;if(g===u.rS.DISABLED)return a().createElement(I,null);var y=null!=w&&w.uri?(0,v.C)(null==w?void 0:w.uri):"",A={name:(null==w?void 0:w.display_name)||"",username:y,image_url:(null===(e=(0,E.X)(null==w?void 0:w.images))||void 0===e?void 0:e.url)||null,hash:""},O=g===u.rS.TWO_USER?function(e){return T(T({},k),{},{members:[e],footnote:m.ag.get("web-player.blend.duo-invite.two-people-warning")})}(A):function(e){return T(T({},k),{},{members:[e],footnote:m.ag.get("web-player.blend.group-invite.warning")})}(A);return a().createElement(l.Suspense,{fallback:I},a().createElement(s.$,null,m.ag.get("web-player.blend.invite.page-title")),a().createElement(b.ZU.Provider,{value:r},a().createElement(h.H,{invitation:O,callToActionClicked:t,breakpointEltRef:i})))}},326:(e,t,n)=>{n.d(t,{l:()=>p});var i,r,l,a=n(59713),o=n.n(a),c=n(67294),u=n.n(c),s=n(28760),d=n(99450),m=n(18864),b=n(16367),v=n(19258),E=(i={},o()(i,m.Uo.MEDIUM,"alto"),o()(i,m.Uo.LARGE,"alto"),o()(i,m.Uo.XLARGE,"forte"),i),g=(r={},o()(r,m.Uo.LARGE,"ballad"),o()(r,m.Uo.XLARGE,"cello"),r),f=(l={},o()(l,m.Uo.LARGE,"viola"),o()(l,m.Uo.XLARGE,"viola"),l),p=function(e){var t=e.title,n=e.subtitle,i=e.body,r=e.footnote,l=e.buttonText,a=e.callToActionClicked,o=(0,m.jh)(),c=o&&E[o]||"canon",p=o&&g[o]||"mesto",h=o&&f[o]||"finale";return u().createElement(u().Fragment,null,u().createElement(s.Dy,{as:"h1",variant:c,semanticColor:"textBase",className:v.Z.title},t),u().createElement(s.Dy,{as:"h2",variant:p,semanticColor:"textSubdued",className:v.Z.subtitle},n),i,a&&u().createElement(d.D,{className:v.Z.button,colorSet:"invertedLight",onClick:a,"data-testid":b.xd},l),r&&u().createElement(s.Dy,{as:"p",variant:h,semanticColor:"textSubdued",className:v.Z.note},r))}},26610:(e,t,n)=>{n.d(t,{H:()=>y});var i=n(59713),r=n.n(i),l=(n(68309),n(67294)),a=n.n(l),o=n(11577),c=n(70369),u=n(20657),s=n(38562),d=n(18864);const m="NTT5CathoDEMjrmgfv9y",b="WmmNhmwHDNvDxInfukYO";const v=function(e){return a().createElement("div",{className:m},a().createElement("div",{className:b},a().createElement("svg",{width:e.iconSize,height:e.iconSize,fill:"currentColor",viewBox:"0 0 64 64",xmlns:"http://www.w3.org/2000/svg"},a().createElement("path",{d:"M33 31.998v-23h-2v23H8v2h23v23h2v-23h23v-2z"}))))};var E,g=n(326),f=n(16367),p=n(19258),h={name:"",username:"",image_url:null,hash:""},w=(E={},r()(E,d.Uo.MEDIUM,164),r()(E,d.Uo.LARGE,164),r()(E,d.Uo.XLARGE,270),E),y=function(e){var t,n,i,r,l=e.invitation,m=e.callToActionClicked,b=e.breakpointEltRef,E=!(null===(t=l.members)||void 0===t||!t.length),y=E&&(null===(n=l.members)||void 0===n?void 0:n[0])||l.recipient||h,A=E&&l.recipient||null,O=(0,d.jh)(),I=O&&w[O]||128,_=Math.round(.475*I);return a().createElement("div",{className:(0,o.cx)(p.Z.container,p.Z.TwoUsers),"data-testid":f.xS,ref:b},a().createElement(c.$,null,u.ag.get("blend.invite.page-title")),a().createElement("div",{className:p.Z.facepile},a().createElement(s.q,{label:y.name,images:[{url:null!==(i=y.image_url)&&void 0!==i?i:"",width:I,height:I}],width:I,userIconSize:_}),A?a().createElement(s.q,{label:A.name,images:[{url:null!==(r=A.image_url)&&void 0!==r?r:"",width:I,height:I}],width:I,userIconSize:_,piled:!0}):function(e,t){return a().createElement(s.q,{label:u.ag.get("web-player.blend.invite.button-title"),images:[],width:e,userIconSize:t,customPlaceholder:a().createElement(v,{iconSize:t}),piled:!0})}(I,_)),a().createElement(g.l,{title:l.title,subtitle:l.subtitle,footnote:l.footnote,buttonText:l.button_text,callToActionClicked:m}))}},16367:(e,t,n)=>{n.d(t,{e0:()=>i,xS:()=>r,ab:()=>l,Eh:()=>a,xd:()=>o});var i="blend-deleted-container",r="blend-two-user-container",l="blend-multi-user-container",a="blend-full-container",o="blend-cta-button"},47474:(e,t,n)=>{n.r(t),n.d(t,{default:()=>ne});var i=n(67294),r=n.n(i),l=n(16528),a=n(79858),o=n(87577),c=n(44503),u=n(20657),s=n(29634),d=n(326),m=n(59713),b=n.n(m),v=(n(74916),n(15306),n(47941),n(82526),n(57327),n(41539),n(38880),n(89554),n(54747),n(49337),n(33321),n(69070),n(69518)),E=n.n(v),g=n(70375),f=n(18864),p=n(48327),h=n(1663),w=n(22250),y=n(52201),A=n(60210),O=n(48926),I=n.n(O),_=n(87757),T=n.n(_),k=n(80624),x=n(22093);var D=n(92744),N=n(16367),R=n(19258),U=function(e){var t=e.invitation,n=e.callToActionClicked,i=e.breakpointEltRef;return r().createElement("div",{className:R.Z.container,"data-testid":N.Eh,ref:i},r().createElement(D.A,{iconSize:64}),r().createElement(d.l,{title:t.title,subtitle:t.subtitle,buttonText:t.button_text,footnote:null,callToActionClicked:n}))},L=n(70369),P=(n(68309),n(21249),n(94184)),S=n.n(P),M=n(28760),j=n(38562),C=n(18261),Z=n(43480),Y=n(67892);const B="HKAYWYmxd5Ie8WSi0a4y",V="i52u_T3b50wraodIaORk",G="xakiNVMlUf6geF67FEgy",z="IRhTesoeIiwswlly0Dvg",W="LNJzE17iskXWmfKAzY4U",X="qzBr7X7cdLUhWdk0r8lL";var q=function(e){var t=e.uri,n=e.imageUrl,i=e.name;return r().createElement("li",null,r().createElement(C._,{menu:r().createElement(Z.I,{uri:t})},r().createElement(Y.r,{to:t},r().createElement("div",{className:z},r().createElement(j.q,{images:[{url:n,width:null,height:null}],label:i,width:32,userIconSize:24,className:W}),r().createElement(M.Dy,{variant:"violaBold",className:"standalone-ellipsis-one-line",semanticColor:"textBase"},i)))))},H=function(e){var t=e.members,n=e.headingText,i=e.className;return r().createElement("div",{className:S()(B,i)},r().createElement("div",null,r().createElement(M.Dy,{as:"h4",variant:"minuetBold",semanticColor:"textSubdued",className:V},n)),r().createElement("ul",{className:G},t&&t.map((function(e){return r().createElement(q,{imageUrl:e.image_url||"",name:e.name,uri:E().profileURI(e.username).toURI(),key:e.username})}))),r().createElement("div",{className:X}))},J=function(e){var t=e.invitation,n=e.callToActionClicked,i=e.breakpointEltRef,l=t.members||[],a=r().createElement("div",{className:R.Z.userListContainer,"data-testid":N.ab},r().createElement(H,{className:R.Z.userList,headingText:t.members_title,members:l}));return r().createElement("div",{className:R.Z.container,ref:i},r().createElement(L.$,null,u.ag.get("blend.join.title")),r().createElement(d.l,{title:t.title,subtitle:t.subtitle,footnote:t.footnote,body:a,buttonText:t.button_text,callToActionClicked:n}))},K=n(26610);function F(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function $(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?F(Object(n),!0).forEach((function(t){b()(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):F(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}var Q=function(e){var t,n,i=e.invitationId,a=(0,l.k6)(),s=(0,o.W6)(c.c$),m=(0,p.J)(w.oN,[i]),b=m.data,v=m.error,O=m.loading,_=(0,A.i)(),D=function(e){var t=(0,x.k)(),n=(0,l.k6)();return I()(T().mark((function i(){var r,l;return T().wrap((function(i){for(;;)switch(i.prev=i.next){case 0:return i.prev=0,i.next=3,(0,w.nW)(k.b.getInstance(),e);case 3:if(r=i.sent,l=E().from(null==r?void 0:r.body.playlist_uri).toURLPath(!0)){i.next=7;break}throw new Error("unable to join");case 7:n.replace(l),i.next=13;break;case 10:i.prev=10,i.t0=i.catch(0),t(u.ag.get("error.request-playlist-failure"));case 13:case"end":return i.stop()}}),i,null,[[0,10]])})))}(i),L=(0,y.j)(),P=L.ref,S=L.breakpoint,M=null===b||!b.body;if(M||O||v)return r().createElement(h.h,{timeoutInMs:1e3,hasError:!!v||!O&&M,errorMessage:u.ag.get("error.generic")});var j=null===(t=E().from(null==b?void 0:b.body.playlist_uri))||void 0===t?void 0:t.toURLPath(!0),C=(null==b||null===(n=b.body.members)||void 0===n?void 0:n.length)||0,Z=s===c.rS.TWO_USER;switch(null==b?void 0:b.body.page_type){case w.V3.DELETED:return r().createElement(f.ZU.Provider,{value:S},r().createElement("div",{className:R.Z.container,ref:P,"data-testid":N.e0},r().createElement(g.t,{iconSize:64}),r().createElement(d.l,{title:b.body.title,subtitle:b.body.subtitle,buttonText:b.body.button_text,footnote:b.body.footnote,callToActionClicked:_})));case w.V3.ALREADY_JOINED:return j&&a.replace(j),r().createElement(h.h,{hasError:!1,errorMessage:u.ag.get("error.request-playlist-failure")});case w.V3.READY_TO_JOIN_EMPTY_BLEND:return r().createElement(f.ZU.Provider,{value:S},r().createElement(K.H,{invitation:b.body,breakpointEltRef:P,callToActionClicked:D}));case w.V3.READY_TO_JOIN_ALREADY_CREATED_BLEND:return Z&&C>=2?r().createElement(f.ZU.Provider,{value:S},r().createElement(U,{invitation:$($({},b.body),{},{title:u.ag.get("blend.link-invialid.header"),subtitle:u.ag.get("blend.link-invalid.subtitle"),button_text:u.ag.get("blend.invite.button-title")}),callToActionClicked:_,breakpointEltRef:P})):r().createElement(f.ZU.Provider,{value:S},r().createElement(J,{invitation:b.body,callToActionClicked:D,breakpointEltRef:P}));case w.V3.MAX_MEMBERS:return r().createElement(f.ZU.Provider,{value:S},r().createElement(U,{invitation:b.body,callToActionClicked:_,breakpointEltRef:P}));case w.V3.PENDING_INVITATION:return r().createElement(f.ZU.Provider,{value:S},r().createElement(K.H,{invitation:b.body,callToActionClicked:_,breakpointEltRef:P}));default:return r().createElement(h.h,{timeoutInMs:1e3,hasError:!0,errorMessage:u.ag.get("error.generic")})}},ee=function(){var e=(0,l.k6)();return r().createElement("div",{className:R.Z.container},r().createElement(a.I,{iconSize:64}),r().createElement(d.l,{title:u.ag.get("blend.only-on-mobile.title"),subtitle:u.ag.get("blend.only-on-mobile.subtitle"),buttonText:u.ag.get("pwa.understood"),footnote:null,callToActionClicked:function(){return e.push("/")}}))},te=function(e){var t=e.invitationId;return(0,o.W6)(c.c$)===c.rS.DISABLED?r().createElement(ee,null):r().createElement(s.n,{fallback:ee},r().createElement(Q,{invitationId:t}))};const ne=r().memo((function(){return r().createElement(te,(0,l.UO)())}))},22250:(e,t,n)=>{n.d(t,{V3:()=>i,oN:()=>l,nW:()=>a,Ag:()=>o});var i,r=n(16516);!function(e){e.PENDING_INVITATION="PENDING_INVITATION",e.READY_TO_JOIN_EMPTY_BLEND="READY_TO_JOIN_EMPTY_BLEND",e.READY_TO_JOIN_ALREADY_CREATED_BLEND="READY_TO_JOIN_ALREADY_CREATED_BLEND",e.MAX_MEMBERS="MAX_MEMBERS",e.ALREADY_JOINED="ALREADY_JOINED",e.DELETED="DELETED"}(i||(i={}));var l=function(e,t){return e.build().withHost(r.cM).withPath("/v3/view-invitation/".concat(encodeURIComponent(t))).withEndpointIdentifier("v3/view-invitation/{invitationId}").withLocale(e.locale).send()},a=function(e,t){return e.build().withHost(r.cM).withMethod("PUT").withPath("/v2/join/".concat(encodeURIComponent(t))).withEndpointIdentifier("join/{invitationId}").send()},o=function(e){return e.build().withHost(r.cM).withMethod("POST").withPath("/v1/generate").withEndpointIdentifier("v1/generate").send()}},52201:(e,t,n)=>{n.d(t,{j:()=>o});var i=n(59713),r=n.n(i),l=n(82144),a=n(53052),o=function(){var e;return(0,a.D)((e={},r()(e,l.U.SMALL,536),r()(e,l.U.MEDIUM,792),r()(e,l.U.LARGE,1048),r()(e,l.U.XLARGE,1688),e))}},60210:(e,t,n)=>{n.d(t,{i:()=>v});var i=n(48926),r=n.n(i),l=n(87757),a=n.n(l),o=n(65858),c=n(20657),u=n(80624),s=n(25853),d=n(29255),m=n(22250),b=n(22093);function v(){var e=(0,o.v9)(d.Gg).user,t=(0,b.k)();return r()(a().mark((function n(){var i,r,l,o,d;return a().wrap((function(n){for(;;)switch(n.prev=n.next){case 0:return n.prev=0,n.next=3,(0,m.Ag)(u.b.getInstance());case 3:if(o=n.sent,null===(i=o.body)||void 0===i?void 0:i.invite){n.next=7;break}throw new Error("unable to generate invite link");case 7:d=null!=e&&e.display_name?c.ag.get("blend.invite.body-with-name",e.display_name,null===(r=o.body)||void 0===r?void 0:r.invite):c.ag.get("blend.invite.body-without-name",null===(l=o.body)||void 0===l?void 0:l.invite),(0,s.v)(d),t(c.ag.get("feedback.link-copied")),n.next=15;break;case 12:n.prev=12,n.t0=n.catch(0),t(c.ag.get("error.generic"));case 15:case"end":return n.stop()}}),n,null,[[0,12]])})))}},22093:(e,t,n)=>{n.d(t,{k:()=>a});var i=n(65858),r=n(8475),l=n(63826),a=function(){var e=(0,i.I0)();return function(t){return(0,l.T)({hide:function(){return e((0,r.Xe)())},show:function(){return e((0,r.TB)(t))}})}}},19258:(e,t,n)=>{n.d(t,{Z:()=>i});const i={xs:"(min-width: 0px)",xsOnly:"(min-width: 0px) and (max-width: 767px)",sm:"(min-width: 768px)",smOnly:"(min-width: 768px) and (max-width: 1023px)",md:"(min-width: 1024px)",mdOnly:"(min-width: 1024px) and (max-width: 1279px)",lg:"(min-width: 1280px)",lgOnly:"(min-width: 1280px) and (max-width: 1919px)",xl:"(min-width: 1920px)",container:"yMoj4jXSudxZ6BkKxV2E",TwoUsers:"IDgUCqAbkRah6OFywv1q",subtitle:"qmKxO5qV4XmVYfpFpaDA",facepile:"nWMdWl40O8K7HQT8Tagc",title:"csRAeNipsu1camQTMiIU",button:"nxFBywAeAI8Zk2fav3Yj",userList:"lxPLQIPb1VSV3VL18Ke3",userListContainer:"BzMKhmywgyIt6IUjcTGW",note:"DSdKNusLgsMX_iicYCU2"}}}]);
//# sourceMappingURL=xpui-routes-blend.js.map