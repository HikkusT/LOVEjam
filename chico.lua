debug = true

-- Player's stuff
-- Player atributes storage
player = { x = love.graphics.getWidth()/2, y = love.graphics.getHeight()-100, speed = 250, img = nil }
score = 0
isAlive = true

-- Bullet's stuff
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated

-- Enemy's stuff
--More timers
createEnemyTimerMax = 1.5
createEnemyTimer = createEnemyTimerMax

-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function

-- More storage
enemies = {} -- array of current enemies on screen

-- Animation attributes
-- Global Storage
animations = {}

function love.load(arg)
  LoadImages()
  LoadSounds()
  LoadAnimations()
end

-- Updating
function love.update(dt)
  InputHandle(dt)
  AttackManagement(dt)
  EnemyManagement(dt)
  --CollisionsManagement()

  -- Dying-and-reseting stuff
  if not isAlive and love.keyboard.isDown('r') then
    ResetScene()
  end

  -- Animation stuff
  UpdateAnimations(dt)

end -- of update method

function love.draw(dt)
  -- Player
  if isAlive then
	   love.graphics.draw(player.img, player.x, player.y)
   else
	    love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

  -- Bullets
    for i, bullet in ipairs(bullets) do
      love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

  -- Enemies
    for i, enemy in ipairs(enemies) do
	     love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end

    -- score
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("SCORE: " .. tostring(score), love.graphics.getWidth()/2, 10)

    -- Animation stuff
    for i, animation in ipairs(animations) do
      local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
      love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 0, 0, 0, 4)
    end
end  -- end drawn function

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function ResetScene()
  	-- remove all our bullets and enemies from screen
  	bullets = {}
  	enemies = {}

  	-- reset timers
  	canShootTimer = canShootTimerMax
  	createEnemyTimer = createEnemyTimerMax

  	-- move player back to default position
  	player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()-100

  	-- reset our game state
  	score = 0
  	isAlive = true

    -- animation reseting
    for i, animation in ipairs(animations) do
      animation.currentTime = 0
    end
end

function LoadImages()
    player.img = love.graphics.newImage('assets/Aircraft_03.png')
    --we now have an asset ready to be used inside Love

    bulletImg = love.graphics.newImage('assets/bullet_2_blue.png')
    enemyImg = love.graphics.newImage('assets/Aircraft_08.png')
end

function LoadSounds()
  --gunSound = love.audio.newSource("assets/gun-sound.wav", "static")
end

function LoadAnimations()
  -- Animation stuff
  playerAnimation = newAnimation(love.graphics.newImage("assets/oldHero.png"), 16, 18, 1)
  table.insert(animations, playerAnimation)
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function UpdateAnimations(dt)
      for i, animation in ipairs(animations) do
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
      end
end

function InputHandle (dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

  -- Horizontal movement
  if love.keyboard.isDown('left','a') then
	  if player.x > 0 then -- binds us to the map
		     player.x = player.x - (player.speed*dt)
    end
  elseif love.keyboard.isDown('right','d') then
	     if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
		       player.x = player.x + (player.speed*dt)
	     end
  end

  -- Vertical movement
  if love.keyboard.isDown('up', 'w') then
  	if player.y > 10 then
  		player.y = player.y - (player.speed*dt)
  	end
  elseif love.keyboard.isDown('down', 's') then
  	if player.y < (love.graphics.getHeight() - player.img:getHeight()) then
  		player.y = player.y + (player.speed*dt)
  	end
  end

  -- Shooting
  if love.keyboard.isDown('space', 'e') and canShoot then
  	-- Create some bullets
  	newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
  	table.insert(bullets, newBullet)
    --NEW LINE
      --gunSound:play()
    --END NEW
  	canShoot = false
  	canShootTimer = canShootTimerMax
  end
end

function AttackManagement(dt)
  -- Time out how far apart our shots can be.
  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot = true
  end

  -- update the positions of bullets
  for i, bullet in ipairs(bullets) do
  	bullet.y = bullet.y - (300 * dt)

    	if bullet.y < 0 then -- remove bullets when they pass off the screen
  		table.remove(bullets, i)
  	end
  end
end

function EnemyManagement(dt)
  -- For enemies
  if isAlive then
    -- Time out enemy creation
    createEnemyTimer = createEnemyTimer - (1 * dt)
    if createEnemyTimer < 0 then
    	createEnemyTimer = createEnemyTimerMax

    	-- Create an enemy
      	randomNumber = math.random(10, love.graphics.getWidth() - enemyImg:getWidth() - 10)
      	newEnemy = { x = randomNumber, y = -10, img = enemyImg }
      	table.insert(enemies, newEnemy)
    end

    -- update the positions of enemies
    for i, enemy in ipairs(enemies) do
    	enemy.y = enemy.y + (200 * dt)

    	if enemy.y > love.graphics.getHeight() + 10 then -- remove enemies when they pass off the screen
    		table.remove(enemies, i)
    	end
    end
  end
end

function CollisionsManagement()
  -- run our collision detection
  -- Since there will be fewer enemies on screen than bullets we'll loop them first
  -- Also, we need to see if the enemies hit our player
  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      -- Enemy x bullets
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth()-10, enemy.img:getHeight()-10, bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        score = score + 1
      end
    end

    -- Enemy x player
    if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth()-10, enemy.img:getHeight()-10, player.x, player.y, player.img:getWidth()-10, player.img:getHeight()-10)
    and isAlive then
      table.remove(enemies, i)
      isAlive = false
    end
  end
end
