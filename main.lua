local console = require("libreria/console")
local movement = require("libreria/movement")
local texture = require("libreria/texture")
local rain = require("libreria/Rain")
local healthbar = require("libreria/healthbar")
local blood = require("libreria/sangue")
local animation = require("libreria/animations")
function love.load()
math.randomseed(os.time())
love.window.setMode(1600, 720, {
  resizable = false, vsync = true, fullscreen = true
})

  --windfield
  wf = require("libreria/windfield")
  world = wf.newWorld(0,0)
  collisioni = require("libreria/collisioni")
--anim8
anim8 = require("libreria/anim8")
--map
sti = require("libreria/sti")
gamemap = sti('mappa/mappa.lua')
rain.load()
--camera
camera = require"libreria/camera"
cam = camera.new()
--roba per immagini
texture.load()
--zombie
blood.load()
zombies = {}
--proiettile
bullets = {}
bullets.revolver = true
bullets.shotgun = false
--roba puntatore e player
pointer = {}
pointer.x = 200
pointer.y = 200
pointer.speed = 700


player = {}
player.spriteSheet = love.graphics.newImage("sprites/playerwalk.png")
player.x = love.graphics.getWidth()-50
player.y = love.graphics.getHeight()
player.speed = 5000
healthbar.load(player)
animation.load(player,zombies)
movement.load(true,player,pointer,world,zombies)


--roba per lo schermo
start = love.graphics.newFont(30)
bw = sprites.background:getWidth()
bh = sprites.background:getHeight()
--roba per controller
joysticks = love.joystick.getJoysticks()
joystick = joysticks[1]

-- settings
console.load(true)
gamestate = 1
maxtime = 2
timer = maxtime
score = 0
font = love.graphics.newFont(18)
end

function love.update(dt)
healthbar.update(dt)
rain.update(dt)
collisioni.update(dt,world)
--cam movement
cam:lookAt(player.x,player.y)
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()

if cam.x < w/2 then
cam.x = w/2
end
if cam.y < h/2 then
cam.y = h/2
end

if cam.x > (bw - w/2) then
cam.x = (bw - w/2)
end
if cam.y > (bh - h/2) then
cam.y = (bh - h/2)
end


--player movement
animation.update(dt)
if gamestate == 2 then
movement.update(dt)
end
blood.update(dt)
--zombie movement
for i,z in ipairs(zombies) do
z.x = z.x + math.cos(zombierot(z)) * z.speed * dt
z.y = z.y + math.sin(zombierot(z)) * z.speed * dt
  z.collider:setLinearVelocity(z.x,z.y)
if distancebtwn(z.x,z.y,player.x,player.y) < 15 then
blood.bloodspawn(z.x,z.y)
healthbar.damage(5)
if distancebtwn(z.x,z.y,player.x,player.y) < 15 and healthbar.gethealth() <= 0 then
for i,z in ipairs(zombies) do
gamestate = 1
zombies[i] = nil
blood.bloodspawn(z.x,z.y)
player.collider:setLinearVelocity(0,0)
player.collider.x = love.graphics.getWidth()-50
player.collider.y = love.graphics.getHeight()
end
end
end
end



--bullet movement
for i,b in ipairs(bullets) do
b.x = b.x + math.cos(b.direction) * b.speed * dt
b.y = b.y + math.sin(b.direction) * b.speed * dt
end
for i=#bullets, 1, -1 do
local b = bullets[i]
if b.x < bw-bh or b.y < bh-bh or b.x > bw or b.y > bh then
table.remove(bullets, i)
end
end

for i,z in ipairs(zombies) do
for j,b in ipairs(bullets) do
if distancebtwn(z.x,z.y,b.x,b.y) < 15 then
z.death = true
b.death = true
z.collider:destroy()
blood.bloodspawn(z.x,z.y)
score = score + 1
end
end
end
for i=#zombies,1,-1 do
local z = zombies[i]
if z.death == true then
table.remove(zombies, i)
end
end
for i=#bullets,1,-1 do
local b = bullets[i]
if b.death == true then
table.remove(bullets, i)
end
end

if gamestate == 2 then
timer = timer - dt
if timer <= 0 then
zombiespawn()
maxtime = 0.95 ^ maxtime
timer = maxtime
end
end
-- console
console.update(dt)
--proiettili a schermo
numerobullet = ("numero bullets: " .. tostring(#bullets))
numerozoombie = ("numero zombie: " .. tostring(#zombies))

end

function love.gamepadpressed(joystick, button)
if button == "a" and gamestate == 1 then
gamestate = 2
maxtime = 2
timer = maxtime
score = 0
player.collider:setPosition(love.graphics.getWidth()-50, love.graphics.getHeight())
healthbar.setHealth(100)


end
if button == "rightshoulder" and gamestate == 2 then
bullets.randomico = 1
bulletspawn()
end
if button == "leftshoulder" and gamestate == 2 then
bullets.randomico = 2
bulletspawn()
end
end

function love.draw()

cam:attach()
local scale = 4
love.graphics.push()
love.graphics.scale(scale)
gamemap:drawLayer(gamemap.layers["Tile 1"])
gamemap:drawLayer(gamemap.layers["sangue"])
love.graphics.pop()
animation.playerdraw(player.x, player.y, rotazioneplayer(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
animation.zombdraw()
for i,b in ipairs(bullets) do
if bullets.randomico == 1 then
texture.draw(sprites.bullet, b.x, b.y, rotazioneplayer(), nil, nil, sprites.bullet:getWidth()/2,-14)
end
if bullets.randomico == 2 then
texture.draw(sprites.bullet, b.x, b.y, rotazioneplayer(), nil, nil, sprites.bullet:getWidth()/2,14)
end
end
love.graphics.setColor(1,1,1,0.5)
love.graphics.push()
love.graphics.scale(scale)
gamemap:drawLayer(gamemap.layers["altr"])
gamemap:drawLayer(gamemap.layers["Layer 4"])
love.graphics.pop()
love.graphics.setColor(1,1,1,1)

if gamestate == 1 then
love.graphics.setFont(start)
love.graphics.printf("schiaccia X per cominciare",cam.x - 360, cam.y -92, love.graphics.getWidth(), "center")
end
love.graphics.setFont(font)
love.graphics.print("punti: " ..score, cam.x+300, cam.y-love.graphics.getHeight()/2)
for i,s in ipairs(bloods) do
blood.draw(sprites.blood,s.x, s.y)
end
collisioni.draw(world)
cam:detach()
console.draw()
healthbar.draw()
rain.draw()
console.drew()
if gamestate == 2 then
love.graphics.draw(sprites.pointer,pointer.x - 20, pointer.y)
end
end

function rotazioneplayer ()
local mx, my = cam:worldCoords(pointer.x, pointer.y)
return math.atan2(my - player.y, mx - player.x)
end

function zombierot(enemy)
return math.atan2(player.y - enemy.y, player.x - enemy.x)
end


function bulletspawn()
local bullet = {}
bullet.randomico = 0
bullet.x = player.x
bullet.y = player.y
bullet.speed = 1000
bullet.death = false
bullet.direction = rotazioneplayer()
table.insert(bullets, bullet)
end

function distancebtwn(x1,y1,x2,y2)
return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end