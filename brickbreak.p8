pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--j scherrer
--ims 213
--scherrjs@miamioh.edu

function _init()
 cls(1)
 --intialize values that
 --control game states
 counter=0
 score=0
 gamestart=false
 gameend=false
 gamewin=false
 --arrays containing all x,y
 --coords of bricks, and if
 --they are shown
 brick_x={}
 brick_y={}
 brick_e={}
 brickassign()
 --ball x and y and speed
 ball_x=64
 ball_y=88
 ball_dx=1.414
 ball_dy=-1.414
 --pad x and y
 pad_x=48
 pad_y=96
 sfx(6)
 
 musstart=false
end

function brickassign()
 for col=0,7 do
  for row=0,7 do
   add(brick_x,row*16)
   add(brick_y,col*8)
   add(brick_e,true)
  end
 end
end
-->8
function _update()
 counter+=1
 --checks if game has ended and
 --resets
 if gameend==true then
  if btnp(5) then
   gamestart=true
   gameend=false
   brick_x=nil
   brick_y=nil
   brick_e=nil
   brick_x={}
   brick_y={}
   brick_e={}
   brickassign()
   score=0
  end
 --checks if game has been won
 --and resets
 elseif gamewin==true then
  if btnp(5) then
   gamestart=true
   gameend=false
   gamewin=false
   brick_x=nil
   brick_y=nil
   brick_e=nil
   brick_x={}
   brick_y={}
   brick_e={}
   brickassign()
   score=0
  end
 --checks if game is running
 --and updates
 elseif gamestart==true then
 --checks if music needs to be
 --started
  if musstart==false then
   music(0)
   musstart=true
  end
  --check if ball bounces off
  --wall
  ballwall()
  --check if ball collides with
  --pad
  if collide(ball_x,
  ball_y, 8, 8,
  pad_x, pad_y, 32,
  4) then
   padbounce()
  end
  --check if any bricks have
  --been hit by ball, and
  --determine new speed
  for i=1,64 do
   if (collide(ball_x,
   ball_y, 8, 8,brick_x[i],
   brick_y[i], 16, 8)
   and brick_e[i]) then
    if (brickbounce(i)) then
     ball_dx=ball_dx*-1
    else
     ball_dy=ball_dy*-1
    end
    brick_e[i] = false
    score+=1
    sfx(2)
   end
  --causes the end of the game
  if ball_y>128 then
   gameend=true
   gamestart=false
   ball_x=64
   ball_y=88
   ball_dx=1.414
   ball_dy=-1.414
   pad_x=48
   pad_y=96
   music(-1)
   sfx(3)
   musstart=false
  end
  end
  --causes the win screen to
  --appear
  if score==64 then
   gamewin=true
   score=0
   music(-1)
   sfx(10)
  end
  --move ball and pad
  ballupdate()
  padupdate()
 --otherwise its on the first
 --screen, check for start
 --input
 else
  if btnp(5) then
   gamestart=true
   sfx(-1)
  end
 end
end
-->8
function _draw()
--check which game state
 if gameend==true then
  endgame()
 elseif gamewin==true then
  wingame()
 elseif gamestart==true then
  drawgame()
 else
  cls(2)
  print("(not) breakout",38,56,6)
  print("press ❎ to start",32,66,6)
 end
end
--main game
function drawgame()
 cls(1)
 spr(1,ball_x,ball_y)
 spr(4,pad_x,pad_y,4,1)
 --check if every brick should
 --be shown before showing it
 for i=1,64 do
  if brick_e[i] then
   spr(2,brick_x[i],brick_y[i],
   2,1)
  end
 end
 print("score: "..score,4,120,7)
end
--lost game gamestate
function endgame()
 cls(0)
 print("game over",46,56,12)
 print("press ❎ to play again",20,68,12)
end
--won game gamestate
function wingame()
 cls(2)
 print("you win!",49,56,11)
 print("press ❎ to play again",20,68,11)
end
-->8
function ballupdate()
--update ball's x and y
 ball_x=ball_x+ball_dx
 ball_y=ball_y+ball_dy
end
-->8
function padupdate()
--update pad's x based on
--player input
 if (pad_x != 0) then
  if (btn(0)) then
   pad_x -= 2
  end
 end
 if (pad_x != 96) then
  if (btn(1)) then
   pad_x += 2
  end
 end
end
-->8
function ballwall()
--checks which wall is being
--hit and which direction
--the ball is moving, then
--reverses the proper direction
--of speed
 if (ball_x >= 120 and
 ball_dx>0 and
 ball_dy<0) then
  ball_dx=ball_dx*-1
  sfx(0)
 end
 if (ball_x >= 120 and
 ball_dx>0 and
 ball_dy>0) then
  ball_dx=ball_dx*-1
  sfx(0)
 end
 if (ball_x <= 0 and
 ball_dx<0 and
 ball_dy<0) then
  ball_dx=ball_dx*-1
  sfx(0)
 end
 if (ball_x <= 0 and
 ball_dx<0 and
 ball_dy>0) then
  ball_dx=ball_dx*-1
  sfx(0)
 end
 if (ball_y <= 0 and
 ball_dx>0 and
 ball_dy<0) then
  ball_dy=ball_dy*-1
  sfx(0)
 end
 if (ball_y <= 0 and
 ball_dx<0 and
 ball_dy<0) then
  ball_dy=ball_dy*-1
  sfx(0)
 end
