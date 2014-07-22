voronoi = require "voronoi"
require "polygon"

local function drawPolygon (vertices)
		local poly = {}
		if type(vertices) ~= "table" then
			return
		end
		for _, v in ipairs(vertices) do
			table.insert(poly, v.x)
			table.insert(poly, v.y)
		end
		if #poly >= 6 then
			love.graphics.polygon("fill", unpack(poly))
		end
end

function love.load()
	

	points_list = {}
	points_update = {}

	X0 = 0
	X1 = 1000
	Y0 = 0
	Y1 = 800
	bounding_edge = 50
	love.window.setMode(X1, Y1)
	NUMPOINT = 100
	upd = true

	--Point that share the exact same coordinates can cause problems; adding a random decimal is a quick fix.
	for i = 1,NUMPOINT do
		points_list[i] = {x = math.random(X0,X1) + math.random(),y = math.random(Y0,Y1) + math.random()}
		points_update[i] = {dx = math.random(-2,2), dy = math.random(-2,2)}
	end
	
	vertex, segments, sites = voronoi(points_list, bounding_edge, X0, Y0, X1, Y1)
end

function love.keypressed(key)
	if key =="l" then
		for i=1, #sites do
			print("site, " .. sites[i].x, sites[i].y)
			printPolygon(sites[i].vertices)
		end
	elseif key == "u" then
		upd = not upd
	end
    for i = 1,#points_list do

	end
end

function love.update(dt)
	mx, my = love.mouse.getPosition()
end

function love.draw()
		vertex, segments, sites = voronoi(points_list, bounding_edge, X0, Y0, X1, Y1)
	
	--Update point positions
    for i = 1,#points_list do 
    	if upd then
			points_list[i].x =  points_list[i].x + points_update[i].dx
			if points_list[i].x < X0 then
				points_list[i].x = X0
				points_update[i].dx = -1*points_update[i].dx
			end
			if points_list[i].x > X1 then
				points_list[i].x = X1
				points_update[i].dx = -1*points_update[i].dx
			end
		
			points_list[i].y =  points_list[i].y + points_update[i].dy
			if points_list[i].y < Y0 then
				points_list[i].y = Y0
				points_update[i].dy = -1*points_update[i].dy
			end
			if points_list[i].y > Y1 then
				points_list[i].y = Y1
				points_update[i].dy = -1*points_update[i].dy
			end       
		end
        love.graphics.setColor(0,255,0,255)
        love.graphics.circle("fill", points_list[i].x,points_list[i].y, 5)
    end
    
    love.graphics.setColor(255, 255, 255, 128)
    local poly, i = findContainingPolygon(mx, my, sites, "vertices")
    drawPolygon(poly)
    if sites[i] then
		love.graphics.setColor(200, 200, 200, 128)
		for j=1, #sites[i].neighbors do
			drawPolygon(sites[i].neighbors[j].vertices)
		end
	end	

    --Draw the vertex and line segments
	for i = 1, #vertex do
		love.graphics.setColor(0,0, 255,255)
		love.graphics.circle("fill",vertex[i].x,vertex[i].y, 5)
		love.graphics.setColor(255,255,255)
		--for k,v in pairs(vertex[i].sites) do
--			love.graphics.line(v.x, v.y, vertex[i].x, vertex[i].y)
--		end
	end
	for i = 1,#segments do
        if segments[i].done then
        	love.graphics.setColor(255,0,0, 255)
        	love.graphics.line(segments[i].startPoint.x,segments[i].startPoint.y,segments[i].endPoint.x,segments[i].endPoint.y)
        end    
    end
    for i =1, #sites do
    	love.graphics.setColor(255-i*10, i*10, i*20, 100)
    	drawPolygon(sites[i].vertices)
    end
end