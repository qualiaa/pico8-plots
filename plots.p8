pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- plotting

function round(x)
 return (x-flr(x)<0.5 and
  flr or ceil)(x)
end


function lerp(t,x0,x1)
 return x0 *(1-t) + (x1-x0)*t
end

function make_ax(posx,posy,
  width,height,x0,x1,y0,y1)
 local ax= {
   px=posx,py=posy,
   w=width,h=height,
   x0=x0,x1=x1,y0=y0,y1=y1
 }
 if x0 and x1 then
  ax.dx = (x1-x0)/width
 end
 if y0 and y1 then
  ax.dy = (y1-y0)/height
 end
 return ax
end

function axpoint(ax,x,y)
  return ax.px +
         round((x-ax.x0)/ax.dx),
         ax.py + ax.h -
         round((y-ax.y0)/ax.dy)
end

function linfun(fn,x0,x1,n)
 local xs,ys = {},{}
 for x=x0,x1,(x1-x0)/n do
  add(xs,x)
  add(ys,fn(x))
 end
 return xs, ys
end

function plotfn(fn,ax,addpt,x0,x1)
 ax.x0 = ax.x0 or x0
 ax.x1 = ax.x1 or x1
 if not ax.dx then
  ax.dx = (ax.x1-ax.x0)/width
 end

 local xs,ys=linfun(fn,ax.x0,ax.x1,ax.w)
 plot(xs,ys,ax,addpt)
end

function minmax(xs)
 local x0, x1
 for i=1,#xs do
  x0=min(x0,xs[i])
  x1=max(x1,xs[i])
 end
 return x0, x1
end

function plot(xs,ys,ax,addpt)
 addpt = addpt or line
 if not (ax.x0 and ax.x1) then
  local x0, x1 = minmax(xs)
  ax.x0 = ax.x0 or x0
  ax.x1 = ax.x1 or x1
  ax.dx = (ax.x1-ax.x0)/ax.w
 end
 if not (ax.y0 and ax.y1) then
  local y0, y1 = minmax(ys)
  ax.y0 = ax.y0 or y0
  ax.y1 = ax.y1 or y1
  ax.dy = (ax.y1-ax.y0)/ax.h
 end

 if addpt==line then
  line()
 end
 for i=1,#xs do
  local x,y = axpoint(ax,xs[i],ys[i])
  addpt(x,y)
 end
end

function draw_ax(ax,x,y,dotted)
 dotted = (dotted==true and 2) or dotted or 0
 x = x or 0
 y = y or 0
 x,y = axpoint(ax,x,y)
 local x0,y0 = axpoint(ax,ax.x0,ax.y0)
 local x1,y1 = axpoint(ax,ax.x1,ax.y1)
 if dotted > 1 then
  for xi=ax.px,ax.px+ax.w,dotted do
   pset(xi,y)
  end
  for yi=ax.py,ax.py+ax.h,dotted do
   pset(x,yi)
  end
 else
  line(x,y0,x,y1)
  line(x0,y,x1,y)
 end
end

function xticks(ax)
 local x0, x1 = tostr(ax.x0),tostr(ax.x1)
 local y = ax.py+ax.h+2

 print(x1,ax.px+ax.w,y)
 print(x0,ax.px,y)
end

function yticks(ax)
 local y0, y1 = tostr(ax.y0),tostr(ax.y1)
 local x = ax.px-1

 print(ax.y1,x-4*#y1,ax.py)
 print(ax.y0,x-4*#y0,ax.py+ax.h)
end


function hbar(xs,ax,
  bar_width,spacing)
 bar_width=bar_width or 1
 spacing = spacing or 0
 local _,max_x = minmax(xs)
 ax.w = ax.w or max_x
 ax.h = ax.h or #xs*(bar_width+spacing)
 ax.dx = ax.dx or max_x/ax.w
 ax.dy = ax.dy or #xs/ax.h
 ax.x0 = ax.x0 or 0
 ax.y0 = ax.y0 or 0

 for i=1,#xs do
  local x = ax.px+xs[i]/ax.dx
  local y = ax.py+ax.h-i*(bar_width+spacing)
  if x-ax.px>0 then
   rectfill(ax.px, y,
            x, y+bar_width)
  end
 end
end


-->8
-- example

xs, ys = {}, {}

for x=0,32 do
 add(xs, x)
 add(ys, flr(rnd(100)))
end

y0,y1 = minmax(ys)

function _draw()
 cls()
 local ax = make_ax(
   10,10,36,20)
 color(8)
 plot(xs,ys,ax,function(x,y)circ(x,y,1)end)
 color(5)
 draw_ax(ax,0,0,3)
 yticks(ax)
 color(9)
 plot({3,30},{30,60},ax)

 ax = make_ax(
   10,40,36,20)
 color(8)
 plot(xs,ys,ax)
 color(5)
 draw_ax(ax,0,0)
 xticks(ax)
 yticks(ax)

 color(8)
 ax = make_ax(
   74,10,50)
 hbar(ys,ax,1,1)

 ax = make_ax(
   20,70,100)
 cards = {1,9,4,3,2,1,0}
 hbar(cards,ax,6,4)
 cards = {0,0,0,0,0,0,1}
 color(10)
 hbar(cards,ax,6,4)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666666666666666667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666666666666666667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666688888888886667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666622222222226667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666622222222226667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666666666666666667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666666666666666667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777666666666666666667777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777788888777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777888788877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777887778877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777887778877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777788888777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777007777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777000777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666667777777777666666dddddddddd6666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd6666669999999999666666dddddddddd6666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd6666669999999999666666dddddddddd6666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777007777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777707777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777000777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666888888888866666688888888886666667777777777666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666222222222266666622222222226666669999999999666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666222222222266666622222222226666669999999999666666dddddddddd6666677777777777777777777777777777
77777777777777777778888877777766666666666666666666666666666666666666666666666666666666666666666666677777777888887777777777777777
77777777777777777788877887777766666666666666666666666666666666666666666666666666666666666666666666677777778877888777777777777777
77777777777777777788777887777766666666666666666666666666666666666666666666666666666666666666666666677777778877788777777777777777
77777777777777777788877887777766666666666666666666666666666666666666666666666666666666666666666666677777778877888777777777777777
777777777777777777788888777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777888887777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd6666668888888888666666dddddddddd6666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd6666662222222222666666dddddddddd6666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd6666662222222222666666dddddddddd6666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
777777777777777777777777777777666666cccccccccc666666dddddddddd666666dddddddddd66666688888888886666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd666666dddddddddd66666622222222226666677777777777777777777777777777
7777777777777777777777777777776666661111111111666666dddddddddd666666dddddddddd66666622222222226666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777766666666666666666666666666666666666666666666666666666666666666666666677777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777788888777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777887778877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777887778877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777888788877777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777788888777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__sfx__
0001000000000000000000000000000001e0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000e050000001005000000110500000013050000001505000000110500000015050150501505015050140500000010050000001405014050140501405013050000000f0500000013050130501305013050
011000000e050000001005000000110500000013050000001505000000110500000015050000001a0500000018050000001505000000110500000015050000001805018050180501805018000180001800018000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344
02 02424344
