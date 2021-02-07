-- BASE64
-- http://lua-users.org/wiki/BaseSixtyFour
function base64_encode(a)local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'return(a:gsub('.',function(c)local d,e='',c:byte()for f=8,1,-1 do d=d..(e%2^f-e%2^(f-1)>0 and'1'or'0')end;return d end)..'0000'):gsub('%d%d%d?%d?%d?%d?',function(c)if#c<6 then return''end;local g=0;for f=1,6 do g=g+(c:sub(f,f)=='1'and 2^(6-f)or 0)end;return b:sub(g+1,g+1)end)..({'','==','='})[#a%3+1]end


-- AES
-- https://gist.github.com/SquidDev/86925e07cbabd70773e53d781bd8b2fe
local function a(b)local c=setmetatable({},{__index=_ENV or getfenv()})if setfenv then setfenv(b,c)end;return b(c)or c end;local bit=a(function(_ENV,...)local d=math.floor;local e,f;f=function(g,h)return d(g%4294967296/2^h)end;e=function(g,h)return g*2^h%4294967296 end;return{bnot=bit.bnot,band=bit.band,bor=bit.bor,bxor=bit.bxor,rshift=f,lshift=e}end)gf=a(function(_ENV,...)local i=bit.bxor;local e=bit.lshift;local j=0x100;local k=0xff;local l=0x11b;local m={}local n={}local function o(p,q)return i(p,q)end;local function r(p,q)return i(p,q)end;local function s(t)if t==1 then return 1 end;local u=k-n[t]return m[u]end;local function v(p,q)if p==0 or q==0 then return 0 end;local u=n[p]+n[q]if u>=k then u=u-k end;return m[u]end;local function x(p,q)if p==0 then return 0 end;local u=n[p]-n[q]if u<0 then u=u+k end;return m[u]end;local function y()for z=1,j do print("log(",z-1,")=",n[z-1])end end;local function A()for z=1,j do print("exp(",z-1,")=",m[z-1])end end;local function B()local g=1;for z=0,k-1 do m[z]=g;n[g]=z;g=i(e(g,1),g)if g>k then g=r(g,l)end end end;B()return{add=o,sub=r,invert=s,mul=v,div=dib,printLog=y,printExp=A}end)util=a(function(_ENV,...)local i=bit.bxor;local f=bit.rshift;local C=bit.band;local e=bit.lshift;local D;local function E(byte)byte=i(byte,f(byte,4))byte=i(byte,f(byte,2))byte=i(byte,f(byte,1))return C(byte,1)end;local function F(G,H)if H==0 then return C(G,0xff)else return C(f(G,H*8),0xff)end end;local function I(G,H)if H==0 then return C(G,0xff)else return e(C(G,0xff),H*8)end end;local function J(K,L,j)local M={}for z=0,j-1 do M[z+1]=I(K[L+z*4],3)+I(K[L+z*4+1],2)+I(K[L+z*4+2],1)+I(K[L+z*4+3],0)if j%10000==0 then D()end end;return M end;local function N(M,O,P,j)j=j or#M;for z=0,j-1 do for Q=0,3 do O[P+z*4+3-Q]=F(M[z+1],Q)end;if j%10000==0 then D()end end;return O end;local function R(K)local S=""for z,byte in ipairs(K)do S=S..string.format("%02x ",byte)end;return S end;local function T(K)local U={}for z=1,#K,2 do U[#U+1]=tonumber(K:sub(z,z+1),16)end;return U end;local function V(W)local type=type(W)if type=="number"then return string.format("%08x",W)elseif type=="table"then return R(W)elseif type=="string"then local K={string.byte(W,1,#W)}return R(K)else return W end end;local function X(Y,W)local Z=#W;Y:add("===== padByteString ==== ")Y:add("data "..W)Y:add("dataLength "..Z)local _=math.random(0,255)local a0=math.random(0,255)local a1=string.char(_,a0,_,a0,F(Z,3),F(Z,2),F(Z,1),F(Z,0))Y:add("prefix "..a1)Y:add("data "..W)W=a1 ..W;Y:add("combined data "..W)local a2=math.ceil(#W/16)*16-#W;local a3=""for z=1,a2 do a3=a3 ..string.char(math.random(0,255))end;return W..a3 end;local function a4(W)local a5={string.byte(W,1,4)}if a5[1]==a5[3]and a5[2]==a5[4]then return true end;return false end;local function a6(W)if not a4(W)then return nil end;local Z=I(string.byte(W,5),3)+I(string.byte(W,6),2)+I(string.byte(W,7),1)+I(string.byte(W,8),0)return string.sub(W,9,8+Z)end;local function a7(W,a8)for z=1,16 do W[z]=i(W[z],a8[z])end end;local function a9(W)local z=16;while true do local aa=W[z]+1;if aa>=256 then W[z]=aa-256;z=(z-2)%16+1 else W[z]=aa;break end end end;local ab,ac,ad=os.queueEvent,coroutine.yield,os.time;local ae=ad()local function D()local af=ad()end;local function ag(K)local ah,a5,ai,aj=string.char,math.random,D,table.insert;local result={}for z=1,K do aj(result,a5(0,255))if z%10240==0 then ai()end end;return result end;local function ak(K)local ah,a5,ai,aj=string.char,math.random,D,table.insert;local result={}for z=1,K do aj(result,ah(a5(0,255)))if z%10240==0 then ai()end end;return table.concat(result)end;return{byteParity=E,getByte=F,putByte=I,bytesToInts=J,intsToBytes=N,bytesToHex=R,hexToBytes=T,toHexString=V,padByteString=X,properlyDecrypted=a4,unpadByteString=a6,xorIV=a7,increment=a9,sleepCheckIn=D,getRandomData=ag,getRandomString=ak}end)aes=a(function(_ENV,...)local I=util.putByte;local F=util.getByte;local al='rounds'local am="type"local an=1;local ao=2;local ap={}local aq={}local ar={}local as={}local at={}local au={}local av={}local aw={}local ax={}local ay={}local az={0x01000000,0x02000000,0x04000000,0x08000000,0x10000000,0x20000000,0x40000000,0x80000000,0x1b000000,0x36000000,0x6c000000,0xd8000000,0xab000000,0x4d000000,0x9a000000,0x2f000000}local function aA(byte)mask=0xf8;result=0;for z=1,8 do result=bit.lshift(result,1)parity=util.byteParity(bit.band(byte,mask))result=result+parity;lastbit=bit.band(mask,1)mask=bit.band(bit.rshift(mask,1),0xff)if lastbit~=0 then mask=bit.bor(mask,0x80)else mask=bit.band(mask,0x7f)end end;return bit.bxor(result,0x63)end;local function aB()for z=0,255 do if z~=0 then inverse=gf.invert(z)else inverse=z end;mapped=aA(inverse)ap[z]=mapped;aq[mapped]=z end end;local function aC()for aD=0,255 do byte=ap[aD]ar[aD]=I(gf.mul(0x03,byte),0)+I(byte,1)+I(byte,2)+I(gf.mul(0x02,byte),3)as[aD]=I(byte,0)+I(byte,1)+I(gf.mul(0x02,byte),2)+I(gf.mul(0x03,byte),3)at[aD]=I(byte,0)+I(gf.mul(0x02,byte),1)+I(gf.mul(0x03,byte),2)+I(byte,3)au[aD]=I(gf.mul(0x02,byte),0)+I(gf.mul(0x03,byte),1)+I(byte,2)+I(byte,3)end end;local function aE()for aD=0,255 do byte=aq[aD]av[aD]=I(gf.mul(0x0b,byte),0)+I(gf.mul(0x0d,byte),1)+I(gf.mul(0x09,byte),2)+I(gf.mul(0x0e,byte),3)aw[aD]=I(gf.mul(0x0d,byte),0)+I(gf.mul(0x09,byte),1)+I(gf.mul(0x0e,byte),2)+I(gf.mul(0x0b,byte),3)ax[aD]=I(gf.mul(0x09,byte),0)+I(gf.mul(0x0e,byte),1)+I(gf.mul(0x0b,byte),2)+I(gf.mul(0x0d,byte),3)ay[aD]=I(gf.mul(0x0e,byte),0)+I(gf.mul(0x0b,byte),1)+I(gf.mul(0x0d,byte),2)+I(gf.mul(0x09,byte),3)end end;local function aF(aG)local aH=bit.band(aG,0xff000000)return bit.lshift(aG,8)+bit.rshift(aH,24)end;local function aI(aG)return I(ap[F(aG,0)],0)+I(ap[F(aG,1)],1)+I(ap[F(aG,2)],2)+I(ap[F(aG,3)],3)end;local function aJ(aK)local aL={}local aM=math.floor(#aK/4)if aM~=4 and aM~=6 and aM~=8 or aM*4~=#aK then error("Invalid key size: "..tostring(aM))return nil end;aL[al]=aM+6;aL[am]=an;for z=0,aM-1 do aL[z]=I(aK[z*4+1],3)+I(aK[z*4+2],2)+I(aK[z*4+3],1)+I(aK[z*4+4],0)end;for z=aM,(aL[al]+1)*4-1 do local aH=aL[z-1]if z%aM==0 then aH=aF(aH)aH=aI(aH)local H=math.floor(z/aM)aH=bit.bxor(aH,az[H])elseif aM>6 and z%aM==4 then aH=aI(aH)end;aL[z]=bit.bxor(aL[z-aM],aH)end;return aL end;local function aN(aG)local aO=F(aG,3)local aP=F(aG,2)local aQ=F(aG,1)local aR=F(aG,0)return I(gf.add(gf.add(gf.add(gf.mul(0x0b,aP),gf.mul(0x0d,aQ)),gf.mul(0x09,aR)),gf.mul(0x0e,aO)),3)+I(gf.add(gf.add(gf.add(gf.mul(0x0b,aQ),gf.mul(0x0d,aR)),gf.mul(0x09,aO)),gf.mul(0x0e,aP)),2)+I(gf.add(gf.add(gf.add(gf.mul(0x0b,aR),gf.mul(0x0d,aO)),gf.mul(0x09,aP)),gf.mul(0x0e,aQ)),1)+I(gf.add(gf.add(gf.add(gf.mul(0x0b,aO),gf.mul(0x0d,aP)),gf.mul(0x09,aQ)),gf.mul(0x0e,aR)),0)end;local function aS(aG)local aO=F(aG,3)local aP=F(aG,2)local aQ=F(aG,1)local aR=F(aG,0)local aT=bit.bxor(aR,aQ)local aU=bit.bxor(aP,aO)local aV=bit.bxor(aT,aU)aV=bit.bxor(aV,gf.mul(0x08,aV))w=bit.bxor(aV,gf.mul(0x04,bit.bxor(aQ,aO)))aV=bit.bxor(aV,gf.mul(0x04,bit.bxor(aR,aP)))return I(bit.bxor(bit.bxor(aR,aV),gf.mul(0x02,bit.bxor(aO,aR))),0)+I(bit.bxor(bit.bxor(aQ,w),gf.mul(0x02,aT)),1)+I(bit.bxor(bit.bxor(aP,aV),gf.mul(0x02,bit.bxor(aO,aR))),2)+I(bit.bxor(bit.bxor(aO,w),gf.mul(0x02,aU)),3)end;local function aW(aK)local aL=aJ(aK)if aL==nil then return nil end;aL[am]=ao;for z=4,(aL[al]+1)*4-5 do aL[z]=aN(aL[z])end;return aL end;local function aX(aY,aK,aZ)for z=0,3 do aY[z+1]=bit.bxor(aY[z+1],aK[aZ*4+z])end end;local function a_(b0,b1)b1[1]=bit.bxor(bit.bxor(bit.bxor(ar[F(b0[1],3)],as[F(b0[2],2)]),at[F(b0[3],1)]),au[F(b0[4],0)])b1[2]=bit.bxor(bit.bxor(bit.bxor(ar[F(b0[2],3)],as[F(b0[3],2)]),at[F(b0[4],1)]),au[F(b0[1],0)])b1[3]=bit.bxor(bit.bxor(bit.bxor(ar[F(b0[3],3)],as[F(b0[4],2)]),at[F(b0[1],1)]),au[F(b0[2],0)])b1[4]=bit.bxor(bit.bxor(bit.bxor(ar[F(b0[4],3)],as[F(b0[1],2)]),at[F(b0[2],1)]),au[F(b0[3],0)])end;local function b2(b0,b1)b1[1]=I(ap[F(b0[1],3)],3)+I(ap[F(b0[2],2)],2)+I(ap[F(b0[3],1)],1)+I(ap[F(b0[4],0)],0)b1[2]=I(ap[F(b0[2],3)],3)+I(ap[F(b0[3],2)],2)+I(ap[F(b0[4],1)],1)+I(ap[F(b0[1],0)],0)b1[3]=I(ap[F(b0[3],3)],3)+I(ap[F(b0[4],2)],2)+I(ap[F(b0[1],1)],1)+I(ap[F(b0[2],0)],0)b1[4]=I(ap[F(b0[4],3)],3)+I(ap[F(b0[1],2)],2)+I(ap[F(b0[2],1)],1)+I(ap[F(b0[3],0)],0)end;local function b3(b0,b1)b1[1]=bit.bxor(bit.bxor(bit.bxor(av[F(b0[1],3)],aw[F(b0[4],2)]),ax[F(b0[3],1)]),ay[F(b0[2],0)])b1[2]=bit.bxor(bit.bxor(bit.bxor(av[F(b0[2],3)],aw[F(b0[1],2)]),ax[F(b0[4],1)]),ay[F(b0[3],0)])b1[3]=bit.bxor(bit.bxor(bit.bxor(av[F(b0[3],3)],aw[F(b0[2],2)]),ax[F(b0[1],1)]),ay[F(b0[4],0)])b1[4]=bit.bxor(bit.bxor(bit.bxor(av[F(b0[4],3)],aw[F(b0[3],2)]),ax[F(b0[2],1)]),ay[F(b0[1],0)])end;local function b4(b0,b1)b1[1]=I(aq[F(b0[1],3)],3)+I(aq[F(b0[4],2)],2)+I(aq[F(b0[3],1)],1)+I(aq[F(b0[2],0)],0)b1[2]=I(aq[F(b0[2],3)],3)+I(aq[F(b0[1],2)],2)+I(aq[F(b0[4],1)],1)+I(aq[F(b0[3],0)],0)b1[3]=I(aq[F(b0[3],3)],3)+I(aq[F(b0[2],2)],2)+I(aq[F(b0[1],1)],1)+I(aq[F(b0[4],0)],0)b1[4]=I(aq[F(b0[4],3)],3)+I(aq[F(b0[3],2)],2)+I(aq[F(b0[2],1)],1)+I(aq[F(b0[1],0)],0)end;local function encrypt(aK,b5,b6,O,P)b6=b6 or 1;O=O or{}P=P or 1;local aY={}local b7={}if aK[am]~=an then error("No encryption key: "..tostring(aK[am])..", expected "..an)return end;aY=util.bytesToInts(b5,b6,4)aX(aY,aK,0)local aZ=1;while aZ<aK[al]-1 do a_(aY,b7)aX(b7,aK,aZ)aZ=aZ+1;a_(b7,aY)aX(aY,aK,aZ)aZ=aZ+1 end;a_(aY,b7)aX(b7,aK,aZ)aZ=aZ+1;b2(b7,aY)aX(aY,aK,aZ)util.sleepCheckIn()return util.intsToBytes(aY,O,P)end;local function decrypt(aK,b5,b6,O,P)b6=b6 or 1;O=O or{}P=P or 1;local aY={}local b7={}if aK[am]~=ao then error("No decryption key: "..tostring(aK[am]))return end;aY=util.bytesToInts(b5,b6,4)aX(aY,aK,aK[al])local aZ=aK[al]-1;while aZ>2 do b3(aY,b7)aX(b7,aK,aZ)aZ=aZ-1;b3(b7,aY)aX(aY,aK,aZ)aZ=aZ-1 end;b3(aY,b7)aX(b7,aK,aZ)aZ=aZ-1;b4(b7,aY)aX(aY,aK,aZ)util.sleepCheckIn()return util.intsToBytes(aY,O,P)end;aB()aC()aE()return{ROUNDS=al,KEY_TYPE=am,ENCRYPTION_KEY=an,DECRYPTION_KEY=ao,expandEncryptionKey=aJ,expandDecryptionKey=aW,encrypt=encrypt,decrypt=decrypt}end)local b8=a(function(_ENV,...)local function b9()return{}end;local function ba(bb,bc)table.insert(bb,bc)end;local function bd(bb)return table.concat(bb)end;return{new=b9,addString=ba,toString=bd}end)ciphermode=a(function(_ENV,...)local be={}local a5=math.random;function be.encryptString(Y,aK,W,bf,a8)if a8 then local bg={}for z=1,16 do bg[z]=a8[z]end;a8=bg else a8={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}end;local bh=aes.expandEncryptionKey(aK)local bi=b8.new()for z=1,#W/16 do local bj=(z-1)*16+1;local bk={string.byte(W,bj,bj+15)}a8=bf(bh,bk,a8)b8.addString(bi,string.char(unpack(bk)))end;return b8.toString(bi)end;function be.encryptECB(bh,bk,a8)aes.encrypt(bh,bk,1,bk,1)end;function be.encryptCBC(bh,bk,a8)util.xorIV(bk,a8)aes.encrypt(bh,bk,1,bk,1)return bk end;function be.encryptOFB(bh,bk,a8)aes.encrypt(bh,a8,1,a8,1)util.xorIV(bk,a8)return a8 end;function be.encryptCFB(bh,bk,a8)aes.encrypt(bh,a8,1,a8,1)util.xorIV(bk,a8)return bk end;function be.encryptCTR(bh,bk,a8)local bl={}for Q=1,16 do bl[Q]=a8[Q]end;aes.encrypt(bh,a8,1,a8,1)util.xorIV(bk,a8)util.increment(bl)return bl end;function be.decryptString(Y,aK,W,bf,a8)if a8 then local bg={}for z=1,16 do bg[z]=a8[z]end;a8=bg else a8={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}end;local bh;if bf==be.decryptOFB or bf==be.decryptCFB or bf==be.decryptCTR then bh=aes.expandEncryptionKey(aK)else bh=aes.expandDecryptionKey(aK)end;local bm=b8.new()for z=1,#W/16 do local bj=(z-1)*16+1;local bk={string.byte(W,bj,bj+15)}a8=bf(bh,bk,a8)b8.addString(bm,string.char(unpack(bk)))end;return b8.toString(bm)end;function be.decryptECB(bh,bk,a8)aes.decrypt(bh,bk,1,bk,1)return a8 end;function be.decryptCBC(bh,bk,a8)local bl={}for Q=1,16 do bl[Q]=bk[Q]end;aes.decrypt(bh,bk,1,bk,1)util.xorIV(bk,a8)return bl end;function be.decryptOFB(bh,bk,a8)aes.encrypt(bh,a8,1,a8,1)util.xorIV(bk,a8)return a8 end;function be.decryptCFB(bh,bk,a8)local bl={}for Q=1,16 do bl[Q]=bk[Q]end;aes.encrypt(bh,a8,1,a8,1)util.xorIV(bk,a8)return bl end;be.decryptCTR=be.encryptCTR;return be end)AES128=16;AES192=24;AES256=32;ECBMODE=1;CBCMODE=2;OFBMODE=3;CFBMODE=4;CTRMODE=4;function pwToKey(Y,bn,bo,a8)local bp=bo;if bo==AES192 then bp=32 end;if bp>#bn then local bq=""for z=1,bp-#bn do bq=bq..string.char(0)end;bn=bn..bq else bn=string.sub(bn,1,bp)end;local br={string.byte(bn,1,#bn)}bn=ciphermode.encryptString(Y,br,bn,ciphermode.encryptCBC,a8)bn=base64_encode(bn)bn=string.sub(bn,1,bo)return{string.byte(bn,1,#bn)}end;function encrypt(Y,bn,W,bo,bs,a8)local bs=bs or CBCMODE;local bo=bo or AES128;local aK=pwToKey(Y,bn,bo,a8)local bt=W;if bs==ECBMODE then return ciphermode.encryptString(aK,bt,ciphermode.encryptECB,a8)elseif bs==CBCMODE then return ciphermode.encryptString(Y,aK,bt,ciphermode.encryptCBC,a8)elseif bs==OFBMODE then return ciphermode.encryptString(aK,bt,ciphermode.encryptOFB,a8)elseif bs==CFBMODE then return ciphermode.encryptString(aK,bt,ciphermode.encryptCFB,a8)elseif bs==CTRMODE then return ciphermode.encryptString(aK,bt,ciphermode.encryptCTR,a8)else error("Unknown mode",2)end end;function decrypt(Y,bn,W,bo,bs,a8)local bs=bs or CBCMODE;local bo=bo or AES128;local aK=pwToKey(Y,bn,bo,a8)local bu;if bs==ECBMODE then bu=ciphermode.decryptString(aK,W,ciphermode.decryptECB,a8)elseif bs==CBCMODE then bu=ciphermode.decryptString(Y,aK,W,ciphermode.decryptCBC,a8)elseif bs==OFBMODE then bu=ciphermode.decryptString(aK,W,ciphermode.decryptOFB,a8)elseif bs==CFBMODE then bu=ciphermode.decryptString(aK,W,ciphermode.decryptCFB,a8)elseif bs==CTRMODE then bu=ciphermode.decryptString(aK,W,ciphermode.decryptCTR,a8)else error("Unknown mode",2)end;return bu end


-- UTF8
-- https://gist.github.com/diegopacheco/a140743598aab862cab15ec5905b651b
function utf8_from(a)local b={}for c,d in ipairs(a)do local e=d<0 and 0xff+d+1 or d;table.insert(b,string.char(e))end;return table.concat(b)end


-- Hex Helpers
-- https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file
function string.fromhex(a)return a:gsub('..',function(b)return string.char(tonumber(b,16))end)end;
function string.tohex(a)return a:gsub('.',function(c)return string.format('%02X',string.byte(c))end)end




local global_flow_settings =
{
	hide_nulls = true,
	key     = "",
	iv		= "",
}



-- JSON (mini dissector)

local json_dis = Dissector.get("json")

J_FIELD_TYPE_STRING = 0
J_FIELD_TYPE_NUM = 1
J_FIELD_TYPE_IP = 2
J_FIELD_TYPE_OBJ = 3
J_FIELD_TYPE_BOOL = 4
J_FIELD_TYPE_LIST = 5

function get_char(str, indx)
	return string.sub(str,indx,indx)
end

function dissect_json_field_list(subtree, tvb, text, jsonFieldName, proto_field, hide_value)
	local indx = 0
	local matchLength = 0
	local matchedText = ""
	local is_obj_in_string = false

	indx = string.find(text, jsonFieldName, 1, true)
	if(indx == nil) then
		-- Not found in this packet
		return nil
	end
	
	indx = indx + #jsonFieldName -- Skipping field name
	indx = indx + 2 -- Skipping qoutes and colon
	
	-- Check for 'null' instead of actual object.
	-- If it's not null matchedText will change later
	matchedText = string.sub(text, indx, indx + 3);
	if matchedText ~= 'null' then
		-- Value isn't null, collecting characters between first and last '[' , ']'
		-- Looking for first '['
		totalLen = #text
		while(get_char(text,indx) ~= '[')
		do
			indx = indx + 1
			if(indx == totalLen) then
				-- TODO:
				crash__this__now()
			end
		end
		
		opened_scopes = 1
		-- Starting with endOffset set to 'index' since the first line in the loop
		-- makes us check the letter after it so we don't count the scope twice
		endOffset = indx
		while(opened_scopes > 0 and endOffset < totalLen)
		do
			endOffset = endOffset + 1
			local c = get_char(text, endOffset)
			if(c == '[') then
				opened_scopes = opened_scopes + 1
			elseif(c == ']') then
				opened_scopes = opened_scopes - 1
			end
		end
		matchedText = string.sub(text, indx, endOffset);
	end
	
	-- Saving match length for TVB highlight
	matchLength = #matchedText;
		
	-- Changing indx to be 0-based (lua strings start at 1, wireshark TVBs start at 0)
	indx = indx - 1;

	return indx, matchLength, matchedText
end

function dissect_json_field_object(subtree, tvb, text, jsonFieldName, proto_field, hide_value)
	local indx = 0
	local matchLength = 0
	local matchedText = ""
	local is_obj_in_string = false

	-- Handling a JSON field which contains an inner JSON object

	indx = string.find(text, jsonFieldName, 1, true)
	if(indx == nil) then
		-- Not found in this packet
		return nil
	end
	
	indx = indx + #jsonFieldName -- Skipping field name
	indx = indx + 2 -- Skipping qoutes and colon
	
	-- Check for 'null' instead of actual object.
	-- If it's not null matchedText will change later
	matchedText = string.sub(text, indx, indx + 3);
	if matchedText ~= 'null' then
		-- Value isn't null, collecting characters between first and last '{' , '}'
		-- Looking for first '{'
		-- If we see qoutes on the way, remember that we have an object within a string
		totalLen = #text
		while(get_char(text,indx) ~= '{')
		do
			if get_char(text,indx) == '"' then
				is_obj_in_string = true
			end
			indx = indx + 1
			if(indx == totalLen) then
				-- TODO:
				crash__this__now()
			end
		end
		
		opened_scopes = 1
		-- Starting with endOffset set to 'index' since the first line in the loop
		-- makes us check the letter after it so we don't count the scope twice
		endOffset = indx
		while(opened_scopes > 0 and endOffset < totalLen)
		do
			endOffset = endOffset + 1
			local c = get_char(text, endOffset)
			if(c == '{') then
				opened_scopes = opened_scopes + 1
			elseif(c == '}') then
				opened_scopes = opened_scopes - 1
			end
		end
		endOffset = endOffset + 1
		
		matchedText = string.sub(text, indx, endOffset);
	end
	
	-- Saving match length for TVB highlight
	matchLength = #matchedText;
		
	-- Changing indx to be 0-based (lua strings start at 1, wireshark TVBs start at 0)
	indx = indx - 1;

	
	if is_obj_in_string then
		-- Unescape string because the object it was found within a string
		local unescaped_text = ""
		j = 0
		while(j < #matchedText)
		do
			if(get_char(matchedText,j) ~= '\\') then
				unescaped_text = unescaped_text .. get_char(matchedText,j);
			end
			j = j + 1
		end
		matchedText = unescaped_text
	else
	end

	return indx, matchLength, matchedText
end

-- Parameters
-- subtree: protocol tree or tree item
-- tvb: buffer
-- text: text in the buffer as a lua string
-- jsonFieldName: string of field to search
-- proto_field: the field to add to the tree once we found the value
-- j_field_type: type of the field we are searching (J_FIELD_TYPE_STRING, J_FIELD_TYPE_NUM, J_FIELD_TYPE_IP, ...)
-- hide_value: Wether to hide the value in the tree item we create or not (helpful if the data is another json and will be parsed further anyway)
function dissect_json_field(subtree, tvb, text, jsonFieldName, proto_field, j_field_type, hide_value)
	local indx = 0
	local matchLength = 0
	local matchedText = ""
	local value_is_null = false

	-- Checking for list fields
	if (j_field_type == J_FIELD_TYPE_LIST) then
		indx, matchLength, matchedText = dissect_json_field_list(subtree, tvb, text, jsonFieldName, proto_field, hide_value)
		if(indx == nil) then
			return nil
		end
	elseif (j_field_type == J_FIELD_TYPE_OBJ) then
		-- Checking for sub-objects
		indx, matchLength, matchedText = dissect_json_field_object(subtree, tvb, text, jsonFieldName, proto_field, hide_value)
		if(indx == nil) then
			return nil
		end
	else
		-- Handling normal JSON field (string, number, IP address, ...)
		indx = string.find(text, '"' .. jsonFieldName .. '"', 1, true)
		if(indx == nil) then
			return nil
		end
		
		indx = indx - 1 -- Get zero-based index (in strings indexing starts at 1)
		indx = indx + 1 -- Skipping first qoutes
		indx = indx + #jsonFieldName -- Skipping field name
		indx = indx + 2 -- Skipping qoutes and colon
		
		-- Strings get a special case because we need to end on the nearesy " that isn't escaped
		if(j_field_type == J_FIELD_TYPE_STRING) then
			-- Strings are a special case because:
			--	1. they can be null (without qoutes)
			--	2. if they have qoutes, we want to grab everything untill first qoutes WHICH AREN'T ESCAPED!
			
			indx = indx + 1 -- +1 to go back to string indexes

			null_check = string.find(text, '"' .. jsonFieldName .. '":null', 1, true)
			if(null_check ~= nil) then
				indx = indx - 1
				endOffset = indx + 4
				value_is_null = true
			else
				-- Strings are a special case because we want everything between first and
				-- last qoutes BUT ignoring ESCAPED QOUTES within the string
				endOffset = indx + 1 -- +1 to skip the first "
				is_last_char_escape = false
				while(endOffset ~= #text)
				do
					if(get_char(text,endOffset) == '"' and not is_last_char_escape) then
						endOffset = endOffset -1
						break
					end
					is_last_char_escape = get_char(text,endOffset) == '\\'
					endOffset = endOffset + 1
				end
			end
			matchedText = string.sub(text, indx + 1, endOffset);
		else 
			matchedText = string.match(text, '"' .. jsonFieldName .. '":"?(.-)"?[,%}]')
		end
		
		-- Check if we got a match
		if(matchedText == nil) then
			-- Not found in this packet
			return nil
		end
		
		matchLength = #matchedText
		if(matchedText == "") then
			-- found the json field, but the value was empty
			matchedText = "EMPTY STRING"
			matchLength = 0
		end
		
		if(j_field_type == J_FIELD_TYPE_NUM) then
			matchedText = tonumber(matchedText)
		elseif(j_field_type == J_FIELD_TYPE_IP) then
			-- Parsing the 4 numbers out of the string
			a, b, c, d = string.match(matchedText, "(%d+)%.(%d+)%.(%d+)%.(%d+)")
			
			-- Creating a new TVB data source from the 4 bytes
			ip_bytes = ByteArray.new(string.char(a,b,c,d),true)
			ip_tvb = ip_bytes:tvb("IP Address")
			
			-- Adding item to protocol tree
			subtree:add(proto_field, ip_tvb:range())
			return nil -- TODO: Return the IP address somehow
		elseif(j_field_type == J_FIELD_TYPE_STRING) then
			-- For string which AREN'T NULL we need to skip another qoutes for the value's index in the TVB
			if not value_is_null then
				check_qoutes = string.sub(text, indx , indx+1);
				if (check_qoutes == '"') then
					indx = indx + 1
				end
			end
		end
	end
	
	treeText = matchedText
	if hide_value then
		treeText = ""
	end
	-- Adding item to protocol tree
	local item_range = tvb:range(indx, matchLength)
	local treeItem = subtree:add(proto_field, item_range, treeText)
	if hide_value then
		-- Remove ':' from end of string
		treeItem.text = treeItem.text:sub(1, #treeItem.text - 2)
	end
	if matchedText == "null" then
		if global_flow_settings.hide_nulls then
			-- Value is null and we were requested to hide those
			treeItem.hidden = true
		end
	end
	
	return matchedText, treeItem
end

function dissect_json_list_item(subtree, tvb, text, i, json_field_name)
	local indx;
	local search_start_indx;
	local matchLength;
	local matchedText;
	local treeText;
	local saved_i = i;
	
	search_start_indx = 0
	indx = 0
	while( i >= 0)
	do
		indx = search_start_indx
		-- Value isn't null, collecting characters between first and last '{' , '}'
		-- Looking for first '{'
		-- If we see qoutes on the way, remember that we have an object within a string
		totalLen = #text
		while(get_char(text,indx) ~= '{')
		do
			indx = indx + 1
			if(indx >= totalLen) then
				-- Reached end of string, can't find any more items in the list
				-- indicating that by returning nil
				return nil
			end
		end
		
		opened_scopes = 1
		-- Starting with endOffset set to 'index' since the first line in the loop
		-- makes us check the letter after it so we don't count the scope twice
		endOffset = indx
		while(opened_scopes > 0 and endOffset < totalLen)
		do
			endOffset = endOffset + 1
			local c = get_char(text, endOffset)
			if(c == '{') then
				opened_scopes = opened_scopes + 1
			elseif(c == '}') then
				opened_scopes = opened_scopes - 1
			end
		end
		
		matchedText = string.sub(text, indx, endOffset);
		
		i = i - 1;
		search_start_indx = endOffset -- In case we are going to iterate again, start searching AFTER last object ended
	end
	
	-- Found the item at index i
	treeText = matchedText
	if hide_value then
		treeText = ""
	end
	-- Adding item to protocol tree
	local item_range = tvb:range(indx, matchLength)
	local treeItem = subtree:add(json_field_name .. " Item " .. tostring(saved_i) .. ":", item_range, treeText)
	if hide_value then
		-- Remove ':' from end of string
		treeItem.text = treeItem.text:sub(1, #treeItem.text - 2)
	end
	if matchedText == "null" then
		if global_flow_settings.hide_nulls then
			-- Value is null and we were requested to hide those
			treeItem.hidden = true
		end
	end
	
	return matchedText, treeItem
end


function finfo_get_json_field_name(json_field_info)
	return json_field_info[1]
end
function finfo_get_proto_field(json_field_info)
	return json_field_info[2]
end
function finfo_get_json_field_type(json_field_info)
	return json_field_info[3]
end
function finfo_get_sub_finfos(json_field_info)
	return json_field_info[4]
end

function generic_dissect(buf, pkt, subtree, text, json_field_info)
	local json_field_name = finfo_get_json_field_name(json_field_info)
	local proto_field = finfo_get_proto_field(json_field_info)
	local json_field_type = finfo_get_json_field_type(json_field_info)
	local sub_finfos = finfo_get_sub_finfos(json_field_info)

	-- Dissect current field
	local value, ti = dissect_json_field(subtree, buf, text, json_field_name, proto_field, json_field_type, sub_finfos ~= nil)

	if value ~= nil and value ~= "null" then	
		local post_func_name = json_field_name .. "_pre"
		local post_func_ptr = _G[post_func_name]
		if post_func_ptr ~= nil then
			post_func_ptr(buf, pkt, subtree, text, json_field_info)
		end
	end

	-- If we are dealing with an object, see if sub fields are defined
	if json_field_type == J_FIELD_TYPE_OBJ then
		if value == nil or value == "null" then	return end

		local sub_finfos = finfo_get_sub_finfos(json_field_info)
		if (sub_finfos == nil) then	return end

		-- Value is present and subfields are defined.
		-- Making a new TVB and trying to dissect it further for every subfield
		local value_tvb = ByteArray.new(value,true):tvb(json_field_name)

		for i,finfo in pairs(sub_finfos) do
			generic_dissect(value_tvb, pkt, ti, value, finfo)
		end
	end

	-- If we are dealing with a list (array), call the field dissector for every instance in the list
	if json_field_type == J_FIELD_TYPE_LIST then
		if value == nil or value == "null" then	return end

		-- Value is present and subfields are defined.
		-- Making a new TVB and trying to dissect it further for every subfield
		local list_tvb = ByteArray.new(value,true):tvb(json_field_name)
		
		local i = 0
		local value, ti = dissect_json_list_item(ti, list_tvb, value, i, json_field_name)
		while (value ~= nil and i < 3)
		do
			-- Further parse the given item if subfinfos are provided
			if (sub_finfos ~= nil) then
				-- Value is present and subfields are defined.
				-- Making a new TVB and trying to dissect it further for every subfield
				local value_tvb = ByteArray.new(value,true):tvb(json_field_name .. " Item " .. i)
				for i,finfo in pairs(sub_finfos) do
					generic_dissect(value_tvb, pkt, ti, value, finfo)
				end
			end
			i = i + 1
			value, ti = dissect_json_list_item(ti, list_tvb, value, i, json_field_name)
		end
	end
	
	local post_func_name = json_field_name .. "_post"
	local post_func_ptr = _G[post_func_name]
	if post_func_ptr ~= nil then
		post_func_ptr(buf, pkt, subtree, text, json_field_info, value, ti)
	end
end

function generic_dissect_root(buf, pkt, subtree, text, json_field_infos_table)	
	for i, finfo in ipairs(json_field_infos_table) do
		for j, val in ipairs(finfo) do
		end
		generic_dissect(buf, pkt, subtree, text, finfo)
	end
end


-- JSON End



-- Field object extension

-- Getting the value of a field THROWS is .value is accessed and the field isnt in the tree.
-- This snippet saves us space from doing the stupid if check for every single field we want
function get_field_val_safe(field)
	if field() == nil then
		return nil
	end
	return field().value
end

-- Field object extension END



-- TVBUF to string helper 

function get_string_from_tvbuf(buf, start_indx)
	if (start_indx == nil) then
		start_indx = 0
	end

	local out_str = ""
	i = start_indx -- Skipping header
	while(i < buf:len())
	do
		out_str = out_str .. string.char(buf:range(i,1):uint())
		i = i + 1
	end
	return out_str
end

-- TVBUF to string helper END


F_OP = "op"
F_DESC = "description"

F_REQ_TYPE = "requestType"
F_PROTO = "protocolName"
F_DEV_ID = "deviceID"
F_DEV_ID_TO_FIND = "deviceIDToFind"
F_DEV_NAME = "deviceName"
F_DEV_IP = "deviceIP"
F_PORT = "portNumber"
F_NOTI_PORT = "notiPortNumber"
F_DEV_TYPE = "deviceType"
F_AUTH_BODY = "body"

F_BODY_SRC_NONCE = "srvNonce"
F_BODY_SK_NONCE = "skNonce"
F_BODY_DK_NONCE = "dkNonce"
F_BODY_SRV_HMAC = "srvHMAC"
F_BODY_IS_ENROLL_REQ = "isEnrollRequest"
F_BODY_IS_FOR_UNLOCK = "isForUnlock"
F_BODY_UNLOCK_METHOD = "unlockMethod"
F_BODY_GEAR_MAC = "gearMACAddress"
F_BODY_SESSION_KEY = "sessionKey"

F_BODY_PUBLIC_KEY = "publicKey"
F_BODY_CHALLENDE = "challenge"
F_BODY_RF_COMM_SERV_ID = "rfcommServiceId"
F_BODY_MANU_TYPE = "manufacturerType"
F_BODY_IS_PIN_AVAIL = "isPinAvailable"
F_BODY_IS_FOR_SETTINGS = "isForSettings"

F_BODY_SK_HMAC = "skHMAC"
F_BODY_DK_HMAC = "dkHMAC"
F_BODY_ERROR_CODE = "errorCode"

F_BODY_IS_UNLOCK_ENABLED = "isUnlockEnabled"

F_BODY_CONFIRM_PIN_RESULTS = "confirmPinResult"
F_BODY_IS_USE_SAM_PASS = "isUseSam" .. "sungPass"


F_CMD = "CMD"
F_ID = "ID"
F_RESULT = "RESULT"
F_VERSION = "VERSION"
F_BODY = "BODY"


F_BODY_CALL_DATA = "callData"
F_BODY_ALARM_DATA = "alarmData"
F_BODY_TRANS_info_data =     "transferInfoData" 
F_BODY_TRANS_COMP_DATA =     "transferCompletedData" 
F_BODY_HOTSPOT_INFO_DAT =     "hotspotInfoData" 
F_BODY_NOTIF_DATA =     "notificationData" 
F_BODY_AUTH_CONF_DATA =     "authConfigInfoData" 
F_BODY_MIRROR_info_data =     "mirroringInfoData" 
F_BODY_SHARE_CONTENTS_DATA_LIST =     "shareContentsDataList" 
F_BODY_SOCKET_TRANS_COMP_DATA =     "socketTransferCompletedData"
F_BODY_SOCKET_TRANS_START_DATA =     "socketTransferStartData" 
F_BODY_WIFI_DIRECT_STATUS_info_data =     "widiStatusInfoData" 
F_BODY_HDMI_info_data =     "hdmiInfoData" 
F_BODY_CLIPBOARD_SYNC_DATA =     "clipboardSyncData" 
F_BODY_DRAG_START_DATA =     "dragStartData" 
F_BODY_REMOTE_DEVICE_DATA =     "remoteDeviceData"
F_BODY_SOCKET_SERVER_info_data =     "socketServerInfoData"

F_SCDC_CONTENT_TYPE = "contentType"
F_SCDC_FILE_INFO_DATA = "fileInfoData"
F_SCDC_TEXT_INFO_DATA = "textInfoData"
F_SCDC_IS_SYNC_CONTENTS = "isSyncContents"
F_SCDC_SHARE_ID = "shareId"
F_SCDC_PARENT_ID = "parentId"
F_SCDC_LAST_MOUSE_POINT = "lastMousePoint"
F_SCDC_LAST_MOUSE_POINT_x = "X"
F_SCDC_LAST_MOUSE_POINT_y = "Y"
F_FDC_FILE_NAME = "fileName"
F_FDC_FILE_SIZE = "fileSize"
F_FDC_FILE_URI = "fileUri"
F_FDC_FILE_BINARY = "fileBinary"
F_TDC_TITLE = "title"
F_TDC_BODY = "body"

F_BODY_SSI_PORT = "port"
F_BODY_SSI_ADDRESS = "address"
F_BODY_SSI_TYPE = "type"

F_NDC_TYPE = "type"
F_NDC_FLOW_KEY = "flowKey"
F_NDC_KEY = "key"
F_NDC_PACKAGE_NAME = "packageName"
F_NDC_APPLICATION_NAME = "applicationName"
F_NDC_TITLE = "title"
F_NDC_SENDER = "sender"
F_NDC_TEXT = "text"
F_NDC_PHONE_NUMBER = "phoneNumber"
F_NDC_TICKS = "ticks"
F_NDC_COUNT = "count"
F_NDC_IS_REPLY_ENABLE = "isReplyEnable"
F_NDC_IS_CHAT = "isChat"
F_NDC_IS_RECEIVED = "isReceived"
F_NDC_NOTIFICATION_COLOR = "notificationColor"
F_NDC_ICON = "icon"
F_NDC_ATTACH_IMAGE = "attachImage"
F_NDC_LARGE_ICON = "largeIcon"
F_NDC_SMALL_ICON = "smallIcon"
F_NDC_WEARABLE_EXTENDER_BACKGROUND = "wearableExtenderBackground"
F_NDC_MSG_ID = "msgId"
F_NDC_GROUP = "group"
F_NDC_TAG = "tag"
F_NDC_IS_REPLY_FAILED = "isReplyFailed"
F_NDC_ICON_HASH_CODE = "iconHashCode"
F_NDC_ATTACH_IMAGE_HASH_CODE = "attachImageHashCode"
F_NDC_LARGE_ICON_HASH_CODE = "largeIconHashCode"
F_NDC_SMALL_ICON_HASH_CODE = "smallIconHashCode"
F_NDC_WEARABLE_EXTENDER_BACKGROUND_HASH_CODE = "wearableExtenderBackgroundHashCode"
F_NDC_IS_M_M_S = "isMMS"
F_NDC_M_M_S_CONTENTS_DATA = "MMSContentsData"
F_NDC_IS_SUCCESS_GETTING_MESSAGE = "isSuccessGettingMessage"
F_NDC_HAS_SOUND = "hasSound"
F_NDC_HAS_VIBRATE = "hasVibrate"

AUTH_SUB_TAG_REG_REQ = "RegistrationRequest" 
AUTH_SUB_TAG_REG_RESP = "RegistrationResponse"
AUTH_SUB_TAG_PIN_CONF = "PinConfirmResponse"
AUTH_SUB_TAG_AUTH_REQ = "AuthenticationRequest"
AUTH_SUB_TAG_AUTH_RESP = "AuthenticationResponse"
AUTH_SUB_TAG_UNLOCK_STATES_REQ = "UnlockStatesRequest"
AUTH_SUB_TAG_LOOP_CON_ACCEPT_REQ = "LoopConnectionAcceptanceRequest"
AUTH_SUB_TAG_UNLOCK_OPTS_REQ = "UnlockOptionRequest"
AUTH_SUB_TAG_UNLOCK_OPTS_RESP = "UnlockOptionResponse"



local auth_tag_types =
{
	[0] = "Fido", -- "Fast Identity Online"?
	[1] = "CDF", -- "companion device framework"?
}

local auth_sub_tag_types =
{
	[117] = AUTH_SUB_TAG_REG_REQ,
	[118] = AUTH_SUB_TAG_REG_RESP,
	[119] = AUTH_SUB_TAG_PIN_CONF,
	[120] = AUTH_SUB_TAG_AUTH_REQ,
	[121] = AUTH_SUB_TAG_AUTH_RESP,
	[122] = AUTH_SUB_TAG_UNLOCK_STATES_REQ,
	[123] = AUTH_SUB_TAG_LOOP_CON_ACCEPT_REQ,
	[124] = AUTH_SUB_TAG_UNLOCK_OPTS_REQ,
	[125] = AUTH_SUB_TAG_UNLOCK_OPTS_RESP,
}

local p_sam_flow_auth = Proto("flow_auth", "Sam" .. "sung Flow Protocol Auth");

local f_auth_flow_dummy = ProtoField.string("flow", "Dummy")
local f_auth_op = ProtoField.string("flow.op", "Operation")
local f_auth_deviceid = ProtoField.string("flow.deviceid", "Device ID")
local f_auth_devicename = ProtoField.string("flow.devicename", "Device Name")
local f_auth_description = ProtoField.string("flow.description", "Description")
local f_auth_type = ProtoField.uint16("flow.type", "Type", base.DEC)
local f_auth_type_tag = ProtoField.uint16("flow.type.tag", "Tag Type", base.DEC, auth_tag_types)
local f_auth_type_subtag = ProtoField.uint16("flow.type.subtag", "Sub Tag Type", base.DEC, auth_sub_tag_types)
local f_auth_jsonlen = ProtoField.uint32("flow.jsonlen", "JSON Length", base.DEC)
local f_auth_version = ProtoField.uint32("flow.version", "Protocol Version", base.DEC)
local f_auth_body = ProtoField.string("flow.body", "Body")
local f_auth_body_public_key = ProtoField.string("flow.body.public_key", "Public Key")
local f_auth_body_challenge = ProtoField.string("flow.body.challenge", "Challenge")
local f_auth_body_rf_comm_service_id = ProtoField.string("flow.body.rf_comm_service_id", "RF Comm Service ID")
local f_auth_body_manufacturer_type = ProtoField.string("flow.body.manufacturer_type", "Manufacturer Type")
local f_auth_body_is_pin_available = ProtoField.string("flow.body.is_pin_available", "Is Pin Available")
local f_auth_body_is_for_settings = ProtoField.string("flow.body.is_for_settings", "Is For Settings")

local f_auth_body_srv_nonce = ProtoField.string("flow.body.srv_nonce", "SrvNonce")
local f_auth_body_sk_nonce = ProtoField.string("flow.body.sk_nonce", "SkNonce")
local f_auth_body_dk_none = ProtoField.string("flow.body.dk_none", "DkNonce")
local f_auth_body_srv_hmac = ProtoField.string("flow.body.srv_hmac", "SrvHMAC")
local f_auth_body_is_unroll_request = ProtoField.string("flow.body.is_unroll_request", "Is Enroll Request")
local f_auth_body_is_for_unlock = ProtoField.string("flow.body.is_for_unlock", "Is For Unlock")
local f_auth_body_unlock_methood = ProtoField.string("flow.body.unlock_methood", "Unlock Method")
local f_auth_body_gear_mac = ProtoField.string("flow.body.gear_mac", "Gear MAC Address")
local f_auth_body_session_key = ProtoField.string("flow.body.session_key", "Encrypted Session Key")

local f_auth_body_sk_hmac = ProtoField.string("flow.body.sk_hmac", "SkHMAC")
local f_auth_body_dk_hmac = ProtoField.string("flow.body.dk_hmac", "DkHMAC")
local f_auth_body_error_code = ProtoField.string("flow.body.error_code", "Error Code")

local f_auth_body_is_unlock_enabled = ProtoField.string("flow.body.is_unlock_enabled", "Is Unlock Enabled")

local f_auth_body_confirm_pin_results = ProtoField.uint32("flow.body.confirm_pin_Result", "Confirm PIN Result")
local f_auth_body_is_use_sam_pass = ProtoField.string("flow.body.is_use_sam_pass", "Is Use Sam" .. "sung Pass")


local e_auth_no_op = ProtoExpert.new("flow.exp.no_op", "Opertion field missing from JSON", expert.group.PROTOCOL, expert.severity.WARN)

p_sam_flow_auth.fields = {
 f_auth_flow_dummy,
 f_auth_type,
 f_auth_type_tag,
 f_auth_type_subtag,
 f_auth_jsonlen,
 f_auth_op,
 f_auth_deviceid,
 f_auth_devicename,
 f_auth_description,
 f_auth_version,
 f_auth_body,
 f_auth_body_public_key,
 f_auth_body_challenge,
 f_auth_body_rf_comm_service_id,
 f_auth_body_manufacturer_type,
 f_auth_body_is_pin_available,
 f_auth_body_is_for_settings,
 
 f_auth_body_srv_nonce,
 f_auth_body_sk_nonce,
 f_auth_body_dk_none,
 f_auth_body_srv_hmac,
 f_auth_body_is_unroll_request,
 f_auth_body_is_for_unlock,
 f_auth_body_unlock_methood ,
 f_auth_body_gear_mac,
 f_auth_body_session_key,
 
 f_auth_body_sk_hmac,
 f_auth_body_dk_hmac,
 f_auth_body_error_code,

 f_auth_body_is_unlock_enabled,

 f_auth_body_confirm_pin_results,
 f_auth_body_is_use_sam_pass,
}

p_sam_flow_auth.experts = {
 e_auth_no_op,
}

-- A table to be updated at runtime 
known_mobile_auth_ports = {}


auth_body_finfos = 
{
	-- TODO: This is currently a mess  because I placed every possible body field from different bodies.
	-- I should actually parse different bodies based on the message tag & subtag
	{F_BODY_PUBLIC_KEY, f_auth_body_public_key, J_FIELD_TYPE_STRING, nil},
	{F_BODY_CHALLENDE, f_auth_body_challenge, J_FIELD_TYPE_STRING},
	{F_BODY_RF_COMM_SERV_ID, f_auth_body_rf_comm_service_id, J_FIELD_TYPE_STRING},
	{F_BODY_MANU_TYPE, f_auth_body_manufacturer_type, J_FIELD_TYPE_NUM},
	{F_BODY_IS_PIN_AVAIL, f_auth_body_is_pin_available, J_FIELD_TYPE_BOOL},
	{F_BODY_IS_FOR_SETTINGS, f_auth_body_is_for_settings, J_FIELD_TYPE_BOOL},
	{F_DEV_NAME, f_auth_devicename, J_FIELD_TYPE_STRING},
	{F_BODY_SRC_NONCE, f_auth_body_srv_nonce, J_FIELD_TYPE_STRING},
	{F_BODY_SK_NONCE, f_auth_body_sk_nonce, J_FIELD_TYPE_STRING},
	{F_BODY_DK_NONCE, f_auth_body_dk_none, J_FIELD_TYPE_STRING},
	{F_BODY_SRV_HMAC, f_auth_body_srv_hmac, J_FIELD_TYPE_STRING},
	{F_BODY_IS_ENROLL_REQ, f_auth_body_is_unroll_request, J_FIELD_TYPE_BOOL},
	{F_BODY_IS_FOR_UNLOCK, f_auth_body_is_for_unlock, J_FIELD_TYPE_BOOL},
	{F_BODY_UNLOCK_METHOD, f_auth_body_unlock_methood, J_FIELD_TYPE_NUM},
	{F_BODY_GEAR_MAC, f_auth_body_gear_mac, J_FIELD_TYPE_STRING},
	{F_BODY_SESSION_KEY, f_auth_body_session_key, J_FIELD_TYPE_STRING},
	
	{F_BODY_SK_HMAC, f_auth_body_sk_hmac, J_FIELD_TYPE_STRING},
	{F_BODY_DK_HMAC, f_auth_body_dk_hmac, J_FIELD_TYPE_STRING},
	{F_BODY_ERROR_CODE, f_auth_body_error_code, J_FIELD_TYPE_NUM},

	-- Unlock Options Request
	{F_BODY_IS_UNLOCK_ENABLED,f_auth_body_is_unlock_enabled,J_FIELD_TYPE_BOOL},

	-- Pin confirm request
	{F_BODY_CONFIRM_PIN_RESULTS,f_auth_body_confirm_pin_results,J_FIELD_TYPE_NUM},
	{F_BODY_IS_USE_SAM_PASS,f_auth_body_is_use_sam_pass,J_FIELD_TYPE_BOOL},
}
auth_message_finfos =
{
	{F_OP , f_auth_op, J_FIELD_TYPE_STRING},
	{F_AUTH_BODY ,f_auth_body, J_FIELD_TYPE_OBJ, auth_body_finfos},
	{F_DEV_ID , f_auth_deviceid, J_FIELD_TYPE_STRING},
	{F_DEV_NAME , f_auth_devicename, J_FIELD_TYPE_STRING},
	{F_DESC , f_auth_description, J_FIELD_TYPE_STRING},
	{F_VERSION , f_auth_version, J_FIELD_TYPE_NUM},
}

-- TODO: Move me
fi_flow_op = Field.new("flow.op")


function p_sam_flow_auth.dissector(buf, pkt, tree)
		local subtree = tree:add(p_sam_flow_auth, buf:range())
		pkt.cols['protocol'] = 'FLOW-AUTH'
		
		-- Adding dummy so we can filter with 'flow'
		subtree:add(f_auth_flow_dummy):set_hidden()
		
		
		-- Checking if the source port was marked as 'belongs to mobile' by the broadcast dissector
		if(known_mobile_auth_ports[pkt.src_port]) then
			pkt.cols.info:set('[Mobile] ')
		else
			pkt.cols.info:set('[PC] ')
		end
		
		local ti = subtree:add(f_auth_type, buf:range(0,2));
		ti:add(f_auth_type_tag, buf:range(0,1));
		ti:add(f_auth_type_subtag, buf:range(1,1));
		subtree:add(f_auth_jsonlen, buf:range(2,2));
		
		-- Making the resf of the TCP payload, skipping the 4-bytes header, into a string
		local header_len = 4
		local plaintext_str = get_string_from_tvbuf(buf, header_len)

		-- Creating new data source from the ASCII JSON we just got
		local json_bytes = ByteArray.new(plaintext_str,true);
		local json_tvb = json_bytes:tvb("Plaintext JSON");
		subtree:add(json_tvb:range(),"Plaintext JSON");
		
		-- Dissect JSON structure
		generic_dissect_root(json_tvb, pkt, subtree, plaintext_str, auth_message_finfos)

		-- Add operation to info column
		local operation = get_field_val_safe(fi_flow_op)
		if operation == nil then
			subtree:add_proto_expert_info(e_auth_no_op, "Opertion field missing from JSON")
			operation = "NO OP !"
		end
		-- Append auth message type to info col
		pkt.cols.info:append(operation)

		
		-- Hand over data to JSON dissector
		json_dis(json_tvb,pkt,tree);
end



local p_sam_flow_data = Proto("flow_data", "Sam" .. "sung Flow Protocol Data");

local f_data_flow_dummy = ProtoField.string("flow", "Dummy")

p_sam_flow_data.fields = {
	f_data_flow_dummy,
}

tcp_flags_psh = Field.new("tcp.flags.push")

-- Used to count amount of packets in every data channel so we avoid "heavy" ones
-- Keys are ports, values are unique packet counters
data_channels_packet_counters = { }

forbidden_channels = { }

function p_sam_flow_data.dissector(buf, pkt, tree)
	if forbidden_channels[pkt.src_port] then
		local subtree = tree:add(p_sam_flow_data, buf:range())
		pkt.cols['protocol'] = 'FLOW-DATA'
		-- Adding dummy so we can filter with 'flow'
		subtree:add(f_data_flow_dummy):set_hidden()
		pkt.cols['info'] = 'ERROR: Data channel too heavy to handle'
		return buf:len()
	end
	-- Count packets (but only on first pass for every packet)
	if  not pkt.visited then
		last_counter = data_channels_packet_counters[pkt.src_port]
		if last_counter == nil then
			last_counter = 0
		end
		data_channels_packet_counters[pkt.src_port] = last_counter + 1

		-- Packets count threshold
		if data_channels_packet_counters[pkt.src_port] > 50 then
			forbidden_channels[pkt.src_port] = true
		end

		-- Total payload length treshold
		if buf:len() > 10000 then
			forbidden_channels[pkt.src_port] = true
		end
	end
	
	-- Heuristic for reassembly: Continue aggregating as long as we han't seen the PSH flag. PSH markes the end.
	if not tcp_flags_psh().value then
		-- Did not reassemble all data yet, request TCP to give us more bytes
		pkt.desegment_offset = 0
		pkt.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
		return buf:len()
	end
	
	local subtree = tree:add(p_sam_flow_data, buf:range())
	pkt.cols['protocol'] = 'FLOW-DATA'
	-- Adding dummy so we can filter with 'flow'
	subtree:add(f_data_flow_dummy):set_hidden()
	
	
	-- Got all data! Time to decrypt
	
	-- Making the entire TCP payload into a string 
	-- (AES works with strings, even if they contain non-printable chars)
	subtree:add(buf:range(), "Encrypted Payload")
	local encrypted_str = get_string_from_tvbuf(buf)
	
	-- Padding  data to the nearest multiply of 16
	local paddedData = encrypted_str
	local i = #encrypted_str
	while(i%16 ~= 0)
	do
		paddedData = paddedData .. "\x00"
		i = i + 1
	end

	-- Getting Key & IV from prefrences
	key = string.fromhex(global_flow_settings.key)
	local keyBytes = {string.byte(key,1,#key)}

	iv = string.fromhex(global_flow_settings.iv)
	local ivBytes = {string.byte(iv,1,#iv)}
	
	if #key ~= 32 or #iv ~= 32 then
		pkt.cols.info:append('[Encrypted Private Data Channel]')
		if #key == 0 then
			subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and a key was not set in the preferences.")
		elseif #iv == 0 then	
			subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and an iv was not set in the preferences.")
		else
			subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and a key/iv from the preferences was not 16 bytes in hex.")
		end
		return
	end

	-- Can try to decrypt
	local decrypted_str = ciphermode.decryptString(subtree,keyBytes, paddedData, ciphermode.decryptCTR, ivBytes)
	-- Removing the "decrypted" padding bytes
	decrypted_str = string.sub(decrypted_str,0,#encrypted_str)

	-- Creating new data source from the ASCII JSON we got as a result
	local json_bytes = ByteArray.new(decrypted_str, true)
	local json_tvb = json_bytes:tvb("Decrypted Payload")
	local dec_json_ti = subtree:add(json_tvb:range(),"Decrypted Payload")

end


%%FLOW_PROTO_CONSTANTS%%

local %%FLOW_PROTO_VAR%% = Proto("flow_priv", "Sam" .. "sung Flow Protocol Private")

-- Custom fields (not generated)
local f_private_flow_dummy = ProtoField.string("flow", "Dummy")
local f_private_totallen = ProtoField.uint32("flow.totallen", "Total Length", base.DEC)
local f_private_type = ProtoField.uint16("flow.type", "Type", base.DEC)
local f_private_jsonlen = ProtoField.uint32("flow.jsonlen", "JSON Length", base.DEC)

%%FLOW_PROTO_FIELDS_DEFINITIONS%%


%%FLOW_PROTO_VAR%%.fields = {
f_private_flow_dummy,
f_private_totallen,
f_private_type,
f_private_jsonlen,

%%FLOW_PROTO_FIELDS_VARS%%
}


local e_private_keepalive = ProtoExpert.new("flow.exp.keepalive", "Keep-Alive", expert.group.PROTOCOL, expert.severity.CHAT)
local e_private_dec_fail = ProtoExpert.new("flow.exp.decfail", "Decryption Failed", expert.group.DECRYPTION, expert.severity.ERROR)
local e_private_dec_missing_param = ProtoExpert.new("flow.exp.decmissingparam", "Missing Decryption Parameter", expert.group.DECRYPTION, expert.severity.NOTE)

%%FLOW_PROTO_VAR%%.experts = {
	e_private_keepalive,
	e_private_dec_fail,
	e_private_dec_missing_param
}

%%FLOW_PROTO_VAR%%.prefs.hide_nulls = Pref.bool("Hide NULL fields", true, "Whether to show fields with the value of 'null' literally (4 ASCII chars)")
%%FLOW_PROTO_VAR%%.prefs.key = Pref.string("Key", "", "Key for decryption. Format is 16 bytes in hex.")
%%FLOW_PROTO_VAR%%.prefs.iv = Pref.string("IV", "", "IV for decryption")

-- a function for handling prefs being changed
function %%FLOW_PROTO_VAR%%.prefs_changed()
	global_flow_settings.hide_nulls = %%FLOW_PROTO_VAR%%.prefs.hide_nulls
	global_flow_settings.key = %%FLOW_PROTO_VAR%%.prefs.key
	global_flow_settings.iv = %%FLOW_PROTO_VAR%%.prefs.iv
end

-- A table to be updated at runtime 
known_mobile_priv_ports = {}


%%FLOW_PROTO_FIELDS_FINFOS%%


function %%FLOW_PROTO_VAR%%.dissector(buf, pkt, tree)
		-- Reassembly logic before we do anything with the protocol tree
		if(buf:len() >= 4) then
			-- Reading 'length' field (first 4 bytes)
			total_len = buf:range(0,4):uint()
			if buf:len() < total_len then
				-- Did not reassemble all data yet, request TCP to give us more bytes
				pkt.desegment_offset = 0
				pkt.desegment_len = total_len - buf:len()
				return tvbuf:len()
			end
			-- Else case: We have a complete message and we can continue parsing below
		else
			-- We have less than 4 bytes.
			-- Check for possible keep-alive
			local bytes = buf:bytes()
			if (bytes:get_index(0) == 0xff and (bytes:get_index(1) == 0x0fe or bytes:get_index(1) == 0x0fd)) then
				-- It's a Keep alive message, continue parsing below
			else
				-- Not keep alive BUT we DON'T have enough btyes for 'length' field (4 bytes)
				-- asking from TCP for more bytes
				pkt.desegment_offset = 0
				pkt.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
				return tvbuf:len()
			end
		end

		local subtree = tree:add(%%FLOW_PROTO_VAR%%, buf:range())
		pkt.cols['protocol'] = 'FLOW-PRIV'
		
		-- Adding dummy so we can filter with 'flow'
		subtree:add(f_private_flow_dummy):set_hidden()
		
		
		-- Checking if the source port was marked as 'belongs to mobile' by the broadcast dissector
		if(known_mobile_priv_ports[pkt.src_port]) then
			pkt.cols.info:set('[Mobile] ')
		else
			pkt.cols.info:set('[PC] ')
		end
		
		if(buf:len() == 2) then
			-- Check for keep-alive
			local bytes = buf:bytes()
			if(bytes:get_index(0) == 0xff and (bytes:get_index(1) == 0x0fe or bytes:get_index(1) == 0x0fd)) then
				subtree:add_proto_expert_info(e_private_keepalive,"Keep-Alive")
				pkt.cols.info:append('Keep-alive')
				return
			end
		end
		
		subtree:add(f_private_totallen, buf:range(0,4))
		subtree:add(f_private_type, buf:range(4,2))
		subtree:add(f_private_jsonlen, buf:range(6,4))
		
		-- Making the rest of the TCP payload, skipping the 10-bytes header, into a string 
		-- (AES works with strings, even if they contain non-printable chars)
		local header_len = 10
		subtree:add(buf:range(header_len), "Encrypted JSON")
		local encrypted_str = get_string_from_tvbuf(buf, header_len)

		-- Padding  data to the nearest multiply of 16
		local paddedData = encrypted_str
		local i = #encrypted_str
		while(i%16 ~= 0)
		do
			paddedData = paddedData .. "\x00"
			i = i + 1
		end
		
		-- Get keys from config
		key = string.fromhex(global_flow_settings.key)
		local keyBytes = {string.byte(key,1,#key)}
		iv = string.fromhex(global_flow_settings.iv)
		local ivBytes = {string.byte(iv,1,#iv)}
		

		if #key ~= 16 or #iv ~= 16 then
			pkt.cols.info:append('[Encrypted Private Command Channel]')
			if #key == 0 then
				subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and a key was not set in the preferences.")
			elseif #iv == 0 then	
				subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and a key was not set in the preferences.")
			else
				subtree:add_proto_expert_info(e_private_dec_missing_param,"Data is encrypted and a key/iv from the preferences was not 16 bytes in hex.")
			end
			return
		end

		local res = ciphermode.decryptString(subtree,keyBytes, paddedData, ciphermode.decryptCTR, ivBytes)
		-- Removing the "decrypted" padding bytes
		res = string.sub(res,0,#encrypted_str)


		-- Creating new data source from the ASCII JSON we got as a result
		local json_bytes = ByteArray.new(res,true)
		local json_tvb = json_bytes:tvb("Decrypted JSON")
		local dec_json_ti = subtree:add(json_tvb:range(),"Decrypted JSON")
		if (get_char(res,1) ~= '{' or get_char(res,#res) ~= '}') then
			subtree:add_proto_expert_info(e_private_dec_fail,"Decryption Failed: Possibly wrong Key and/or IV")
			pkt.cols.info:append('[DECRYPTION ERROR]')
			return
		end
		
		
		local json_text = res
		generic_dissect_root(json_tvb, pkt, subtree, json_text, %%PRIV_JSON_ROOT_ELEMENT_FINFOS%% )
		
		-- Hand over data to JSON dissector
		json_dis(json_tvb,pkt,tree);
end


-- Post/Pre fields delegates

function CMD_post(buf, pkt, subtree, text, json_field_info, parsed_value, created_ti)
	-- Adding command type to INFO column
	pkt.cols.info:append(parsed_value)
end

function notificationData_pre(buf, pkt, subtree, text, json_field_info)
	-- Adding '(' to INFO column
	pkt.cols.info:append(' (')
end

function notificationData_post(buf, pkt, subtree, text, json_field_info)
	-- Adding ')' to INFO column
	pkt.cols.info:append(')')
end

function applicationName_post(buf, pkt, subtree, text, json_field_info, parsed_value, created_ti)
	pkt.cols.info:append('App: "' .. parsed_value .. '"')
end

function title_post(buf, pkt, subtree, text, json_field_info, parsed_value, created_ti)
	pkt.cols.info:append(' Title: "' .. parsed_value .. '"')
end

-- Post/Pre fields delegates END

connection_device_type = 
{ 
	[1] = "Phone",
	[2] = "Tablet",
	[3] = "Watch",
}

ENTITY_PC = 0
ENTITY_MOBILE = 1

entity_values = {
	[ENTITY_PC] = "PC",
	[ENTITY_MOBILE] = "Mobile",
}


local p_sam_flow_bc = Proto("flow_bc", "Sam" .. "sung Flow Protocol Broadcast");

local f_bc_flow_dummy = ProtoField.string("flow", "Dummy")
local f_bc_entity = ProtoField.uint8("flow.entity", "Entity", base.DEC, entity_values)
local f_bc_requesttype = ProtoField.uint8("flow.requesttype", "Request Type")
local f_bc_protocol = ProtoField.string("flow.protocolname", "Protocol Name");
local f_bc_deviceid = ProtoField.string("flow.deviceid", "Device ID")
local f_bc_deviceidtofind = ProtoField.string("flow.deviceidtofind", "Device ID to find")
local f_bc_devicename = ProtoField.string("flow.devicename", "Device Name")
local f_bc_deviceip = ProtoField.new("Device IP", "flow.deviceip", ftypes.IPv4)
local f_bc_portnumber = ProtoField.uint16("flow.portnumber", "Port Number", base.DEC)
local f_bc_notiportnumber = ProtoField.uint16("flow.notiportnumber", "Notification Port Number", base.DEC)
local f_bc_devicetype_mobile = ProtoField.uint8("flow.devicetype", "Device Type (Mobile)", base.DEC, connection_device_type)
local f_bc_devicetype_pc = ProtoField.uint8("flow.devicetype", "Device Type (PC)")

p_sam_flow_bc.fields = {
 f_bc_flow_dummy,
 f_bc_entity,
 f_bc_requesttype,
 f_bc_protocol,
 f_bc_deviceid,
 f_bc_deviceidtofind,
 f_bc_devicename,
 f_bc_deviceip,
 f_bc_portnumber,
 f_bc_notiportnumber,
 f_bc_devicetype_mobile,
 f_bc_devicetype_pc,
}

function p_sam_flow_bc.dissector(buf, pkt, tree)
		local is_mobile = pkt.dst_port == 45920 -- mobiles broadcast to 45920

		local subtree = tree:add(p_sam_flow_bc, buf:range())
		pkt.cols['protocol'] = 'FLOW-BC'
		
		-- Adding dummy so we can filter with 'flow'
		subtree:add(f_bc_flow_dummy):set_hidden()
		
		-- Adding entity (Mobile or PC) to tree
		local entit_val = ENTITY_PC
		if is_mobile then
			entit_val = ENTITY_MOBILE
		end
		subtree:add(f_bc_entity, entit_val):set_generated()
		
		-- Making the entire UDP payload into a string 
		-- (AES works with strings, even if they contain non-printable chars)
		subtree:add(buf:range(), "Encrypted JSON")
		local encrypted_str = get_string_from_tvbuf(buf)
		
		local pword = "com.sam".."sung.android.galaxycontinuity"
		local res = decrypt(subtree, pword, encrypted_str, AES128, CBCMODE)
		
		-- I think that the AES mode (with padding) makes the decrypt function give us a trailer of unprintable characters
		-- after the closing '}', so we cut them with this substring below
		res = string.sub(res,0,string.find(res, '}', 1, true))
		
		
		-- Creating new data source from the ASCII JSON we got as a result
		local json_bytes = ByteArray.new(res,true);
		local json_tvb = json_bytes:tvb("Decrypted JSON");
		subtree:add(json_tvb:range(),"Decrypted JSON");
		
		
		-- Extracting fields (As ordered in the code)
		dissect_json_field(subtree, json_tvb, res, F_REQ_TYPE, f_bc_requesttype, J_FIELD_TYPE_NUM);
		dissect_json_field(subtree, json_tvb, res, F_PROTO, f_bc_protocol, J_FIELD_TYPE_STRING);
		dissect_json_field(subtree, json_tvb, res, F_DEV_ID, f_bc_deviceid, J_FIELD_TYPE_STRING);
		dissect_json_field(subtree, json_tvb, res, F_DEV_ID_TO_FIND, f_bc_deviceidtofind, J_FIELD_TYPE_STRING);
		local device_name = dissect_json_field(subtree, json_tvb, res, F_DEV_NAME, f_bc_devicename, J_FIELD_TYPE_STRING);
		dissect_json_field( subtree, json_tvb, res, F_DEV_IP, f_bc_deviceip, J_FIELD_TYPE_IP);
		local auth_port  = dissect_json_field(subtree, json_tvb, res, F_PORT, f_bc_portnumber, J_FIELD_TYPE_NUM);
		local notif_bc_port = dissect_json_field(subtree, json_tvb, res, F_NOTI_PORT, f_bc_notiportnumber, J_FIELD_TYPE_NUM);
		if(is_mobile) then
			dissect_json_field(subtree, json_tvb, res, F_DEV_TYPE, f_bc_devicetype_mobile, J_FIELD_TYPE_NUM);
			pkt.cols.info:set('Mobile Broadcast')
			-- Marking port as 'belongs to mobile' in global table
			known_mobile_priv_ports[notif_bc_port] = true
			known_mobile_auth_ports[auth_port] = true
		else
			dissect_json_field(subtree, json_tvb, res, F_DEV_TYPE, f_bc_devicetype_pc, J_FIELD_TYPE_NUM);
			pkt.cols.info:set('PC Broadcast')
		end
		pkt.cols.info:append(' (' .. device_name .. ')')
		
		tcp_port_table = DissectorTable.get("tcp.port")
		if notif_bc_port ~= nil then
			tcp_port_table:add(notif_bc_port, "%%FLOW_PROTO_VAR%%")
		end
		tcp_port_table:add(auth_port, p_sam_flow_auth)
		
		-- Hand over data to JSON dissector
		json_dis(json_tvb,pkt,tree);
end


udp_port_table = DissectorTable.get("udp.port")
udp_port_table:add(45919, p_sam_flow_bc.dissector)
udp_port_table:add(45920, p_sam_flow_bc.dissector)
