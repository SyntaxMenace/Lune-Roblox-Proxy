-- MIT License | Copyright (c) 2023 Latte Softworks <https://latte.to>

-- WARNING: This file was slightly modified while development, please view latte's original file in github. 

local stdio = require("@lune/stdio")

local ANSI = {
    Reset = stdio.color("reset") .. stdio.style("reset"),

    Red = stdio.color("red"),
    Blue = stdio.color("blue"),
    Yellow = stdio.color("yellow"),

    Bold = stdio.style("bold"),
}

local Log = {}

function Log.Info(message: string, ending: string?)
    ending = ending or "\n"
    stdio.write(`{ANSI.Bold .. ANSI.Blue}Info ∙{ANSI.Reset} {message}{ending}`)
end

function Log.Error(message: string, ending: string?)
    ending = ending or "\n"
    stdio.ewrite(`{ANSI.Bold .. ANSI.Red}∙ {message}{ANSI.Reset}{ending}`)
end

function Log.Warn(message: string, ending: string?)
    ending = ending or "\n"
    stdio.write(`{ANSI.Bold .. ANSI.Yellow}∙ {message}{ANSI.Reset}{ending}`)
end

function Log.InternalError(message: string, ending: string?)
    Log.Error("[INTERNAL ERROR] " .. message, ending)
end

return Log