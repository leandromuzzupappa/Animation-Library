local TweenService = game:GetService('TweenService')

---
-- Animation class
--
-- @usages
-- local Animation = require(script.Animation)
--
-- Animation:to
-- local animation = Animation:to(object, props, config)
--
-- Animation.fromTo
-- local animation = Animation.fromTo(object, fromProps, toProps, config)
--
-- Animation.new
-- local animation = Animation.new(object, duration, props)
-- animation:setEasingStyle(Enum.EasingStyle.Linear)
-- animation:setEasingDirection(Enum.EasingDirection.InOut)
-- animation:setRepeatCount(1)
-- animation:setReverse(true)
-- animation:setDelayTime(1)
-- animation:onComplete(function() end)
-- animation:play()
---
local Animation = {}

Animation.__index = Animation

---
-- Initializes a new Animation object
--
-- @param object: the object to animate
-- @param duration: the duration of the animation
-- @param props: the properties to animate
-- @return the new Animation object
--
-- @usage
-- local animation = Animation.new(object, 1, {Position = UDim2.new(0, 0, 0, 0)})
---
function Animation.new(object, duration, props)
	local self = setmetatable({}, Animation)

	self.object 			    = object
	self.props 				    = props or {}
	self.startValues 		  = {}
	self.endValues 			  = {}
	self.timeElapsed 		  = 0
	self.duration 			  = duration
	self.easingStyle 		  = Enum.EasingStyle.Linear
	self.easingDirection 	= Enum.EasingDirection.InOut
	self.repeatCount 		  = 0
	self.reverse 			    = false
	self.delayTime			  = 0
	self.onComplete			  = function() end

	-- stores start values for each property to animate
	for prop, endValue in pairs(self.props) do
		self.startValues[prop] = self.object[prop]
		self.endValues[prop] = endValue
	end

	return self
end

-- Setters

---
-- Sets the easing style of the animation
--
-- @param easing: the easing style to use
-- @return void
--
-- @usage
-- animation:setEasingStyle(Enum.EasingStyle.Linear)
--
-- @see https://create.roblox.com/docs/reference/engine/enums/EasingStyle
---
function Animation:setEasingStyle(easing: Enum.EasingStyle)
	self.easingStyle = easing

end

---
-- Sets the easing direction of the animation
--
-- @param easing: the easing direction to use
-- @return void
--
-- @usage
-- animation:setEasingDirection(Enum.EasingDirection.InOut)
--
-- @see https://create.roblox.com/docs/reference/engine/enums/EasingDirection
---
function Animation:setEasingDirection(easing: Enum.EasingDirection)
	self.easingDirection = easing

end

---
-- Sets the repeat count of the animation
--
-- @param value: the repeat count to use
-- @return void
--
-- @usage
-- animation:setRepeatCount(1)
---
function Animation:setRepeatCount(value: number)
	self.repeatCount = value

end

---
-- Sets the reverse of the animation
--
-- @param value: the reverse to use
-- @return void
--
-- @usage
-- animation:setReverse(true)
---
function Animation:setReverse(value)
	self.reverse = value

end

---
-- Sets the delay time (in seconds) of the animation
--
-- @param value: the delay time to use
-- @return void
--
-- @usage
-- animation:setDelayTime(1)
---
function Animation:setDelayTime(value)
	self.delayTime = value
end

---
-- Sets the onComplete callback of the animation
--
-- @param onComplete: the callback to use
-- @return void
--
-- @usage
-- animation:onComplete(function()
-- 	print('Pepitos was here!')
-- end)
---
function Animation:setOnComplete(onComplete)
	self.onComplete = onComplete
end


---
-- Plays the animation
--
-- @return void
--
-- @usage
-- animation:play()
---
function Animation:play()

	local tweenInfo = TweenInfo.new(
		self.duration,
		self.easingStyle,
		self.easingDirection,
		self.repeatCount,
		self.reverse,
		self.delayTime
	)
	self.tween = TweenService:Create(self.object, tweenInfo, self.props)


	self.tween.Completed:Connect(function()
		if self.onComplete then
			self.onComplete()
		end

		self.tween:Destroy()

	end)
	self.tween:Play()

end

