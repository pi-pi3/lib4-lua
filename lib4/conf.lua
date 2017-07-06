
function love.conf(t)
    t.identity = 'lib4'
    t.version = '0.10.2'
    t.console = true
    t.accelerometerjoystick = true
    t.externalstorage = true
    t.gammacorrect = true

    t.window.title = 'lib4'
    t.window.icon = nil
    t.window.width = 640
    t.window.height = 360
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = false
    t.window.fullscreentype = 'desktop'
    t.window.vsync = false
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    -- needed modules
    t.modules.system = true
    t.modules.event = true
    t.modules.window = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.math = true

    t.modules.keyboard = true
    t.modules.mouse = true

    t.modules.audio = false
    t.modules.image = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.sound = false
    t.modules.touch = false
    t.modules.video = false
    t.modules.thread = false
end
