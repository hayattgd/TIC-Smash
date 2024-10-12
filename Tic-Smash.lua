-- title:   TIC-Smash
-- author:  hayattgd
-- desc:    a game inspired by Smash Bros.
-- license: MIT License
-- version: 0.1
-- script:  lua
-- saveid: TIC-Smash_hayattgd

--CREDITS:
--https://github.com/hayattgd/TIC-Smash#credits

--im updating this :)

local initialized = false

local frames = 0

local mapid = 0

tilecolor = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	13,13,13,14,10,10,10,9, 3, 3, 3, 2, 5, 3, 0, 0,
	13,14,13,14,10,9, 10,9, 3, 2, 3, 2, 3, 3, 0, 0,
	13,13,13,14,10,10,10,9, 3, 3, 3, 2, 13,3, 0, 0,
	14,14,14,14,9, 9, 9, 9, 2, 2, 2, 2, 0, 0, 0, 0,
	13,14,14,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	14,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
}

mapbg={ 0, 8, 8, 0, 0, 0 }

mappal={
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0xB1, 0x3E, 0x53},{0xEF, 0x7D, 0x57},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x38, 0xB7, 0x64},{0x25, 0x71, 0x79},
		{0x29, 0x36, 0x6F},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xF4, 0xF4, 0xF4},{0x94, 0xB0, 0xC2},{0x56, 0x6C, 0x86},{0x33, 0x3C, 0x57}
	},
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0xB1, 0x3E, 0x53},{0xEF, 0x7D, 0x57},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x38, 0xB7, 0x64},{0x25, 0x71, 0x79},
		{0x29, 0x36, 0x6F},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xF4, 0xF4, 0xF4},{0x94, 0xB0, 0xC2},{0x56, 0x6C, 0x86},{0x33, 0x3C, 0x57}
	},
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0x85, 0x4C, 0x30},{0xD2, 0x7D, 0x2C},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x6D, 0xAA, 0x2C},{0x34, 0x65, 0x24},
		{0x30, 0x34, 0x6D},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xF4, 0xF4, 0xF4},{0x94, 0xB0, 0xC2},{0x56, 0x6C, 0x86},{0x33, 0x3C, 0x57}
	},
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0xB1, 0x3E, 0x53},{0xEF, 0x7D, 0x57},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x38, 0xB7, 0x64},{0x25, 0x71, 0x79},
		{0x29, 0x36, 0x6F},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xFF, 0xFF, 0xFF},{0xB6, 0xB6, 0xB6},{0x56, 0x6C, 0x86},{0x3C, 0x3C, 0x3C}
	},
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0xB1, 0x3E, 0x53},{0xEF, 0x7D, 0x57},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x38, 0xB7, 0x64},{0x25, 0x71, 0x79},
		{0x29, 0x36, 0x6F},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xF4, 0xF4, 0xF4},{0x94, 0xB0, 0xC2},{0x56, 0x6C, 0x86},{0x33, 0x3C, 0x57}
	},
	{
		{0x1A, 0x1C, 0x2C},{0x5D, 0x27, 0x5D},{0xB1, 0x3E, 0x53},{0xEF, 0x7D, 0x57},{0xFF, 0xCD, 0x75},{0xA7, 0xF0, 0x70},{0x38, 0xB7, 0x64},{0x25, 0x71, 0x79},
		{0x29, 0x36, 0x6F},{0x3B, 0x5D, 0xC9},{0x41, 0xA6, 0xF6},{0x73, 0xEF, 0xF7},{0xF4, 0xF4, 0xF4},{0x94, 0xB0, 0xC2},{0x56, 0x6C, 0x86},{0x33, 0x3C, 0x57}
	},
}

mapname={
	"Battlefield",
	"Final Destination",
	"8-BIT PANDA"
}

local bdrid = 0

local scene = "INTRO"

local camerapos

sfunc = {}

Vector2 = {}
Characters = {}
Particles = {}
Players = {}
options = {
	{ name="Flash", value=false },
	{ name="Intro", value=true },
	{ name="FPS", value=false }
}

title = {
	cursor = 0,
	state="Normal",
	menuitem = {
		--Play
		function()
			title.cursor = 1
			title.state = "StageSelect"
		end,
		
		--Option
		function()
			print("still wip sorry", 112, 92, frames*0.2%15, false, 1)
		end,
		
		--Exit
		function()
			exit()
		end
	}
}

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

function sfunc.new(f, duration, func, tbl, timing)
	tbl = tbl or {}
	timing = timing or 0
	return {frame=f, duration=duration, func=func, tbl=tbl, timing=timing}
end

function Players.new(c, v, npc)
	return {chara=c, pos=v, hp=0.0, hitstop=0, flip=0, velocity=Vector2.new(0, 0), doublejumps=0, frame=0, base = 0, attacks=0, animuntil=0, lastgrounded=0, jumped=-10, score=0, npcv={jumped=0}, npc=npc, sfunc={}, button={false, false, false, false, false, false}, buttonpress={false, false, false, false, false, false}}
end

