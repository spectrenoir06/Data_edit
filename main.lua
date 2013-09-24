
require "/lib/json/json"
gamestate = require "/lib/hump/gamestate"

map_editor= {}
ui = {}

function love.load()
	gamestate.registerEvents()
	gamestate.switch(ui)
end

------------------------------ui---------------------------------------------

function ui:init()
	love.graphics.setBackgroundColor( 200, 200, 200 )
	data={}
	data = json.decode(love.filesystem.read( "data/data.json", nil ))
	require "/lib/Gui/"
	
	frame = loveframes.Create("frame")
	frame:SetSize(500, 300)
	frame:Center()
	frame:SetName("Frame 1")
	
	multichoice = loveframes.Create("multichoice",frame)
	multichoice:SetPos(5, 30)
	
	
	for i=1,#data.pnj do
		multichoice :AddChoice(i)
	end
	
	multichoice:SetChoice("1")
	skin = loveframes.Create("image",frame)
	skin:SetImage("icone.png")
	skin:SetPos(5, 60)
	
	text_name = loveframes.Create("text",frame)
	text_name:SetPos(75, 90)
	text_name:SetMaxWidth(100)
	
	button_name = loveframes.Create("button",frame)
	button_name:SetSize(100, 15)
	button_name:SetPos(350, 90)
	button_name:SetText("edit")
	function button_name:OnClick()
		print("name was clicked!")
	end

	
	text_skin = loveframes.Create("text",frame)
	text_skin:SetPos(75, 110)
	text_skin:SetMaxWidth(100)
	
	button_skin = loveframes.Create("button",frame)
	button_skin:SetSize(100, 15)
	button_skin:SetPos(350, 110)
	button_skin:SetText("edit")
	function button_skin:OnClick()
		print("skin was clicked!")
	end
	
	text_str = loveframes.Create("text",frame)
	text_str:SetPos(75, 130)
	text_str:SetMaxWidth(100)

end

function ui:update(dt)

	nb = tonumber(multichoice:GetValue())
	skin:SetImage("/textures/64/"..data.pnj[nb].skin)
	text_name:SetText("Name : "..data.pnj[nb].name)
	text_skin:SetText("Skin : "..data.pnj[nb].skin)
	text_str:SetText("talk str :"..data.pnj[nb].talk_str)

	loveframes.update(dt)
end

function ui.draw()
	loveframes.draw()
end

function ui:mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function ui:mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end


function ui:keypressed(key)
    -- if key == "q" then
		-- save = json.encode(data)
		-- love.filesystem.remove( "data.json" )
		-- love.filesystem.write( "data.json", save)
		-- love.event.push("quit")
	-- end
	loveframes.keypressed(key, unicode)
end

function ui:keyreleased(key)
	loveframes.keyreleased(key)
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