---
-- Animation:to function
--
-- @param object: the object to animate
-- @param props: the properties to animate
-- @param config: the configuration of the animation
-- { duration: number?, easingStyle: Enum.EasingStyle?, easingDirection: Enum.EasingDirection?, repeatCount: number?, reverse: boolean?, delayTime: number?, yoyo: boolean?, onComplete: () -> void? }
--
-- @return the new Animation object
--
-- @usage
-- local animation = Animation:to(object, {Position = UDim2.new(0, 0, 0, 0)}, {
-- 	duration = 1,
-- 	easingStyle = Enum.EasingStyle.Linear,
-- 	easingDirection = Enum.EasingDirection.InOut,
-- 	repeatCount = 0,
-- 	reverse = false,
-- 	delayTime = 0,
-- 	yoyo = false,
-- 	onComplete = function() end
-- })
---
function Animation:to(
	object, 
	props: { [string]: any }, 
	config: { 
		duration: number, 
		easingStyle: Enum.EasingStyle,
		easingDirection: Enum.EasingDirection,
		repeatCount: number,
		reverse: boolean,
		delayTime: number,
		yoyo: boolean,
		onComplete: () -> void  
	}
)

	local duration			    = config and config.duration or 1
	local easingStyle		    = config and config.easingStyle or Enum.EasingStyle.Linear
	local easingDirection 	= config and config.easingDirection or Enum.EasingDirection.InOut
	local repeatCount		    = config and config.repeatCount or 0
	local reverse			      = config and config.reverse or false
	local delayTime			    = config and config.delayTime or 0
	local yoyo				      = config and config.yoyo or false
	local onComplete		    = config and config.onComplete

	-- 
	local animation = Animation.new(object, duration, props)

	animation:setEasingStyle(easingStyle)
	animation:setEasingDirection(easingDirection)
	animation:setDelayTime(delayTime)

	-- If yoyo is true then repeatCount and reverse are going to be -1 and true
	animation:setRepeatCount(yoyo and -1 or repeatCount)
	animation:setReverse(yoyo and true or reverse)

	animation:setOnComplete(onComplete)
	animation:play()

	return animation

end

---
-- Animation:fromTo function
--
-- @param object: the object to animate
-- @param fromProps: the properties to animate from
-- @param toProps: the properties to animate to
-- @param config: the configuration of the animation
-- { duration: number?, easingStyle: Enum.EasingStyle?, easingDirection: Enum.EasingDirection?, repeatCount: number?, reverse: boolean?, delayTime: number?, yoyo: boolean?, onComplete: () -> void? }
--
-- @return the new Animation object
--
-- @usage
-- local animation = Animation:from(object, {Position = UDim2.new(0, 0, 0, 0)}, {
-- 	duration = 1,
-- 	easingStyle = Enum.EasingStyle.Linear,
-- 	easingDirection = Enum.EasingDirection.InOut,
-- 	repeatCount = 0,
-- 	reverse = false,
-- 	delayTime = 0,
-- 	yoyo = false,
-- 	onComplete = function() end 
-- })
---
function Animation:fromTo(
	object, 
	fromProps: { [string]: any }, 
	toProps: { [string]: any },
	config: { 
		duration: number, 
		easingStyle: Enum.EasingStyle,
		easingDirection: Enum.EasingDirection,
		repeatCount: number,
		reverse: boolean,
		delayTime: number,
		yoyo: boolean,
		onComplete: () -> void  
	}
)

	local duration			    = config.duration or 1
	local easingStyle		    = config.easingStyle or Enum.EasingStyle.Linear
	local easingDirection 	= config.easingDirection or Enum.EasingDirection.InOut
	local repeatCount		    = config.repeatCount or 0
	local reverse			      = config.reverse or false
	local delayTime			    = config.delayTime or 0
	local yoyo				      = config.yoyo or false
	local onComplete		    = config.onComplete

	-- 
	local animation = Animation.new(object, duration, toProps)

	animation:setEasingStyle(easingStyle)
	animation:setEasingDirection(easingDirection)
	animation:setDelayTime(delayTime)

	-- If yoyo is true then repeatCount and reverse are going to be -1 and true
	animation:setRepeatCount(yoyo and -1 or repeatCount)
	animation:setReverse(yoyo and true or reverse)

	animation:setOnComplete(onComplete)

	-- Set initial values to the object
	for prop, startValue in pairs(fromProps) do
		animation.object[prop] = startValue

	end

	animation:play()

	return animation

end

return Animation