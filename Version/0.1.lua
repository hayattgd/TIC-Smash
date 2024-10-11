-- title:   TIC-Smash
-- author:  hayattgd
-- desc:    a game inspired by Smash Bros.
-- license: MIT License
-- version: 0.1
-- script:  lua
-- saveid: TIC-Smash_hayattgd

--[[
CREDITS

Super Smash Bros. by Nintendo
Nesbox (Character)
8-BIT Panda by btco (Character/Tile)
--]]

--sorry i got bad code
--but dw i know how to done this :)

local initialized = false

local frames = 0

local camerapos

Vector2 = {}
Characters = {}
Particles = {}
Players = {}

function Vector2.new(x, y)
	return setmetatable({x=x, y=y}, Vector2)
end

function Vector2.magnitude(pos)
	return math.sqrt(pos.x^2 + pos.y^2)
end

function Vector2.normailze(pos)
	local m = Vector2.magnitude(pos)
	return Vector2.new(pos.x / m, pos.y / m)
end

function Vector2.lerp(a, b ,t)
	return Vector2.new(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t))
end

function Vector2.distance(a, b)
    local dx = b.x - a.x
    local dy = b.y - a.y
    return math.sqrt(dx * dx + dy * dy)
end

function Vector2:__add(v)
	return Vector2.new(self.x + v.x, self.y + v.y)
end

function Vector2:__sub(v)
	return Vector2.new(self.x - v.x, self.y - v.y)
end

function Vector2:__mul(n)
	return Vector2.new(self.x * n, self.y * n)
end

local P1spawn = Vector2.new(0, 0)
local P2spawn = Vector2.new(0, 0)

function Players.new(c, v, npc)
	return {chara=c, pos=v, hp=0.0, hitstop=0, flip=0, velocity=Vector2.new(0, 0), doublejumps=0, frame=0, base = 0, attacks=0, animuntil=0, lastgrounded=0, jumped=-10, score=0, npc=npc, button={false, false, false, false, false, false}, buttonpress={false, false, false, false, false, false}}
end

function Characters.new(n, col, acol, ck, sid, st, df, wgt, iconsprid, iconck)
	return {name=n, color=col, altcolor=acol, colorkey=ck, sprid=sid, str=st, def=df, weight=wgt, iconid=iconsprid, iconcolorkey=iconck}
end

function Particles.new(id, pos, tbl)
	tbl = tbl or {}
	return {id=id, pos=pos, spawned=frames, tbl=tbl}
end

function remap(tile,x,y)
	local oTile, flip, rotate = tile, 0, 0
	
	if tile == 1 or tile == 2 then
		oTile = 0
	end
	
	if tile == 1 then
		P1spawn = Vector2.new(x*8-0*240, y*8-2)
	elseif tile == 2 then
		P2spawn = Vector2.new(x*8-0*240, y*8-2)
	end
	
	return oTile, flip, rotate
end

function Init()
	if initialized then return end
	initialized = true
	
	cls(0)
	poke(0x03FF8, 0)
	
	table.insert(Characters, Characters.new("Nesbox", 10, 9, 0, 256, 5, 3 ,2, 462, 5))
	table.insert(Characters, Characters.new("hayattgd", 12, 13, 0, 264, 4, 3 ,3, 494, 5))
end

function StartBattle(mid, pid1, pid2)
	poke(0x03FF8, 15)

	map(0*30, 0, 30, 17, 0, 0, 0, 1, remap)
	
	table.insert(Players, Players.new(pid1, P1spawn, false))
	table.insert(Players, Players.new(pid2, P2spawn, true))

	camerapos = Vector2.new(0, 0)
	scene = "BATTLE"
end

function Smash(pos, vel, str, target)

	local dist = target.pos - pos

	local smashvel = Vector2.normailze(dist * 0.5 + vel * 4 + Vector2.new(0, -2)) * (target.hp * 0.02 + 0.7) * (2 + str * 0.17)
	smashvel.y = smashvel.y * 0.9

	local magnitude = Vector2.magnitude(smashvel)
	if magnitude > 7 then
		sfx(2, math.floor(magnitude * 0.5), 20, 1)
	end

	table.insert(Particles, Particles.new(2, dist + pos + Vector2.new(0, 3)))

	target.velocity = smashvel * math.clamp(Vector2.magnitude(target.velocity * 0.3), 1, 10)
end