function Characters.new(n, col, acol, ck, sid, st, wgt, special, splength, charaAI, iconsprid, iconck)
	return {name=n, color=col, altcolor=acol, colorkey=ck, sprid=sid, str=st, weight=wgt, special=special, speciallength=splength, charaAI=charaAI, iconid=iconsprid, iconcolorkey=iconck}
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
		P1spawn = Vector2.new(x*8-mapid*240, y*8-2)
	elseif tile == 2 then
		P2spawn = Vector2.new(x*8-mapid*240, y*8-2)
	end
	
	return oTile, flip, rotate
end

function Init()
	if initialized then return end
	initialized = true
	
	cls(0)
	poke(0x03FF8, 0)
	
	table.insert(Characters, Characters.new("Nesbox", 10, 9, 0, 256, 5, 5,
	function(player, opponent)
		table.insert(player.sfunc, sfunc.new(frames, 15, function(player)
			print("dmgcirc()|", player.pos.x - camerapos.x - 25, player.pos.y - camerapos.y - 11, 14)
			print("dmgcirc()|", player.pos.x - camerapos.x - 24, player.pos.y - camerapos.y - 12, 12)
		end, player))
		table.insert(player.sfunc, sfunc.new(frames, 45, function(player)
			circ(player.pos.x - camerapos.x + 3, player.pos.y - camerapos.y + 5, 17, 9)
			circ(player.pos.x - camerapos.x + 4, player.pos.y - camerapos.y + 4, 17, 9)
			circb(player.pos.x - camerapos.x + 4, player.pos.y - camerapos.y + 4, 17, 11)
		end, player, 1))

		table.insert(player.sfunc, sfunc.new(frames+15, 15, function(player)
			print("> |", player.pos.x - camerapos.x - 25, player.pos.y - camerapos.y - 11, 14)
			print("> |", player.pos.x - camerapos.x - 24, player.pos.y - camerapos.y - 12, 12)
		end, player))
		
		table.insert(player.sfunc, sfunc.new(frames+30, 15, function(player)
			print("> run|", player.pos.x - camerapos.x - 25, player.pos.y - camerapos.y - 11, 14)
			print("> run|", player.pos.x - camerapos.x - 24, player.pos.y - camerapos.y - 12, 12)
		end, player))
		
		table.insert(player.sfunc, sfunc.new(frames+45, 0, function(player)
			local dist = Vector2.distance(opponent.pos + Vector2.new(4, 4), player.pos + Vector2.new(4, 4))
			if dist < 17 then
				opponent.hitstop = opponent.hitstop + dist * 0.6
				Smash(player.pos, player.velocity, Characters[player.chara].str, opponent)
			end
		end, player))
	end, 60,
	
	function (player, opponent)
		if Vector2.distance(player.pos, opponent.pos) > 32 and opponent.hp < 75 and (Vector2.magnitude(opponent.velocity) < 0.8 or opponent.hitstop > 1) then
			return true
		else
			return false
		end
	end, 462, 5))

	table.insert(Characters, Characters.new("hayattgd", 12, 13, 0, 264, 4, 6,
	function(player, opponent, id)
		if id == 1 then
			id = 2
		else
			id = 1
		end

		table.insert(Particles, Particles.new(3, player.pos + Vector2.new(4, 4), {id=id, damage=Characters[player.chara].str * 0.5, flip=player.flip}))
	end, 20,
	
	function (player, opponent)
		if opponent.pos.y + opponent.velocity.y * 5 + 16 > player.pos.y + player.velocity.y * 5 + 4 and opponent.pos.y + opponent.velocity.y * 5 - 8 < player.pos.y + player.velocity.y * 5 + 4 and (Vector2.magnitude(opponent.velocity) < 0.4 or Vector2.distance(player.pos, opponent.pos) < 4) then
			return true
		else
			return false
		end
	end, 494, 5))

	table.insert(Characters, Characters.new("8-BIT Panda", 13, 14, 0, 272, 7, 3,
	function(player, opponent)
	
	end, 5,
	
	function (player, opponent)
		
	end))

	table.insert(Characters, Characters.new("STELE", 9, 5, 0, 280, 4, 7,
	function(player, opponent)
	
	end, 5,
	
	function (player, opponent)
		
	end))
end

function StartBattle(mid, pid1, pid2)
	paltbl(mappal[mid+1])
	poke(0x03FF8, 15)
	mapid = mid

	map(mapid*30, 0, 30, 17, 0, 0, 0, 1, remap)
	
	table.insert(Players, Players.new(pid1, P1spawn, false))
	table.insert(Players, Players.new(pid2, P2spawn, true))

	camerapos = Vector2.new(0, 0)
	scene = "BATTLE"
end

