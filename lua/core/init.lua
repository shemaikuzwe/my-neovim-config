local function init()
    require('core.vim').init()
    require('core.keymaps').init()
    require('core.theme').init()
    require('core.languages').init()
    require('core.telescope').init()
    require('core.floaterm').init()
    require('core.assistant').init()
    require('core.explorer').init()
end

return {
    init = init,
}