function CharacterBehaviour(id)
	local player = Players[id]
	local chara = Characters[player.chara]
	
	local opponentid = 1
	if id == 1 then opponentid = 2 end

	local opponent = Players[opponentid]
	
	----Tick
	if not player.npc then
		player.button = {
			btn(0 + (id-1)*8),
			btn(1 + (id-1)*8),
			btn(2 + (id-1)*8),
			btn(3 + (id-1)*8),
			btn(4 + (id-1)*8),
			btn(5 + (id-1)*8),
			btn(6 + (id-1)*8),
			btn(7 + (id-1)*8)
		}
		
		player.buttonpress = {
			btnp(0 + (id-1)*8),
			btnp(1 + (id-1)*8),
			btnp(2 + (id-1)*8),
			btnp(3 + (id-1)*8),
			btnp(4 + (id-1)*8),
			btnp(5 + (id-1)*8),
			btnp(6 + (id-1)*8),
			btnp(7 + (id-1)*8)
		}
	else
		local opponentvelpos = opponent.pos + opponent.velocity * 4
		local dist = Vector2.distance(player.pos, opponentvelpos)
		--print(player.pos.x, 2, 2)
		--print(player.pos.y, 2, 12)
		--print(dist, 2, 22)
		player.button = {false, false, false, false, false, false, false, false}
		player.buttonpress = {false, false, false, false, false, false, false, false}

		--Aggressive
		if player.pos.y > opponentvelpos.y - 24 and player.pos.y < opponentvelpos.y+16 then
			if dist > 5 and player.animuntil + 6 < frames and player.pos.y > opponentvelpos.y - 4 and player.pos.y < opponentvelpos.y+2 then
				player.buttonpress[6] = true
			elseif player.animuntil + math.random(2, 6) < frames then
				player.buttonpress[5] = true
			end

			if player.animuntil - 5 > frames then
				if player.pos.x > opponentvelpos.x then
					player.button[4] = true
				else
					player.button[3] = true
				end
	
				if player.pos.y < opponentvelpos.y then
					if player.jumped + 5 < frames then
						player.buttonpress[1] = true
					end
				else
					player.button[2] = true
				end
			else
				if player.pos.x > opponent.pos.x then
					player.button[3] = true
				else
					player.button[4] = true
				end
	
				if player.pos.y < opponent.pos.y then
					player.button[2] = true
				elseif player.jumped + 5 < frames then
					player.buttonpress[1] = true
				end
			end
		else
			if player.pos.x > opponentvelpos.x+16 and player.pos.x < opponentvelpos.x-8 then
				player.buttonpress[6] = false
				player.buttonpress[5] = true
				if player.pos.y < opponentvelpos.y then
					player.button[2] = true
				elseif player.jumped + 5 < frames then
					player.buttonpress[1] = true
				end
			end

			if player.animuntil - 5 > frames then
				if player.pos.x > opponentvelpos.x then
					player.button[4] = true
				else
					player.button[3] = true
				end
			end

			if player.pos.x > opponent.pos.x then
				player.button[3] = true
			else
				player.button[4] = true
			end

			if player.pos.y < opponent.pos.y then
				player.button[2] = true
			elseif player.jumped + 5 < frames then
				player.buttonpress[1] = true
			end
		end
		
		--Defensive
		if player.pos.y > 68 and player.jumped + 27 < frames then
			player.buttonpress[1] = true
			player.button[2] = false
		end

		if player.pos.y > 83 and player.jumped + 27 < frames then
			player.buttonpress[1] = true
			player.button[2] = false
		end
		
		if player.pos.y < 0 then
			player.buttonpress[2] = true
			player.button[2] = true
		end

		if not (player.pos.x > 80 and player.pos.x < 160) then
			if player.pos.x > 120 then
				player.button[3] = true
				player.button[4] = false
			else
				player.button[3] = false
				player.button[4] = true
			end
		end
	end

	--UI
	local shake = 0
	if player.hitstop > 0 then
		shake = math.clamp(player.hitstop, 0, 2)
		player.hitstop = player.hitstop - 0.5
		player.hp = player.hp + 0.5
		sfx(9, math.floor(player.hp * 0.3), 20, 1)
	else
		player.hp = math.floor((player.hp + player.hitstop) * 10) * 0.1
		player.hitstop = 0
	end
	
	--Physics
	local touchingground = false
	
	player.pos.y = player.pos.y + player.velocity.y
	local ychecktileidb = mget(0*30+(player.pos.x+4)//8, (player.pos.y+7)//8)
	local ychecktileida = mget(0*30+(player.pos.x+4)//8, (player.pos.y)//8)
	if fget(ychecktileidb, 0) or fget(ychecktileida, 0) then
		player.pos.y = player.pos.y - player.velocity.y
		player.velocity.y = 0
	elseif fget(ychecktileidb, 1) and player.velocity.y > 0 and player.pos.y < (player.pos.y+7)//8*8-4 and not player.button[2] then
		touchingground = true
		player.pos.y = player.pos.y - player.velocity.y
		player.velocity.y = 0
	end
	
	player.velocity.y = player.velocity.y + 0.09
	
	player.pos.x = player.pos.x + player.velocity.x
	local lefttileid = mget(0*30+(player.pos.x)//8, (player.pos.y+4)//8)
	local righttileid = mget(0*30+(player.pos.x+8)//8, (player.pos.y+4)//8)
	if fget(lefttileid, 0) or fget(righttileid, 0) then
		player.pos.x = player.pos.x - player.velocity.x
		player.velocity.x = 0
	else
		player.velocity.x = player.velocity.x / (chara.weight * 0.02 + 1.1)
	end
	
	local ychecktileidbb = mget(0*30+(player.pos.x+4)//8, (player.pos.y+9)//8)
	if fget(ychecktileidb, 0) then
		touchingground = true
	elseif fget(ychecktileidb, 1) and player.velocity.y > 0 and player.pos.y < (player.pos.y+9)//8*8-4 then
		touchingground = true
	end
	
	if touchingground then
		player.doublejumps = 0
		player.lastgrounded = frames
		player.jumped = -10
	end

	local grounded = touchingground or player.lastgrounded + 10 > frames
	
	--Animation
	local sprid = chara.sprid
	local spriteid = sprid + player.base
	
	if math.abs(player.velocity.x) > 0.2 and frames > player.animuntil then
		player.base = 1
		player.frame = player.frame + player.velocity.x * 0.18
		spriteid = sprid + player.base + math.floor(player.frame % 2)
	elseif frames > player.animuntil then
		player.base = 0
		player.frame = 0
	end

	--Death
	if not posOnRect(-52, -72, 344, 259, player.pos + Vector2.new(4, 4)) then
		player.hp = 0
		player.velocity = Vector2.new(0, 0)
		player.animuntil = 0
		player.hitstop = 0

		sfx(11, -1, -1, 2)

		opponent.score = opponent.score + 1

		if id == 1 then
			player.pos = P1spawn
		else
			player.pos = P2spawn
		end
	end
	
	----Control
	if player.hitstop == 0 then
		--Move
		if player.button[3] then player.velocity.x = player.velocity.x - 0.25 player.flip = 1 end
		if player.button[4] then player.velocity.x = player.velocity.x + 0.25 player.flip = 0 end
		
		if player.buttonpress[1] then
			if player.doublejumps < 2 then
				player.jumped = frames + 30
				sfx(7)
				if player.doublejumps ~= 0 then
					table.insert(Particles, Particles.new(1, player.pos + Vector2.new(4, 8)))
				else
					table.insert(Particles, Particles.new(2, player.pos + Vector2.new(4, 8)))
				end
				player.doublejumps = player.doublejumps + 1
				player.velocity.y = -3 / (chara.weight * 0.05 + 1)
			end
		end
		
		if player.button[2] then
			if player.jumped < frames then
				player.lastgrounded = -100
				if player.velocity.y < 0 and player.velocity.y > -5 then player.velocity.y = 0.4
				else player.velocity.y = player.velocity.y + 0.15 end
			end
		end
		
		if player.buttonpress[2] then
			player.jumped = -10
		end
		
		--Action
		if player.animuntil + 1 < frames then
			if player.buttonpress[5] then
				player.attacks = player.attacks + 1
				if grounded then
					player.base = 4 + math.floor(player.attacks % 2)
					player.animuntil = frames + 2
					
					spriteid = sprid + player.base
					if posOnRect(player.pos.x + 4 + player.flip * -27, player.pos.y - 5, 27, 19, Vector2.new(opponent.pos.x + 4, opponent.pos.y + 4)) then
						opponent.hitstop = opponent.hitstop + chara.str * 0.2
						Smash(player.pos, player.velocity, chara.str, opponent)
					else
						sfx(8, 0, 20, 1)
					end

				else
					player.base = 3
					player.frame = 0
					player.animuntil = frames + 4
					spriteid = sprid + player.base

					if posOnRect(player.pos.x - 5, player.pos.y - 5, 18, 24, Vector2.new(opponent.pos.x + 4, opponent.pos.y + 4)) then
						opponent.hitstop = opponent.hitstop + chara.str * 0.1 + math.clamp(math.floor(player.velocity.y * 7) * 0.1, chara.str * 0.1, chara.str * 3)
						Smash(player.pos, player.velocity, chara.str, opponent)
					else
						sfx(8)
					end
				end
			elseif player.buttonpress[6] then
				player.attacks = player.attacks + 1
				player.base = 6 + math.floor(player.attacks % 2)
				player.animuntil = frames + 55
				
				spriteid = sprid + player.base

				local tbl = {id = opponentid, damage=chara.str * 0.7, flip=player.flip}
				table.insert(Particles, Particles.new(3, Vector2.new(0, player.pos.y), tbl))
			end
		end
	end
	
	----Render
	spr(spriteid, player.pos.x - camerapos.x, player.pos.y - camerapos.y, player.colorkey, 1, player.flip, 0, 1, 1)
	
	--UI
	local UIx = 30
	if id == 2 then UIx = 120 end
	
	trec(UIx + 19,118,46,12,0,223,1,1,-1,0)
	trec(UIx + 19,117,46,12,chara.altcolor,223,1,1,-1,0)
	trec(UIx + 10,111,16,16,0,223,1,1,-1,24)
	trec(UIx + 10,110,16,16,chara.color,223,1,1,-1,24)
	trec(UIx + 9,110,16,16,chara.iconid%16*8,chara.iconid//16*8,16,16,chara.iconcolorkey,0)
	print(chara.name, UIx + 26, 127, 0)
	print(chara.name, UIx + 26, 126, chara.color)
	
	local hpcolor = 12
	if player.hp > 200 then
		hpcolor = 2
	elseif player.hp > 100 then
		hpcolor = 3
	elseif player.hp > 50 then
		hpcolor = 4
	end
	
	print(player.hp.."%", UIx + 28+math.sin(frames * 1.2)*2*shake, 121+math.cos(frames * 1.7)*2*shake, 0)
	print(player.hp.."%", UIx + 28+math.sin(frames * 1.2)*2*shake, 120+math.cos(frames * 1.7)*2*shake, hpcolor)
end

function RenderParticle()
	local particle = {
		function(idx, pos, spawned, tbl)
			ellib(pos.x - camerapos.x, pos.y - camerapos.y, 6 / (frames - spawned), 3 / (frames - spawned), 13)
			if frames - spawned > 6 then
				table.remove(Particles, idx)
			end
		end,
		function(idx, pos, spawned, tbl)
			circ(pos.x - camerapos.x, pos.y - camerapos.y, 6 / (frames - spawned), 14)
			circ(pos.x - camerapos.x, pos.y - camerapos.y, 2 / (frames - spawned), 13)
			if frames - spawned > 6 then
				table.remove(Particles, idx)
			end
		end,

		--[[
		function(idx, pos, spawned, tbl)
			trec(pos.x - 6 / (frames - spawned) - camerapos.x, pos.y - 6 / (frames - spawned) - camerapos.y, 12 / (frames - spawned), 12 / (frames - spawned), 24, 240, 16, 16, 0, 12 / (frames - spawned))
			if frames - spawned > 12 then
				table.remove(Particles, idx)
			end
		end,
		--]]

		function(idx, pos, spawned, tbl)
			local mul = 1
			local startx = -78
			local rot = 0

			if tbl.flip == 1 then
				mul = -1
				startx = 320
				rot = 3.14159
			end

			local cpos = Vector2.new(startx + (frames - spawned) * 9 * mul, pos.y)
			trec(cpos.x - camerapos.x, cpos.y - camerapos.y, 24, 8, (tbl.id-1)*24, 224, 24, 8, 0, rot)

			local player = Players[tbl.id]
			local playerpos = player.pos + Vector2.new(4, 4)

			if posOnRect(cpos.x, cpos.y, 24, 8, playerpos) then
				player.hitstop = player.hitstop + tbl.damage
				Smash(cpos + Vector2.new(12, 4), Vector2.new(9 * mul, 0), tbl.damage * 1.3, player)
			end

			if frames - spawned > 60 then
				table.remove(Particles, idx)
			end
		end
	}

	for i, val in ipairs(Particles) do
		particle[val.id](i, val.pos, val.spawned, val.tbl)
	end
end


function BOOT()
	Init()
	StartBattle(2, 1, 2)
end

Init()

function TIC()
	cls(0)
	local destination = (Players[1].pos + Players[2].pos) * 0.5 - Vector2.new(112, 60)
	camerapos = Vector2.lerp(camerapos, destination, 0.05)
	camerapos = Vector2.new(math.clamp(camerapos.x, -52, 52), math.clamp(camerapos.y, -72, 48))
	map(0*30, 0, 30, 17, -camerapos.x, -camerapos.y, 0, 1, remap)
	
	CharacterBehaviour(1)
	CharacterBehaviour(2)
	
	RenderParticle()

	rectb(0, 0, 240, 136, 15)
	
	frames = frames + 1
end

--utility functions

--[[
	x,y:screen pos,
	w1,h1:width, height in screen
	u,v:UV position of tile/sprite 
	(sprite starts with uv:0,128)
	w2,h2:w,h of uv
	t:color thats be transparent
	angle:Z axis
--]]
function trec(x, y, w1, h1, u, v, w2, h2, t, angle)
	local centerX = x + w1 / 2
	local centerY = y + h1 / 2
	
	local nx = math.cos(angle)
	local ny = math.sin(angle)
	
	local vx = -ny
	local vy = nx
	
	local offsetX = -w1 / 2
	local offsetY = -h1 / 2
	local x1 = offsetX
	local y1 = offsetY
	local x2 = offsetX + w1
	local y2 = offsetY
	local x3 = offsetX + w1
	local y3 = offsetY + h1
	local x4 = offsetX
	local y4 = offsetY + h1
	
	local u2 = u + w2
	local v2 = v
	local u4 = u
	local v4 = v + h2
	local u3 = u2
	local v3 = v4
	
	ttri(x1 * nx - y1 * ny + centerX, x1 * ny + y1 * nx + centerY, 
			x2 * nx - y2 * ny + centerX, x2 * ny + y2 * nx + centerY, 
			x3 * nx - y3 * ny + centerX, x3 * ny + y3 * nx + centerY, 
			u, v, u2, v2, u3, v3, 0, t)
	ttri(x1 * nx - y1 * ny + centerX, x1 * ny + y1 * nx + centerY, 
			x3 * nx - y3 * ny + centerX, x3 * ny + y3 * nx + centerY, 
			x4 * nx - y4 * ny + centerX, x4 * ny + y4 * nx + centerY, 
			u, v, u3, v3, u4, v4, 0, t)
end

function Button(x, y, w, h)
	local _, _, left = mouse()
	if mouseOnRect(x, y, w, h) then
		poke(0x3FFB, 129)
		if left then
			return true
		end
	end
	
	return false
end

function TextButton(txt, x, y, shadow, color, shadowcolor)
	txt = txt or "Text"
	x = x or 0
	y = y or 0
	color = color or 12
	shadowcolor = shadowcolor or 15
	
	if shadow then print(txt, x-1, y+1, shadowcolor) end
	local width = print(txt, x, y, color)
	
	return Button(x, y, width, 6)
end

function posOnRect(x, y, w, h, pos, dbg)
	if dbg then rect(x - camerapos.x, y - camerapos.y, w, h, 12) end
	return pos.x > x and pos.x < x + w and pos.y > y and pos.y < y + h
end

function mouseOnRect(x,y,w,h)
	local mx, my = mouse()
	return mx > x and mx < x + w and my > y and my < y + h
end

function math.clamp(val, min, max)
	return math.min(math.max(val, min), max)
end

function math.lerp(a, b, t)
    return (1 - t) * a + t * b
end

function paltbl(tbl)
	for i = 1, 16, 1 do
		pal(i-1, tbl[i][1], tbl[i][2], tbl[i][3])
	end
end

--Code snippets from https://github.com/nesbox/TIC-80/wiki/code-examples-and-snippets

function pal(i,r,g,b)
	if i<0 then i=0 end
	if i>15 then i=15 end
	if r==nil and g==nil and b==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b)
		poke(0x3fc0+(i*3)+1,g)
		poke(0x3fc0+(i*3),r)
	end
end

-- <TILES>
-- 001:1100001010100110101000101100001010000010100000101000001000000000
-- 002:8800888880800008808000088800888880008000800080008000888800000000
-- 004:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 005:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 006:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 008:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 009:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 010:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 011:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 012:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 013:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 014:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 015:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 016:0ddddddddddddddddddeeeeeddeeeeeeddeeeeeeddeeeeeeddeeeeefddeeeeff
-- 017:ddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffff
-- 018:ddddddd0ddddddddeeeeedddeeeeeeddeeeeeeddeeeeeeddfeeeeeddffeeeedd
-- 019:fddddddd0fdddddd000000000000000000000000000000000000000000000000
-- 020:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 021:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 022:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 023:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 024:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 025:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 026:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 027:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 028:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 029:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 030:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 031:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 032:ddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeff
-- 033:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 034:ffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeedd
-- 035:dddddddddddddddd000000000000000000000000000000000000000000000000
-- 036:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 038:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 039:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 040:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 041:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 042:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 043:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 044:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 045:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 046:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 047:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 048:ddeeeeffddeeeeefddeeeeeeddeeeeeeddeeeeeedddeeeeedddddddd0ddddddd
-- 049:ffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddd
-- 050:ffeeeeddfeeeeeddeeeeeeddeeeeeeddeeeeeeddeeeeedddddddddddddddddd0
-- 051:dddddddfddddddf0000000000000000000000000000000000000000000000000
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 054:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 056:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 057:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 058:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 059:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 060:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 061:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 062:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 063:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 064:fffffffffffffffffffeeeeeffeeeeeeffeeeeeeffeeeeeeffeeeeddffeeeedd
-- 065:ffffffffffffffffeeeeefffeeeeeeffeeeeeeffeeeeeeffddeeeeffddeeeeff
-- 066:ffeeeeddffeeeeddffeeeeeeffeeeeeeffeeeeeefffeeeeeffffffffffffffff
-- 067:ddeeeeffddeeeeffeeeeeeffeeeeeeffeeeeeeffeeeeefffffffffffffffffff
-- 068:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 069:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 070:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 071:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 072:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 073:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 074:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 075:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 076:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 077:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 078:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 079:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 080:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 081:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 082:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 083:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 084:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 085:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 086:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 087:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 088:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 089:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 090:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 091:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 092:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 093:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 094:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 095:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 096:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 097:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 098:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 099:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 100:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 101:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 102:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 103:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 104:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 105:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 106:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 107:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 108:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 109:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 110:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 111:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 112:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 114:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 115:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 116:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 117:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 118:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 119:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 120:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 121:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 122:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 123:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 124:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 125:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 126:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 127:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 128:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 129:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 130:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 131:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 132:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 133:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 134:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 135:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 136:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 137:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 138:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 139:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 140:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 141:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 142:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 143:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 144:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 145:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 146:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 147:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 148:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 149:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 150:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 151:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 152:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 153:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 154:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 155:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 156:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 157:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 158:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 159:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 160:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 161:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 162:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 163:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 164:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 165:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 166:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 167:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 168:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 169:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 170:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 171:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 172:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 173:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 174:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 175:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 176:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 177:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 178:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 179:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 180:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 181:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 182:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 183:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 184:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 185:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 186:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 187:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 188:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 189:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 190:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 191:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 192:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 193:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 194:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 195:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 196:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 197:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 198:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 199:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 200:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 201:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 202:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 203:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 204:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 205:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 206:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 207:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 208:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 209:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 210:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 211:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 212:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 213:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 214:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 215:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 216:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 217:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 218:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 219:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 220:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 221:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 222:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 223:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 224:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 225:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 226:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 227:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 228:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 229:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 230:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 231:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 232:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 233:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 234:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 235:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 236:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 237:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 238:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 239:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 240:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 241:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 242:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 243:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 244:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 245:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 246:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 247:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 248:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 249:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 250:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 251:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 252:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 253:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 254:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 255:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- </TILES>

-- <SPRITES>
-- 000:0088888008acccc008acfcf0d8acccc0ddaaaaa008acaac008aacca000880880
-- 001:0088888008acccc008acfcf008acccc0ddaaaaa0d8acaac00888cca000000880
-- 002:0088888008acccc008acfcf0d8acccc0ddaaaaa008acaac008aac88000880000
-- 003:0000000000dd0000088d88808aaaaaa88aaacfc80aaacfc88acaccc88aaacfc8
-- 004:0088888008acccc008afcfc0d8acccc0ddaaaaa008aacca808aaaaa800880000
-- 005:0088888008acccc008afcfc008acccc0ddaaaaa0d8aacca008a88aa000000088
-- 006:0088888008a22f4008a333f0d8abf550ddaaaaa008aacca008aaaaa000880880
-- 007:0088888008a55f2008a4fbb008a22f20ddaaaaa0d8aacca008aaaaa000880880
-- 008:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef0000d0f00
-- 009:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef000000f00
-- 010:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef0000d0000
-- 011:000000e00000dee00dd0ddd0deddedd00eedfcd00eedf8d0f0f0fce0000fffe0
-- 012:0e0000000eddddee0eddc8cf0ddeffff000ddd00000deeff000eedd0000d0f00
-- 013:0e0000000eddddee0eddc8cf0ddeffff000ddd00000deff0000eeedd000d0f00
-- 014:0b0000000eddddee0edd5a4f0ddeffff00ddddf000ddeef0000eee00000d0f00
-- 015:0b0000000eddddee0edd24bf0ddeffff00ddddf000ddeef0000eee00000d0f00
-- 016:00f00f0600cccc0600cfcf0600cccc060ffffffff0cccc0600fccf0000f00f00
-- 017:000f0f06000ccc0600ccfc0600cccc0600ffffff00cccc0600ccc00000f00f00
-- 018:000f0f06000ccc0600ccfc0600cccc0600ffffff00cccc0600ccc000000ff000
-- 019:00000000f00000000cc000000ccfcc00fccfcccf00cfcfc0000fccc0006f6666
-- 020:0f00f0060cccc0060cfcf0600cccc0600fffff00fcccc6000fccf0000f00f000
-- 021:0f00f0000cccc0000cfcf6000ccccf000ffff060fcccc0600fccf0060f00f006
-- 022:0070070e0055550e0057570e0055550e077777777055550e0075570000700700
-- 023:00e00e0700dddd0700dede0700dddd070eeeeeeee0dddd0700edde0000e00e00
-- 176:0000000000000000000000000000000000000000000000000000000001234567
-- 177:0000000000000000000000000000000000000000000000000000000089abcdef
-- 192:0000000000000000089abbbb89abbbbb89abbbbb089abbbb0000000000000000
-- 193:000000000089abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0089abbb00000000
-- 194:00000000bbbba980bbbbba98bbbbba98bbbbba98bbbbba98bbbba98000000000
-- 195:0000000000000000002344440234444402344444002344440000000000000000
-- 196:0000000000023444444444444444444444444444444444440002344400000000
-- 197:0000000044443200444443204444432044444320444443204444320000000000
-- 206:5ccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 207:ccccc5558888cc55aaaa0c55888a0c55ccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 222:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000ccc5ccccc5c
-- 223:ccca00ccaaaa0cc5caaa0c55aaaa0c55aaaa0c558888cc55000cc555cccc5555
-- 238:5d5555555eddddde5fdaaaaa50eaacaa55eaac9955e99c9955e99c9955e99888
-- 239:55555555eeeeee55aa999e5599c99f5599c99f5599c88f5598c88f5588888f55
-- 254:55eeffff55555ddd55dffddd55dffdde55555eee55555fff55555fe555555eed
-- 255:ffffff55ddd55555deeffd55eeeffd55eee555555ff555555fe555555eed5555
-- </SPRITES>

-- <MAP>
-- 004:000000000000000000000000003132323300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000000000000000000000010000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000000000003132330000000031323300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:000000000000000000011111111111111111111121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:000000000000000000031314121212121212041323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:000000000000000000000003141212121204230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:000000000000000000000000031313131323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:0123456789a987654321012345543210
-- 005:01355310fecaacef01355310fecaacef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000307000000000
-- 001:04f774f7d4f7f4f7f400f400f400f400f400040004000400040004000400040004000400040004000400040004000400040004000400040004000400800000310000
-- 002:04f50400040014002400340064007400a400b400d400d400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400880000f10101
-- 003:04067400d400f400f400f400f400f4000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400800000310101
-- 004:040804001400140024002400340034004400440054005400640074007400840084009400a400a400b400c400e400f400f400f400f400f400f400f400850000000101
-- 005:04f834f794f7f4f7f400f400f400f400f400040004000400040004000400040004000400040004000400040004000400040004000400040004000400800000310101
-- 006:01000100010031007100710061004100410071009100a10081009100b100c100d100d100d100c100a100a100a100a100a100b100d100e100e100c100414000ff0000
-- 007:45789590c5d0f5d005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500b09000310001
-- 008:c40864f7a4f7f4f7f400f400f400f400f400040004000400040004000400040004000400040004000400040004000400040004000400040004000400800000310101
-- 009:04f50400140054009400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400880000610101
-- 010:0000000000000000300060008000a000b000d000e000e000f000f000f000f00000000000000000000000000000000000000000000000000000000000400000f10000
-- 011:04080409040a041a041b041b042c142c142c143d244d244d345d445d446d546d647d747e848e948ea49eb49eb4aec4bec4bfd4cfd4dfe4e0e4f0f4f0870000000000
-- </SFX>

-- <PATTERNS>
-- 000:40f11000000043f13a00000046f11e0000004af13a0000004df1100000004ff13a00000040001e00000040003a00000040001000000040001a00000040003e00000040001a00000040001000000040003a00000040001e00000040001a00000040001000000040003a00000040001e00000040001a00000040001000000040003a00000040001e00000040001a00000040001000000040003a00000040001e00000040001a00000040001000000040003a00000040001e00000040001a000000
-- 001:fff14e000000000000000000000050000000000050000000000000000000000000000000000000000000000000000000500068000000000000000000f00066000000d00066000000c00066000000000000000000000000000000c00066000000000000000000000000000000c00066000000000000000000000000000000c00066000000000000000000000000000000a00066000000c00066000000d00066000000f00066000060c00066000000000000000000000000000000c00066010300
-- 002:000000000000000000000000c00066000000000000000000000000000000c00066000000000060000000000060000000a00066000000c00066000000d00066000000f00066000000500068000000000000000000000000000000500068000000000000000000000060000000500068000000000000000000000060000000500068000000000000000000000000004300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:f0004e000000000000000000000000000000f4f14e000000000000000000000000000000f1f14e0000000000000000000000000000000000000000000000000000000000000000004ff134000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000
-- 004:4ff134000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400036000000000000000000f00016000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000400034000000000000000000f00014000000000000000000
-- 005:0ff1400000000000000000000000500000000000500000000000000000000000000000000000000000000000000000005000a8000000000000000000f000a6000000d000a6000000c000a6000000000000000000000000000000c000a6000000000000000000000000000000c000a6000000000000000000000000000000c000a6000000000000000000000000000000a000a6000000c000a6000000d000a6000000f000a6000060c000a6000000000000000000000000000000c000a6010300
-- 006:000000000000000000000000c000a6000000000000000000000000000000c000a6000000000060000000000060000000a000a6000000c000a6000000d000a6000000f000a60000005000a80000000000000000000000000000005000a80000000000000000000000600000005000a80000000000000000000000600000005000a8000000000000000000000000004300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 007:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003f
-- </TRACKS>

-- <FLAGS>
-- 000:00000000000000000000000000000000101010200000000000000000000000001010102000000000000000000000000010101020000000000000000000000000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <SCREEN>
-- 032:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fddddddddddddddddddddddddddddddf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fddddddddddddddddddddddddddddf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:00000000000000000000000000000000000000000000000000000000000000000000000000000000fddddddddddddddddddddddf00000000000000000000000000000000fddddddddddddddddddddddf00000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:000000000000000000000000000000000000000000000000000000000000000000000000000000000fddddddddddddddddddddf0000000000000000000000000000000000fddddddddddddddddddddf000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888800000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008acccc00000000000000000000000000000000000000000000000000eddddee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008acfcf00000000000000000000000000000000000000000000000000eddc8cf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d8acccc00000000000000000000000000000000000000000000000000ddeffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddaaaaa0000000000000000000000000000000000000000000000000000ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008acaac000000000000000000000000000000000000000000000000000ddeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008aacca000000000000000000000000000000000000000000000000000deeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 071:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880880000000000000000000000000000000000000000000000000000d0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 072:0000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000
-- 073:000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:000000000000000000000000000000000000000000000000000000000000000000000000dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddd000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:000000000000000000000000000000000000000000000000000000000000000000000000dddeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeddd000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:000000000000000000000000000000000000000000000000000000000000000000000000ddddddddddddddddddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeedddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:0000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeeddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeffffffffffffffffffffffffffffffffffffffffffffffffffffeeeedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeffffffffffffffffffffffffffffffffffffffffffffffffffeeeeedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffeeeeeeeeeeeedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffeeeeeeeeeeeedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffeeeeeeeeeeeedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddeeeeeeeeeeeffffffffffffffffffffffffffffffffffffeeeeeeeeeeeddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddddddeeeeffffffffffffffffffffffffffffffffffffeeeedddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddddddeeeeffffffffffffffffffffffffffffffffffffeeeeddddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeffffffffffffffffffffffffffffffffffffeeeedd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeffffffffffffffffffffffffffffffffffeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 102:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 103:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 108:00000000000000000000000000000000000000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 109:0000000000000000000000000000000000000000000aaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 110:0000000000000000000000000000000000000000cccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000d00cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 111:000000000000000000000000000000000000000cc8888888888cc00000000000000000000000000000000000000000000000000000000000000000000000000000edddddeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 112:000000000000000000000000000000000000000caaaaaaaaaaa0caa000000000000000000000000000000000000000000000000000000000000000000000000000fdaaaaaaa999ecc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 113:000000000000000000000000000000000000000ca888888888a0caaaa00000000000000000000000000000000000000000000000000000000000000000000000000eaacaa99c99fcccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 114:000000000000000000000000000000000000000caccccccccca0cccaaa0000000000000000000000000000000000000000000000000000000000000000000000000eaac9999c99fccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 115:000000000000000000000000000000000000000cacc0ccc0cca0c0caaa000000000000000000000000000000000000000000000000000000000000000000000000ce99c9999c88fccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 116:000000000000000000000000000000000000000cacc0ccc0cca0c0caaa000000000000000000000000000000000000000000000000000000000000000000000000ce99c9998c88fccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 117:000000000000000000000000000000000000000cacc0ccc0cca0c0caa099999999999999999999999999999999999990000000000000000000000000000000000cce9988888888fcccc0ddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 118:000000000000000000000000000000000000000caccccccccca00ccaa999999999999999999999999999999999999990000000000000000000000000000000000cceeffffffffffccccdddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 119:00000000000000000000000000000000000000acaaaaaaaaaaa0ccaa099999999999999999999999999999999999999000000000000000000000000000000000ccccccddddddcccccc0dddddddddddddddddddddddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 120:00000000000000000000000000000000000000acaaacaaacaaa0caaa999ccc999999ccc99c999c99999999999999999000000000000000000000000000000000cccdffddddeeffdcccdddcccddddddcccddcdddcddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 121:00000000000000000000000000000000000000acaaaacccaaaa0caa099cc0cc9999cc0cc9099c099999999999999999000000000000000000000000000000000cccdffddeeeeffdcc0ddcc0ccddddcc0ccd0ddc0ddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 122:000000000000000000000000000000000000000caaaaaaaaaaa0caa999ccc0c9999ccc0c999c09999999999999999990000000000000000000000000000000000ccccceeeeeecccccdddccc0cddddccc0cdddc0dddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 123:000000000000000000000000000000000000000c88888888888cca0999cc09c9cc9cc09c99c09999999999999999999000000000000000000000000000000000000cccfffcffcccc0dddcc0dcdccdcc0dcddc0ddddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 124:000000000000000000000000000000000000000cc000ccc000ccaa99990ccc09cc90ccc09c099c9999999999999999900000000000000000000000000000000000000cfeccfeccccdddd0ccc0dccd0ccc0dc0ddcddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 125:0000000000000000000000000000000000000000cccccacccccaa099999000990099000990999099999999999999999000000000000000000000000000000000000000eedceedcc0ddddd000dd00dd000dd0ddd0ddddddddddddddddd0000000000000000000000000000000000000000000000000000000
-- 126:00000000000000000000000000000000000000000000000aaaaaa999aa99a9999999999999aa9999999999999999999000000000000000000000000000000000000000000ccccccdddccdddddddddddddddddddddddccddddccdddddd000000cc00000000000000000000000000000000000000000000000
-- 127:0000000000000000000000000000000000000000000000000aaa0999aaa9a99aaa999aaaa9aaaa999aaa99aa9aa999900000000000000000000000000000000000000000000ccc0dddccccdddccccdcddccddccccdcccccdcccccddccc000cccc00000000000000000000000000000000000000000000000
-- 128:00000000000000000000000000000000000000000000000000009999aaaaa9aa0aa9aaa009aa00a9aa00a90aaa0999900000000000000000000000000000000000000000000000ddddcc00cdc00ccdcddccdc00ccd0cc00d0cc00dc00cc0c00cc00000000000000000000000000000000000000000000000
-- 129:00000000000000000000000000000000000000000000000000000000aa0aa0aaa00000aaa0aa00a0aa00a00aaa00000000000000000000000000000000000000000000000000000000cc00c0c00cc00cccc0c00cc00cc0000cc000ccccc0c00cc00000000000000000000000000000000000000000000000
-- 130:00000000000000000000000000000000000000000000000000000000aa00a00aaa00aaaa00aaaa000aaa00aa0aa0000000000000000000000000000000000000000000000000000000cc00c00cccc0000cc00cccc000ccc000ccc0000cc00cccc00000000000000000000000000000000000000000000000
-- 131:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc000000000000000000000ccc000000000000000000000000000000000000000000000000000000
-- </SCREEN>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

