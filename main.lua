
require "/lib/json/json"
gamestate = require "/lib/hump/gamestate"

map_editor= {}
test = {}

function love.load()
	gamestate.registerEvents()
	gamestate.switch(test)
end

------------------------------test---------------------------------------------

function test:init()
	
	data={}
	data = json.decode(love.filesystem.read( "data/data.json", nil ))

end

function test:keypressed(key)
    if key == "q" then
		save = json.encode(data)
		love.filesystem.remove( "data.json" )
		love.filesystem.write( "data.json", save)
		love.event.push("quit")
	end
end

--------------------------Map editor----------------------------------------------
	
function map_editor:init()
	if not love.filesystem.exists( "/data_tile.json" ) then
		love.filesystem.write( "/data_tile.json", '{"1":{"type":"sol","pass":true}}')
	end
	contents, size = love.filesystem.read( "/data_tile.json", nil )
	tab = json.decode(contents)
	image = love.graphics.newImage( "tileset.png" )
	cache = love.graphics.newImage( "cache.png" )
end

function map_editor:draw()
   love.graphics.draw( image,0,0)
   love.graphics.draw( cache,0,0)
   for k,v in pairs(tab) do
	love.graphics.print( k+1 , (k%30)*64+10 , math.floor(k/30)*64+5)
		if v.pass then
			love.graphics.print( "true", (k%30)*64+10 , math.floor(k/30)*64+20)
		else
			love.graphics.print( "false", (k%30)*64+10 , math.floor(k/30)*64+20)
		end
		if v.type then
			love.graphics.print( v.type, (k%30)*64+10 , math.floor(k/30)*64+35)
		end
   end
end

function map_editor:update(dt)

end

function map_editor:mousepressed(x, y, button)
	nb = (math.floor(x/64)+math.floor(y/64)*30)+1
   if button == "l" then
		if tab[tostring(nb-1)] then
			if tab[tostring(nb-1)].pass then
				tab[tostring(nb-1)].pass = false
			else
				tab[tostring(nb-1)].pass = true
			end
			print(nb,tab[tostring(nb-1)].pass,tab[tostring(nb-1)].type)
		else
			tab[tostring(nb-1)] = {}
			tab[tostring(nb-1)].pass = true
			tab[tostring(nb-1)].type = "sol"
			print(nb,tab[tostring(nb-1)].pass,tab[tostring(nb-1)].type)
		end
	elseif button == "r" then
		if tab[tostring(nb-1)] then
			if tab[tostring(nb-1)].type == "sol" then
				tab[tostring(nb-1)].type = "block"
			elseif tab[tostring(nb-1)].type == "block" then
				tab[tostring(nb-1)].type = "deco"
			elseif tab[tostring(nb-1)].type == "deco" then
				tab[tostring(nb-1)].type = "sol"
			end
			print(nb,tab[tostring(nb-1)].pass,tab[tostring(nb-1)].type)
		else
			tab[tostring(nb-1)] = {}
			tab[tostring(nb-1)].pass = true
			tab[tostring(nb-1)].type = "sol"
			print(nb,tab[tostring(nb-1)].pass,tab[tostring(nb-1)].type)
		end
	end
end
    
function map_editor:keypressed(key)
    if key == "q" then
		
		save = json.encode(tab)
		love.filesystem.remove( "/data.json" )
		love.filesystem.write( "/data.json", save)
		love.event.push("quit")
	end
end

----------------------------------------------------------------------------------