end

function padbounce()
 if (ball_x+3.5)<(pad_x+4.5) then
  ball_dx=-1.732
  ball_dy=-1
 elseif ((ball_x+3.5)>=(pad_x+4.5) and (ball_x+3.5)<(pad_x+10.5)) then
  ball_dx=-1.414
  ball_dy=-1.414
 elseif ((ball_x+3.5)>=(pad_x+10.5) and (ball_x+3.5)<(pad_x+15.5)) then
  ball_dx=-1
  ball_dy=-1.732
 elseif ((ball_x+3.5)>=(pad_x+15.5) and (ball_x+3.5)<(pad_x+20.5)) then
  ball_dx=1
  ball_dy=-1.732
 elseif ((ball_x+3.5)>=(pad_x+20.5) and (ball_x+3.5)<(pad_x+26.5)) then
  ball_dx=1.414
  ball_dy=-1.414
 elseif ((ball_x+3.5)>=(pad_x+26.5)) then
  ball_dx=1.732
  ball_dx=-1
 end
end
-->8
function collide(
 x1,y1,
 w1,h1,
 x2,y2,
 w2,h2)
 
--collision function - checks
--if the distance between
--center of object bounding
--boxes is less than their
--half-widths and half-heights
--combined
 local xd=abs((x1+(w1/2))-(x2+(w2/2)))
 local xs=w1*0.5+w2*0.5
 local yd=abs((y1+(h1/2))-(y2+(h2/2)))
 local ys=h1/2+h2/2
--if the ball hit something,
--return true
 if xd<xs and yd<ys then 
  return true 
 else
  return false
 end
end
-->8
function brickbounce(i)
--the angle of movement
--of the ball

--false reverses y, true
--reverses x
 local slope = ball_dy/ball_dx
 --travelling down and right
 if (slope>0 and ball_dx>0) then
  local cx=brick_x[i]-ball_x
  local cy=brick_y[i]-ball_y
  --bouncing off top, flip y
  if cx <= 0 then
   return false
  --ball is high compared to
  --corner, will hit top
  elseif cy/cx >= slope then
   return false
  else
  --else hits side, flip x
   return true
  end
 --moving up and right
 elseif (slope<0 and ball_dx>0) then
  cx=brick_x[i]-ball_x
  cy=(brick_y[i]+7)-ball_y
  --hits bottom, flip y
  if cx <= 0 then
   return false
  --ball low compared to corner
  --will hit bottom, flip y
  elseif cy/cx <= slope then
   return false
  --else hits side, flip x
  else
   return true
  end
 --moving down to the left
 elseif (slope<0 and ball_dx<0) then
  cx=(brick_x[i]+15)-ball_x
  cy=brick_y[i]-ball_y
  --will hit top, flip y
  if cx >= 0 then
   return false
  --high compared to corner,
  --flip y
  elseif cy/cx <= slope then
   return false
  --else hits side, flip x
  else
   return true
  end
 --moving up and left
 elseif (slope>0 and ball_dx>0) then
  cx=(brick_x[i]+15)-ball_x
  cy=(brick_y[i]+7)-ball_y
  --hits bottom, flip y
  if cx >= 0 then
   return false
  --low compared to corner,
  --flip y
  elseif cy/cx >= slope then
   return false
  --else hits side, flip x
  else
   return true
  end
 end
 return false
end
__gfx__
0000000000222200000000000000000008888aaaaaa99999bbbbbcccccceeee00000000000000000000000000000000000000000000000000000000000000000
0000000002226220088888888888888088888aaaaaa99999bbbbbcccccceeeee0000000000000000000000000000000000000000000000000000000000000000
0070070022222622088888888888888088888aaaaaa99999bbbbbcccccceeeee0000000000000000000000000000000000000000000000000000000000000000
0007700022222222088888888888888008888aaaaaa99999bbbbbcccccceeee00000000000000000000000000000000000000000000000000000000000000000
00077000222222220888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700222222220888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022222200888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010800000e0570d057000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400002875029750287500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600003562535153000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000415503155021550115500150001500015000150001500015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003262532625000000000032625000000000000000326250000000000000002662500000000000000000000000000000000000000002662500000000000000026625000000000000000000000000000000
0110000000000000002b7520000039700000002d7520000000000000002e75200000000000000000000000002d7522b752297522b7520000000000000002d7520000000000000002f75200000000000000000000
01100020265252652500000285252a5252852526525265250000026525285252a5252b5252a525285252652526525000002852500000265252852526525285252652500000255250000028525275052552525522
011000202f065000002d0652f065000002d06500000000002d0002d0002d0652d0052b0652d065000002b065000000000000000260002606500000280652a065000002b0652d06500000000002e0650000000000
0110002013422000001542217422000001842200000000000000000000124220000014422154220000017422000000000000000000001742200000154221342200000114221042200000000000e4220000000000
0110002017314000000000000000000001531400000000000000000000153140000000000000000000013314000000000000000000000e3140000000000123140000000000153140000000000163140000000000
01100000240502605028050290502b0502b0502b0502b050000002b0000067500000006750000007000000002b050300503005030050000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000655000000065500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
02 07080944
00 0a0b4944