function Smash(pos, vel, str, target)

	local dist = target.pos - pos

	local smashvel = Vector2.normailze(dist * 3 + vel * 1) * (math.abs(target.hp - Characters[target.chara].weight * 0.5) * 0.02 + 0.7) * (2 + str * 0.17)
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
	local ychecktileidb = mget(mapid*30+(player.pos.x+4)//8, (player.pos.y+7)//8)
	local ychecktileidbl = mget(mapid*30+(player.pos.x)//8, (player.pos.y+7)//8)
	local ychecktileidbr = mget(mapid*30+(player.pos.x+8)//8, (player.pos.y+7)//8)
	local ychecktileidal = mget(mapid*30+(player.pos.x)//8, (player.pos.y)//8)
	local ychecktileidar = mget(mapid*30+(player.pos.x+8)//8, (player.pos.y)//8)
	if fget(ychecktileidbl, 0) or fget(ychecktileidbr, 0) or fget(ychecktileidal, 0) or fget(ychecktileidar, 0) then
		player.pos.y = player.pos.y - player.velocity.y
		player.velocity.y = 0
	elseif fget(ychecktileidb, 1) and player.velocity.y > 0 and player.pos.y < (player.pos.y+7)//8*8-6 and not player.button[2] then
		touchingground = true
		player.pos.y = player.pos.y - player.velocity.y
		player.velocity.y = 0
	end
	
	player.velocity.y = player.velocity.y + 0.09
	
	player.pos.x = player.pos.x + player.velocity.x
	local lefttileida = mget(mapid*30+(player.pos.x)//8, (player.pos.y)//8)
	local lefttileidb = mget(mapid*30+(player.pos.x)//8, (player.pos.y+7)//8)
	local righttileida = mget(mapid*30+(player.pos.x+8)//8, (player.pos.y)//8)
	local righttileidb = mget(mapid*30+(player.pos.x+8)//8, (player.pos.y+7)//8)
	if fget(lefttileida, 0) or fget(lefttileidb, 0) or fget(righttileida, 0) or fget(righttileidb, 0) then
		player.pos.x = player.pos.x - player.velocity.x
		player.velocity.x = 0
	else
		player.velocity.x = player.velocity.x / (chara.weight * 0.02 + 1.1)
	end
	
	local ychecktileidbb = mget(mapid*30+(player.pos.x+4)//8, (player.pos.y+9)//8)
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
		player.sfunc = { }
		player.doublejumps = 0

		sfx(11, -1, -1, 2)

		opponent.score = opponent.score + 1

		if id == 1 then
			player.pos = P1spawn
		else
			player.pos = P2spawn
		end
	end

	--Input handler
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
		player.button = {false, false, false, false, false, false, false, false}
		player.buttonpress = {false, false, false, false, false, false, false, false}

		--Aggressive
		if (player.animuntil - 50 > frames or opponent.animuntil - 5 > frames and opponent.doublejumps < 2) and (opponent.pos.x > 90 and opponent.pos.x < 150) then
			if player.pos.x < opponentvelpos.x then
				player.button[3] = true
			else
				player.button[4] = true
			end

			if player.pos.y - 2 > opponentvelpos.y then
				player.buttonpress[2] = true
				player.button[2] = true
			elseif player.npcv.jumped + 24 < frames then
				player.buttonpress[1] = true
			end
		else
			if player.pos.x > opponentvelpos.x then
				player.button[3] = true
			else
				player.button[4] = true
			end

			if player.pos.y - 2 < opponentvelpos.y then
				player.buttonpress[2] = true
				player.button[2] = true
			elseif player.npcv.jumped + 24 < frames then
				player.buttonpress[1] = true
			end
		end

		if Vector2.distance(player.pos, opponentvelpos) < 64 then
			if player.animuntil + math.random(2,15) < frames then
				player.buttonpress[5] = true
			end
		end
		
		--Defensive
		if player.pos.y > 60 then
			player.button[2] = false
		end

		if player.pos.y > 70 and player.npcv.jumped + 12 + Vector2.distance(player.pos, Vector2.new(120, player.pos.y)) * 0.05 < frames then
			player.buttonpress[1] = true
		end
		
		if player.pos.y < 0 then
			player.buttonpress[2] = true
			player.button[2] = true
		end

		if not (player.pos.x > 90 + player.hp * 0.2 and player.pos.x < 150 - player.hp * 0.2) then
			if player.pos.x > 120 then
				player.button[3] = true
				player.button[4] = false
			else
				player.button[3] = false
				player.button[4] = true
			end

			if player.pos.y > 78 then
				player.button[2] = false
			end
		end
		
		if player.pos.y > 78 and (player.pos.x > 60 and player.pos.x < 170) then
			if player.pos.x < 120 then
				player.button[3] = true
				player.button[4] = false
			else
				player.button[3] = false
				player.button[4] = true
			end
		end

		player.buttonpress[6] = chara.charaAI(player, opponent)
		if player.buttonpress[6] then player.button[5] = false player.buttonpress[5] = false end
	end
	
	----Control
	if player.hitstop == 0 then
		--Move
		if player.button[3] then player.velocity.x = player.velocity.x - 0.25 player.flip = 1 end
		if player.button[4] then player.velocity.x = player.velocity.x + 0.25 player.flip = 0 end
		
		if player.buttonpress[1] then
			if player.doublejumps < 2 then
				player.npcv.jumped = frames
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
	end
		
	--Action
	if player.animuntil < frames then
		if player.buttonpress[5] then
			player.attacks = player.attacks + 1
			if grounded then
				player.base = 4 + math.floor(player.attacks % 2)
				player.animuntil = frames + 3
				
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
				player.animuntil = frames + 10
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
			player.animuntil = frames + chara.speciallength
			
			spriteid = sprid + player.base

			chara.special(player, opponent, id)
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
	if chara.iconid then
		trec(UIx + 10,109,16,16,chara.iconid%16*8,chara.iconid//16*8,16,16,chara.iconcolorkey,0)
	else
		trec(UIx + 10,109,16,16,chara.sprid%16*8,chara.sprid//16*8,8,8,0,0)
	end
	print(chara.name, UIx + 26, 127, 0)
	print(chara.name, UIx + 26, 126, chara.color)
	print(player.score, UIx + 58, 115, 0, false, 1, true)
	print(player.score, UIx + 59, 114, 12, false, 1, true)
	
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
			local rot = 0

			if tbl.flip == 1 then
				mul = -1
				rot = math.pi
			end

			local cpos = Vector2.new(pos.x + (frames - spawned) * 8 * mul - 12, pos.y - 4)
			trec(cpos.x - camerapos.x, cpos.y - camerapos.y, 24, 8, 0, 224, 24, 8, 0, rot)

			local player = Players[tbl.id]
			local playerpos = player.pos + Vector2.new(4, 4)

			if posOnRect(cpos.x, cpos.y, 24, 8, playerpos) then
				player.hitstop = player.hitstop + tbl.damage * 0.2
				Smash(cpos + Vector2.new(12, 4), Vector2.new(9 * mul, 0), tbl.damage * 0.7, player)
			end

			if frames - spawned > 80 then
				table.remove(Particles, idx)
			end
		end
	}

	for i, val in ipairs(Particles) do
		particle[val.id](i, val.pos, val.spawned, val.tbl)
	end
end

function ProcessScheduledFunc(timing, sfunc)
	for idx, value in ipairs(sfunc) do
		if value.timing == timing then
			if value.frame == frames or (value.frame + value.duration > frames and value.frame < frames) then
				value.func(value.tbl)
			elseif value.frame +  value.duration < frames then
				table.remove(sfunc, idx)
			end
		end
	end
end


function BOOT()
	Init()
	StartBattle(math.random(0, 3), math.random(1, 4), math.random(1, 4))
end

Init()

function BDR(l)
	--Rainbow effect
	--https://tic80.com/play?cart=4034
	--by LeaderJord
	local c = {
		{0x29, 0x36, 0x6f},
		{0x3b, 0x5d, 0xc9},
		{0x41, 0xa6, 0xf6},
		{0x73, 0xef, 0xf7}
	}

	t=l/16*math.pi*2-(frames/16)
	r=math.sin(t)*127+128
	g=math.sin(t+math.pi*2/3)*127+128
	b=math.sin(t+math.pi*2*2/3)*127+128

	poke(0x3fc3,r)
	poke(0x3fc4,g)
	poke(0x3fc5,b)

	for i=1,4 do
		for j=1,3 do
			t=c[i][j]
			poke(0x3fd4+j+i*3,t)
		end
	end
end

function TIC()
	if scene == "INTRO" then
		
		if frames < 500 then
			if btnp(4) then
				frames = 500
			end
		end
		
		if frames < 100 then
			trec(-140, frames*2, 512, 7, 14, 223, 1, 1, -1, 0)
		elseif frames == 100 then
			cls(14)
			sfx(1)
			print("W", 80, 69, 0)
			print("W", 80, 68, 12)
		elseif frames == 105 then
			sfx(1)
			print("We", 80, 69, 0)
			print("We", 80, 68, 12)
		elseif frames == 110 then
			sfx(1)
			print("Wel", 80, 69, 0)
			print("Wel", 80, 68, 12)
		elseif frames == 115 then
			sfx(1)
			print("Welc", 80, 69, 0)
			print("Welc", 80, 68, 12)
		elseif frames == 120 then
			sfx(1)
			print("Welco", 80, 69, 0)
			print("Welco", 80, 68, 12)
		elseif frames == 125 then
			sfx(1)
			print("Welcom", 80, 69, 0)
			print("Welcom", 80, 68, 12)
		elseif frames == 130 then
			sfx(1)
			print("Welcome", 80, 69, 0)
			print("Welcome", 80, 68, 12)
		elseif frames == 135 then
			sfx(1)
			print("Welcome t", 80, 69, 0)
			print("Welcome t", 80, 68, 12)
		elseif frames == 140 then
			sfx(1)
			print("Welcome to", 80, 69, 0)
			print("Welcome to", 80, 68, 12)
		elseif frames == 160 then
			sfx(1)
			print("Welcome to.", 80, 69, 0)
			print("Welcome to.", 80, 68, 12)
		elseif frames == 180 then
			sfx(1)
			print("Welcome to..", 80, 69, 0)
			print("Welcome to..", 80, 68, 12)
		elseif frames == 200 then
			sfx(1)
			print("Welcome to...", 80, 69, 0)
			print("Welcome to...", 80, 68, 12)
		elseif frames == 260 then
			poke(0x03FF8, 13)
			cls(13)
		elseif frames == 280 then
			cls(13)
			poke(0x03FF8, 13)
		elseif frames == 300 then
			cls(13)
			poke(0x03FF8, 13)
		elseif frames == 320 then
			cls(14)
			poke(0x03FF8, 14)
		elseif frames == 340 then
			cls(15)
			poke(0x03FF8, 15)
		elseif frames == 360 then
			cls(0)
			poke(0x03FF8, 0)
		elseif frames == 417 then
			sfx(2)
		elseif frames == 420 then
			cls(14)
			poke(0x03FF8, 14)
		elseif frames == 422 then
			cls(13)
			poke(0x03FF8, 13)
		elseif frames == 424 then
			cls(15)
			poke(0x03FF8, 15)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(450-frames, 0, 8), 69+math.cos(frames)*math.clamp(450-frames, 0, 8), 14)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(450-frames, 0, 8), 68+math.cos(frames)*math.clamp(450-frames, 0, 8), 12)
		elseif frames > 424 and frames < 450 then
			cls(0)
			poke(0x03FF8, 0)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(450-frames, 0, 8), 69+math.cos(frames)*math.clamp(450-frames, 0, 8), 14)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(450-frames, 0, 8), 68+math.cos(frames)*math.clamp(450-frames, 0, 8), 12)
		elseif frames == 500 then
			music(0)
		elseif frames > 500 and frames < 600 then
			cls(12+frames*0.05%3)
			poke(0x03FF8, 12+frames*0.1%3)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(500-frames, -10000, 0), 69+math.cos(frames)*math.clamp(500-frames, -10000, 0), 14)
			print("TIC-Smash!!!!", 80+math.sin(frames*1.1)*math.clamp(500-frames, -10000, 0), 68+math.cos(frames)*math.clamp(500-frames, -10000, 0), 12)
		elseif frames == 600 then
			cls(0)
			poke(0x03FF8, 0)
		elseif frames == 650 then
			cls(13)
			poke(0x03FF8, 13)
		elseif frames == 652 then
			cls(13)
			poke(0x03FF8, 13)
		elseif frames == 653 then
			cls(14)
			poke(0x03FF8, 14)
		elseif frames == 654 then
			cls(15)
			poke(0x03FF8, 15)
		elseif frames == 655 then
			cls(0)
			scene = "TITLE"
		end
	elseif scene == "TITLE" then
		if title.state == "Normal" then
			cls(15)
			circ(34, 51, 25, 0)
			circ(35, 50, 24, 14)
			spr(485, 20, 35, 5, 2, 0, 0, 2, 2)
			print("TIC-Smash!!!", 59, 61, 14, false, 2)
			print("TIC-Smash!!!", 60, 60, 12, false, 2)
			
			if btnp(0) then
				title.cursor = title.cursor - 1
			elseif btnp(1) then
				title.cursor = title.cursor + 1
			end
			
			title.cursor = math.clamp(title.cursor, 0, 2)
			
			print(">", 53, 82 + 10 * title.cursor, 14, false, 1)
			print(">", 52, 82 + 10 * title.cursor, 14, false, 1)
			print(">", 54, 81 + 10 * title.cursor, 12, false, 1)
			print(">", 53, 81 + 10 * title.cursor, 12, false, 1)
			--[[
			--Just printing text
			print("PLAY", 59, 81, 14, true, 1)
			print("PLAY", 60, 80, 12, true, 1)
			
			print("OPTIONS", 59, 91, 14, true, 1)
			print("OPTIONS", 60, 90, 12, true, 1)
			
			print("EXIT", 59, 101, 14, true, 1)
			print("EXIT", 60, 100, 12, true, 1)
			]]--
			
			if btn(4) then title.menuitem[title.cursor+1]() end
			if TextButton("PLAY", 59, 81, true, 12, 14) then title.menuitem[1]() end
			if TextButton("OPTIONS", 59, 91, true, 12, 14) then title.menuitem[2]() end
			if TextButton("EXIT", 59, 101, true, 12, 14) then title.menuitem[3]() end
		elseif title.state == "StageSelect" then
			cls(0)
			for i = 1, 6, 1 do
				local framecolor = 14
				
				local pos = Vector2.new((i-1)*38+10, 6)

				local touchingcursor = mouseOnRect(pos.x, pos.y, 32, 19)
				if touchingcursor then
					poke(0x3FFB, 129)
					title.cursor = i
				end

				if title.cursor == i then
					paltbl(mappal[i])
					framecolor = 12
					rect(9, 26, 224, 104, mapbg[i])
					map((i-1) * 30 % 240 + 1, (i-1) // 8 * 17 + 2, 28, 13, 9, 26, 0, 1, remap)
					rectb(9, 26, 224, 104, 14)
					local _, _, click = mouse()
					if touchingcursor and click or btnp(4) then
						mapid = i-1
						title.state = "CharaSelect"
					end
				end

				rectb(pos.x, pos.y, 32, 19, framecolor)
				for x = 0, 29, 1 do
					for y = 0, 16, 1 do
						pix(pos.x + 1 + x, pos.y + 1 + y, tilecolor[mget(x + (i-1) * 30 % 240, y + (i-1) // 8 * 17) + 1])
					end
				end
			end

			if btnp(2) then title.cursor = title.cursor - 1 end
			if btnp(3) then title.cursor = title.cursor + 1 end

			title.cursor = math.clamp(title.cursor, 1, 6)
		elseif title.state == "CharaSelect" then
			cls(15)
			for idx, value in ipairs(Players) do
				rectb(idx-1)
			end
		end
	elseif scene == "BATTLE" then
		cls(mapbg[mapid+1])
		local destination = (Players[1].pos + Players[2].pos) * 0.5 - Vector2.new(112, 60)
		camerapos = Vector2.lerp(camerapos, destination, 0.05)
		camerapos = Vector2.new(math.clamp(camerapos.x, -52, 52), math.clamp(camerapos.y, -72, 48))
		ProcessScheduledFunc(1, Players[1].sfunc)
		ProcessScheduledFunc(1, Players[2].sfunc)

		map(mapid*30, 0, 30, 17, -camerapos.x, -camerapos.y, 0, 1, remap)
		
		CharacterBehaviour(1)
		CharacterBehaviour(2)

		ProcessScheduledFunc(0, Players[1].sfunc)
		ProcessScheduledFunc(0, Players[2].sfunc)
		
		RenderParticle()
	end

	rectb(0, 0, 240, 136, 13)
	
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
-- 016:0ddddddddddddddddddeeeeeddeeeeeeddeeeeeeddeeeeeeddeeeeefddeeeeff
-- 017:ddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffff
-- 018:ddddddd0ddddddddeeeeedddeeeeeeddeeeeeeddeeeeeeddfeeeeeddffeeeedd
-- 019:fddddddd0fdddddd000000000000000000000000000000000000000000000000
-- 020:0aaaaaaaaaaaaaaaaaa99999aa999999aa999999aa999999aa999998aa999988
-- 021:aaaaaaaaaaaaaaaa999999999999999999999999999999998888888888888888
-- 022:aaaaaaa0aaaaaaaa99999aaa999999aa999999aa999999aa899999aa889999aa
-- 023:8aaaaaaa08aaaaaa000000000000000000000000000000000000000000000000
-- 024:0333333333333333333222223322222233222222332222223322222f332222f2
-- 025:3333333333333333222222222222222222222222222222222f2f2f2ff2f2f2f2
-- 026:33333330333333332222233322222233222222332222223322222233f2222233
-- 027:2333333302333333000000000000000000000000000000000000000000000000
-- 028:7676767677777777232223222222222222232232222222222322322322222222
-- 029:3333333303232323000000000000000000000000000000000000000000000000
-- 032:ddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeffddeeeeff
-- 033:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 034:ffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeeddffeeeedd
-- 035:dddddddddddddddd000000000000000000000000000000000000000000000000
-- 036:aa999988aa999988aa999988aa999988aa999988aa999988aa999988aa999988
-- 037:8888888888888888888888888888888888888888888888888888888888888888
-- 038:889999aa889999aa889999aa889999aa889999aa889999aa889999aa889999aa
-- 039:aaaaaaaaaaaaaaaa000000000000000000000000000000000000000000000000
-- 040:3322222f332222f23322222f332222f23322222f332222f23322222f332222f2
-- 041:2f2f2f2ff2f2f2f22f2f2f2ff2f2f2f22f2f2f2ff2f2f2f22f2f2f2ff2f2f2f2
-- 042:2f222233f22222332f222233f22222332f222233f22222332f222233f2222233
-- 043:3333333333333333000000000000000000000000000000000000000000000000
-- 044:2223222322222222232223222222222222232232222222222322322322222222
-- 045:3333333323232323000000000000000000000000000000000000000000000000
-- 048:ddeeeeffddeeeeefddeeeeeeddeeeeeeddeeeeeedddeeeeedddddddd0ddddddd
-- 049:ffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddd
-- 050:ffeeeeddfeeeeeddeeeeeeddeeeeeeddeeeeeeddeeeeedddddddddddddddddd0
-- 051:dddddddfddddddf0000000000000000000000000000000000000000000000000
-- 052:aa999988aa999998aa999999aa999999aa999999aaa99999aaaaaaaa0aaaaaaa
-- 053:888888888888888899999999999999999999999999999999aaaaaaaaaaaaaaaa
-- 054:889999aa899999aa999999aa999999aa999999aa99999aaaaaaaaaaaaaaaaaa0
-- 055:aaaaaaa8aaaaaa80000000000000000000000000000000000000000000000000
-- 056:3322222f33222222332222223322222233222222333222223333333303333333
-- 057:2f2f2f2ff2f2f2f2222222222222222222222222222222223333333333333333
-- 058:2f222233f2222233222222332222223322222233222223333333333333333330
-- 059:3333333233333320000000000000000000000000000000000000000000000000
-- 060:eeedeeedeeeeeeeeedeeedeeeeeeeeeeeeedeedeeeeeeeeeedeedeedeeeeeeee
-- 061:3333333323232320000000000000000000000000000000000000000000000000
-- 064:fffffffffffffffffffeeeeeffeeeeeeffeeeeeeffeeeeeeffeeeeddffeeeedd
-- 065:ffffffffffffffffeeeeefffeeeeeeffeeeeeeffeeeeeeffddeeeeffddeeeeff
-- 066:ffeeeeddffeeeeddffeeeeeeffeeeeeeffeeeeeefffeeeeeffffffffffffffff
-- 067:ddeeeeffddeeeeffeeeeeeffeeeeeeffeeeeeeffeeeeefffffffffffffffffff
-- 068:888888888888888888899999889999998899999988999999889999aa889999aa
-- 069:888888888888888899999888999999889999998899999988aa999988aa999988
-- 070:889999aa889999aa889999998899999988999999888999998888888888888888
-- 071:aa999988aa999988999999889999998899999988999998888888888888888888
-- 072:2f2f2f2ff2f2f2f22f222222f22222222f222222f22222222f222233f2222233
-- 073:2f2f2f2ff2f2f2f222222f2f222222f22222222f222222f23322222f332222f2
-- 074:2f222233f22222332f222222f22222222f222222f2f222222f2f2f2ff2f2f2f2
-- 075:3322222f332222f22222222f222222f22222222f222222f22f2f2f2ff2f2f2f2
-- 080:cccccccdcfddddffccddddcfcddddddfcddddddfcfddddffccddddcfffffffff
-- 081:dfffdfffcddfcddfcccdcccdcccdcccdcddfcddfcddfcddfdfffdfffffffffff
-- 082:dcccccdffdccddfffdccddffffddffffdcccccdffdccddfffdccddffffddffff
-- 096:44044444fc400000fcfc0c0cf4f40404f4f00000ff0000000000000000000000
-- 097:44444444000000000c0c0c0c0404040400000000000000000000000000000000
-- 098:44444044000004cf0c0c0fcf04040f4f00000f4f000000ff0000000000000000
-- 112:ffffffffffffffffffffffffff99ffffff99fffffffff9ffffffffffffffffff
-- </TILES>

-- <SPRITES>
-- 000:0088888008acccc008acfcf0d8acccc0ddaaaaa008acaac008aacca000880880
-- 001:0088888008acccc008acfcf008acccc0ddaaaaa0d8acaac00888cca000000880
-- 002:0088888008acccc008acfcf0d8acccc0ddaaaaa008acaac008aac88000880000
-- 003:0000000000dd0000088d88808aaaaaa88aaacfc80aaacfc88acaccc88aaacfc8
-- 004:0088888008acccc008afcfc0d8acccc0ddaaaaa008aacca808aaaaa800880000
-- 005:0088888008acccc008afcfc008acccc0ddaaaaa0d8aacca008a88aa000000088
-- 006:0088888008a12f4008a313f0d8a1f150ddaaaaa008aacca008aaaaa000880880
-- 007:0088888008a51f1008a1f1b008a21f10ddaaaaa0d8aacca008aaaaa000880880
-- 008:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef0000d0f00
-- 009:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef000000f00
-- 010:0e0000000eddddee0eddc8cf0ddeffff000ddd0000ddeef000deeef0000d0000
-- 011:000000e00000dee00dd0ddd0deddedd00eedfcd00eedf8d0f0f0fce0000fffe0
-- 012:0e0000000eddddee0eddc8cf0ddeffff000ddd00000deeff000eedd0000d0f00
-- 013:0e0000000eddddee0eddc8cf0ddeffff000ddd00000deff0000eeedd000d0f00
-- 014:010000000eddddee0edd514f0ddeffff00ddddf000ddeef0000eee00000d0f00
-- 015:010000000eddddee0edd21bf0ddeffff00ddddf000ddeef0000eee00000d0f00
-- 016:00f00f0600cccc0600cfcf0600cccc060ffffffff0cccc0600fccf0000f00f00
-- 017:000f0f06000ccc0600ccfc0600cccc0600ffffff00cccc0600ccc00000f00f00
-- 018:000f0f06000ccc0600ccfc0600cccc0600ffffff00cccc0600ccc000000ff000
-- 019:00000000f00000000cc000000ccfcc00fccfcccf00cfcfc0000fccc0006f6666
-- 020:00f00f0600cccc0600cfcf0600cccc6000fffff00fcccc6000fccf0000f00f00
-- 021:00f00f0000cccc0000cfcf6000ccccf000ffff600fcccc0600fccf0600f00f06
-- 022:000000000055550000c1c1000055550000000000005555000005500000000000
-- 023:0000000000222200004141000022220000000000004444000004400000000000
-- 024:0055550005555550055444500544440003399300039499400533330000300300
-- 025:0005555000555555055544455554444053399300039499400033330003000300
-- 026:0005555000555555055544455554444053399300039499400033330000033000
-- 027:0000000000000000005555000555555005544450054444000394994003300300
-- 028:0005555000555555055544455554444055339300053999400003333000030000
-- 029:0005555000555555055544455554444055339340053999000003330000300030
-- 030:0001111000111111011144411114444011339990013999940033330003003000
-- 031:000aaaa000aaaaaa0aaa444aaaa44440aa3399900a3999940033330003003000
-- 176:0000000000000000000000000000000000000000000000000000000001234567
-- 177:0000000000000000000000000000000000000000000000000000000089abcdef
-- 178:aaaaaaa8aaaaaa88aa999988aa999988aa999988aa999988a888888888888888
-- 179:cccccccecccccceeccddddeeccddddeeccddddeeccddddeeceeeeeeeeeeeeeee
-- 180:4444444244444422443333224433332244333322443333224222222222222222
-- 181:6666666866666688667777886677778866777788667777886888888888888888
-- 182:5555555755555577556666775566667755666677556666775777777777777777
-- 183:ccccccc3cccccc33cc444433cc444433cc444433cc444433c333333333333333
-- 184:dddddddfddddddffddeeeeffddeeeeffddeeeeffddeeeeffdfffffffffffffff
-- 185:bbbbbbb9bbbbbb99bbaaaa99bbaaaa99bbaaaa99bbaaaa99b999999999999999
-- 192:0000000000000000089abbbb89abbbbb89abbbbb089abbbb0000000000000000
-- 193:000000000089abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0089abbb00000000
-- 194:00000000bbbba980bbbbba98bbbbba98bbbbba98bbbbba98bbbba98000000000
-- 195:0000000000000000002344440234444402344444002344440000000000000000
-- 196:0000000000023444444444444444444444444444444444440002344400000000
-- 197:0000000044443200444443204444432044444320444443204444320000000000
-- 198:0000000000000000087655558765577787677755077765560000000000000000
-- 199:0000000000000876557777777755555555555666665555550000087600000000
-- 200:0000000055555555775555555557776566666777555555555555557700000000
-- 201:0000087677777755555555555677556677665655555555577777777700000866
-- 202:5555555555555777666555666656665555555557755555557777755666666665
-- 203:5555555577777777677777665565555555557555777666666666555555555555
-- 204:5756780077777770666656785555567877775777677776786665678055567800
-- 206:5ccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 207:ccccc5558888cc55aaaa0c55888a0c55ccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 208:0000000000000000089abbbb89abbbbb89abbbbb089abbbb0000000000000000
-- 209:000000000000089abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000089a00000000
-- 210:00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
-- 211:0000089abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000089a
-- 212:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 213:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 214:bbba9800bbbba980bbbbba98bbbbba98bbbbba98bbbbba98bbbba980bbba9800
-- 215:0000000000000000002344440234444402344444002344440000000000000000
-- 216:0000000000000023444444444444444444444444444444440000002300000000
-- 217:0000000044444444444444444444444444444444444444444444444400000000
-- 218:0000002344444444444444444444444444444444444444444444444400000023
-- 219:4444444444444444444444444444444444444444444444444444444444444444
-- 220:4444444444444444444444444444444444444444444444444444444444444444
-- 221:4443200044443200444443204444432044444320444443204444320044432000
-- 222:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000ccc5ccccc5c
-- 223:ccca00ccaaaa0cc5caaa0c55aaaa0c55aaaa0c558888cc55000cc555cccc5555
-- 229:5ddddddddd888888d9999999d9888888d9ddddddd9dd0dddd9dd0dddd9dd0ddd
-- 230:ddddd5558888dd5599990d5588890d55ddd90ddd0dd90d0d0dd90d0d0dd90d0d
-- 238:5d5555555eddddde5fdaaaaa50eaacaa55eaac9955e99c9955e99c9955e99888
-- 239:55555555eeeeee55aa999e5599c99f5599c99f5599c88f5598c88f5588888f55
-- 245:d9ddddddd9999999d999d999d9999dddd9999999d8888888dd000ddd5ddddd5d
-- 246:ddd900dd99990dd5d9990d5599990d5599990d558888dd55000dd555dddd5555
-- 254:55eeffff55555ddd55dffddd55dffdde55555eee55555fff55555fe555555eed
-- 255:ffffff55ddd55555deeffd55eeeffd55eee555555ff555555fe555555eed5555
-- </SPRITES>

-- <MAP>
-- 004:00000000000000000000000000313232330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d2d2d300000000000000000000000000000000000000000000000000000616162600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000000000000000000000010000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000200000000000000000000000000000000000000000000010000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:00000000000000000000313233000000003132330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d2d300000000d1d2d300000000000000000000000000000000000000000616260000000006162600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:0000000000000000000111111111111111111111210000000000000000000000000000000000004151511111111191119191a1000000000000000000000000000000000000c1c1c1c1c1c1c1c1c1c1c1c1000000000000000000000000000000000000051515151515151515151505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:00000000000000000003131412121212121204132300000000000000000000000000000000000043541252121212129212842300000000000000000000000000000000000000c2c2c2c2c2c2c2c2c2c200000000000000000000000000000000000000251212071212121207121225000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000000000000000000314121212120423000000000000000000000000000000000000000000431314121212128413a3000000000000000000000000000000000000000000c3c3c3c3c3c3c3c30000000000000000000000000000000000000000051515051212121205151505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000000000000000000000003131313132300000000000000000000000000000000000000000000000003531313132300000000000000000000000000000000000000000000000000c3c3c3c300000000000000000000000000000000000000000000000000251207121225000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051515151505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:1800811c00c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003f
-- </TRACKS>

-- <FLAGS>
-- 000:00000000000000000000000000000000101010201010102010101020102000001010102010101020101010201020000010101020101010201010102010200000101010101010101010101010000000001010100000000000000000000000000020202000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

