vim.cmd [[highlight clear]]

local config = {
  italics = {
    comments = true,
    strings = false,
    keywords = true,
    functions = true,
    variables = false,
  },
}

local utils = {}

local function hex_to_rgb(hex)
  local hex_type = '[abcdef0-9][abcdef0-9]'
  local pat = '^#(' .. hex_type .. ')(' .. hex_type .. ')(' .. hex_type .. ')$'
  hex = string.lower(hex)

  assert(string.find(hex, pat) ~= nil, 'hex_to_rgb: invalid hex: ' .. tostring(hex))

  local red, green, blue = string.match(hex, pat)
  return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

function utils.mix(fg, bg, alpha)
  ---@diagnostic disable-next-line: cast-local-type
  bg = hex_to_rgb(bg)
  ---@diagnostic disable-next-line: cast-local-type
  fg = hex_to_rgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02X%02X%02X', blendChannel(1), blendChannel(2), blendChannel(3))
end

function utils.shade(color, value, base)
  if vim.o.background == 'light' then
    if base == nil then
      base = '#000000'
    end

    return utils.mix(color, base, math.abs(value))
  else
    if base == nil then
      base = '#ffffff'
    end

    return utils.mix(color, base, math.abs(value))
  end
end

function utils.hsl(h, s, l)
  s = s / 100
  l = l / 100

  local c = (1 - math.abs(2 * l - 1)) * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = l - c / 2

  local r, g, b = 0, 0, 0

  if h < 60 then
    r, g, b = c, x, 0
  elseif h < 120 then
    r, g, b = x, c, 0
  elseif h < 180 then
    r, g, b = 0, c, x
  elseif h < 240 then
    r, g, b = 0, x, c
  elseif h < 300 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end

  -- Convert RGB [0,1] to [0,255], apply m
  r = math.floor((r + m) * 255 + 0.5)
  g = math.floor((g + m) * 255 + 0.5)
  b = math.floor((b + m) * 255 + 0.5)

  -- Return HEX string
  return string.format('#%02X%02X%02X', r, g, b)
end

local colors = {
  editorBackground = '#09090B',
  popupBackground = '#27272A',
  menuOptionBackground = '#2B2B2B',

  mainText = '#EDEDED',
  inactiveText = '#A3A3A3',
  lineNumberText = '#4D4D4D',
  lineNumberTextActive = '#F2F2F2',
  selectedText = '#EDEDED',
  border = '#212121',

  syntaxConstant = '#52A8FF',
  syntaxKeyword = '#F75F8F',
  syntaxFunction = '#BF7AF0',
  syntaxProperty = '#EDEDED',

  errorText = '#D14E42',
  warningText = '#EBCA89',
  commentText = '#A3A3A3',
  stringText = '#62C073',
  successText = '#16A34A',

  highlight = '#005BE7',
  directory = '#52A8FF',
}

local bg = colors.editorBackground
local diff_add = utils.shade(colors.successText, 0.5, colors.editorBackground)
local diff_delete = utils.shade(colors.syntaxKeyword, 0.5, colors.editorBackground)
local diff_change = utils.shade(colors.syntaxFunction, 0.5, colors.editorBackground)
local diff_text = utils.shade(colors.syntaxProperty, 0.5, colors.editorBackground)

-- ------------------------------------------------------
-- base
-- ------------------------------------------------------
local groups = {
  -- base
  Normal = { fg = colors.mainText, bg = bg },
  LineNrAbove = { fg = colors.lineNumberText },
  LineNr = { fg = colors.lineNumberTextActive },
  LineNrBelow = { fg = colors.lineNumberText },
  ColorColumn = {
    bg = utils.shade(colors.stringText, 0.5, colors.editorBackground),
  },
  Conceal = {},
  Cursor = { fg = colors.editorBackground, bg = colors.mainText },
  lCursor = { link = 'Cursor' },
  CursorIM = { link = 'Cursor' },
  CursorLine = { bg = colors.popupBackground },
  CursorColumn = { link = 'CursorLine' },
  Directory = { fg = colors.directory },
  DiffAdd = { bg = bg, fg = diff_add },
  DiffChange = { bg = bg, fg = diff_change },
  DiffDelete = { bg = bg, fg = diff_delete },
  DiffText = { bg = bg, fg = diff_text },
  EndOfBuffer = { fg = colors.syntaxConstant },
  TermCursor = { link = 'Cursor' },
  TermCursorNC = { link = 'Cursor' },
  ErrorMsg = { fg = colors.syntaxKeyword },
  VertSplit = { fg = colors.border, bg = 'NONE' },
  Winseparator = { link = 'VertSplit' },
  SignColumn = { link = 'Normal' },
  Folded = { fg = colors.mainText, bg = colors.popupBackground },
  FoldColumn = { link = 'SignColumn' },
  IncSearch = {
    bg = utils.mix(colors.syntaxConstant, colors.editorBackground, math.abs(0.30)),
    fg = colors.editorBackground,
  },
  Substitute = { link = 'IncSearch' },
  CursorLineNr = { fg = colors.commentText },
  MatchParen = { fg = colors.syntaxKeyword },
  ModeMsg = { link = 'Normal' },
  MsgArea = { link = 'Normal' },
  -- MsgSeparator = {},
  MoreMsg = { fg = colors.syntaxConstant },
  NonText = { fg = colors.lineNumberText },
  NormalFloat = { bg = bg },
  FloatBorder = { fg = colors.border },
  NormalNC = { link = 'Normal' },
  Pmenu = { link = 'NormalFloat' },
  PmenuSel = { bg = colors.menuOptionBackground },
  PmenuSbar = {
    bg = utils.shade(colors.editorBackground, 0.5, colors.editorBackground),
  },
  PmenuThumb = { bg = utils.shade(colors.editorBackground, 0.20) },
  Question = { fg = colors.syntaxFunction },
  QuickFixLine = { fg = colors.syntaxFunction },
  SpecialKey = { fg = colors.syntaxProperty },
  StatusLine = { fg = colors.mainText, bg = bg },
  StatusLineNC = {
    fg = colors.inactiveText,
    bg = colors.editorBackground,
  },
  TabLine = {
    bg = colors.editorBackground,
    fg = colors.inactiveText,
  },
  TabLineFill = { link = 'TabLine' },
  TabLineSel = {
    bg = colors.editorBackground,
    fg = colors.mainText,
  },
  Search = { bg = utils.shade(colors.stringText, 0.70, colors.bg) },
  SpellBad = { undercurl = true, sp = colors.syntaxKeyword },
  SpellCap = { undercurl = true, sp = colors.syntaxFunction },
  SpellLocal = { undercurl = true, sp = colors.syntaxConstant },
  SpellRare = { undercurl = true, sp = colors.warningText },
  Title = { fg = colors.syntaxConstant, bold = true },
  Visual = {
    bg = colors.highlight,
  },
  VisualNOS = { link = 'Visual' },
  WarningMsg = { fg = colors.warningText },
  Whitespace = { fg = colors.editorBackground },
  WildMenu = { bg = colors.menuOptionBackground },
  Comment = {
    fg = colors.commentText,
    italic = config.italics.comments or false,
  },

  Constant = { fg = colors.syntaxConstant },
  String = {
    fg = colors.stringText,
    italic = config.italics.strings or false,
  },
  Character = { fg = colors.stringText },
  Number = { fg = colors.syntaxConstant },
  Boolean = { fg = colors.syntaxConstant },
  Float = { link = 'Number' },

  Identifier = { fg = colors.mainText },
  Function = { fg = colors.syntaxFunction },
  Method = { fg = colors.syntaxConstant },
  Property = { fg = colors.syntaxKeyword },
  Field = { link = 'Property' },
  Parameter = { fg = colors.syntaxConstant },
  Statement = { fg = colors.syntaxKeyword },
  Conditional = { fg = colors.syntaxKeyword },
  -- Repeat = {},
  Label = { fg = colors.syntaxFunction },
  Operator = { fg = colors.syntaxKeyword },
  Keyword = { link = 'Statement', italic = config.italics.keywords or false },
  Exception = { fg = colors.syntaxKeyword },

  PreProc = { link = 'Keyword' },
  -- Include = {},
  Define = { fg = colors.syntaxConstant },
  Macro = { link = 'Define' },
  PreCondit = { fg = colors.syntaxKeyword },

  Type = { fg = colors.syntaxConstant },
  Struct = { link = 'Type' },
  Class = { link = 'Type' },

  -- StorageClass = {},
  -- Structure = {},
  -- Typedef = {},

  Attribute = { link = 'Character' },
  Punctuation = { fg = colors.syntaxProperty },
  Special = { fg = colors.syntaxProperty },

  SpecialChar = { fg = colors.syntaxKeyword },
  Tag = { fg = colors.stringText },
  Delimiter = { fg = colors.syntaxProperty },
  -- SpecialComment = {},
  Debug = { fg = colors.mainText },

  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },
  Ignore = { fg = colors.editorBackground },
  Error = { link = 'ErrorMsg' },
  Todo = { fg = colors.warningText, bold = true },

  -- LspReferenceText = {},
  -- LspReferenceRead = {},
  -- LspReferenceWrite = {},
  -- LspCodeLens = {},
  -- LspCodeLensSeparator = {},
  -- LspSignatureActiveParameter = {},

  DiagnosticError = { link = 'Error' },
  DiagnosticWarn = { link = 'WarningMsg' },
  DiagnosticInfo = { fg = colors.syntaxFunction },
  DiagnosticHint = { fg = colors.syntaxConstant },
  DiagnosticVirtualTextError = { link = 'DiagnosticError' },
  DiagnosticVirtualTextWarn = { link = 'DiagnosticWarn' },
  DiagnosticVirtualTextInfo = { link = 'DiagnosticInfo' },
  DiagnosticVirtualTextHint = { link = 'DiagnosticHint' },
  DiagnosticUnderlineError = { undercurl = true, link = 'DiagnosticError' },
  DiagnosticUnderlineWarn = { undercurl = true, link = 'DiagnosticWarn' },
  DiagnosticUnderlineInfo = { undercurl = true, link = 'DiagnosticInfo' },
  DiagnosticUnderlineHint = { undercurl = true, link = 'DiagnosticHint' },
  -- DiagnosticFloatingError = {},
  -- DiagnosticFloatingWarn = {},
  -- DiagnosticFloatingInfo = {},
  -- DiagnosticFloatingHint = {},
  -- DiagnosticSignError = {},
  -- DiagnosticSignWarn = {},
  -- DiagnosticSignInfo = {},
  -- DiagnosticSignHint = {},

  ['@text'] = { fg = colors.mainText },
  ['@texcolorscheme.literal'] = { link = 'Property' },
  -- ["@texcolorscheme.reference"] = {},
  ['@texcolorscheme.strong'] = { link = 'Bold' },
  ['@texcolorscheme.italic'] = { link = 'Italic' },
  ['@texcolorscheme.title'] = { link = 'Keyword' },
  ['@texcolorscheme.uri'] = {
    fg = colors.syntaxFunction,
    sp = colors.syntaxFunction,
    underline = true,
  },
  ['@texcolorscheme.underline'] = { link = 'Underlined' },
  ['@symbol'] = { fg = colors.syntaxProperty },
  ['@texcolorscheme.todo'] = { link = 'Todo' },
  ['@comment'] = { link = 'Comment' },
  ['@punctuation'] = { link = 'Punctuation' },
  ['@punctuation.bracket'] = { fg = colors.mainText },
  ['@punctuation.delimiter'] = { fg = colors.syntaxKeyword },
  ['@punctuation.terminator.statement'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { fg = colors.syntaxKeyword },
  ['@punctuation.separator.keyvalue'] = { fg = colors.syntaxKeyword },

  ['@texcolorscheme.diff.add'] = { fg = colors.successText },
  ['@texcolorscheme.diff.delete'] = { fg = colors.errorText },

  ['@constant'] = { link = 'Constant' },
  ['@constant.builtin'] = { fg = colors.syntaxFunction },
  ['@constancolorscheme.builtin'] = { link = 'Keyword' },
  -- ["@constancolorscheme.macro"] = {},
  -- ["@define"] = {},
  -- ["@macro"] = {},
  ['@string'] = { link = 'String' },
  ['@string.escape'] = { fg = utils.shade(colors.stringText, 0.45) },
  ['@string.special'] = { fg = utils.shade(colors.syntaxFunction, 0.45) },
  -- ["@character"] = {},
  -- ["@character.special"] = {},
  ['@number'] = { link = 'Number' },
  ['@number.tsx'] = { link = 'Constant' },
  ['@boolean'] = { link = 'Boolean' },
  -- ["@float"] = {},
  ['@function'] = {
    link = 'Function',
    italic = config.italics.functions or false,
  },
  ['@function.call'] = { link = 'Function' },
  ['@function.builtin'] = { link = 'Function' },
  -- ["@function.macro"] = {},
  ['@parameter'] = { link = 'Parameter' },
  ['@method'] = { link = 'Function' },
  ['@field'] = { link = 'Property' },
  ['@property'] = { link = 'Property' },
  ['@constructor'] = { fg = colors.syntaxFunction },
  -- ["@conditional"] = {},
  -- ["@repeat"] = {},
  ['@label'] = { link = 'Label' },
  ['@operator'] = { link = 'Operator' },
  ['@exception'] = { link = 'Exception' },
  ['@variable'] = {
    fg = colors.mainText,
    italic = config.italics.variables or false,
  },
  ['@variable.builtin'] = { fg = colors.syntaxConstant },
  ['@variable.member'] = { fg = colors.mainText },
  ['@variable.parameter'] = {
    fg = colors.mainText,
    italic = config.italics.variables or false,
  },
  ['@type'] = { link = 'Type' },
  ['@type.definition'] = { fg = colors.mainText },
  ['@type.builtin'] = { fg = colors.syntaxConstant },
  ['@type.qualifier'] = { fg = colors.syntaxFunction },
  ['@type.tsx'] = { fg = colors.mainText },
  ['@keyword'] = { link = 'Keyword' },
  -- ["@storageclass"] = {},
  -- ["@structure"] = {},
  ['@namespace'] = { link = 'Type' },
  ['@annotation'] = { link = 'Label' },
  -- ["@include"] = {},
  -- ["@preproc"] = {},
  ['@debug'] = { fg = colors.mainText },
  ['@tag'] = { link = 'Tag' },
  ['@tag.builtin'] = { link = 'Tag' },
  ['@tag.delimiter'] = { fg = colors.syntaxProperty },
  ['@tag.attribute'] = { fg = colors.syntaxFunction },
  ['@tag.jsx.element'] = { fg = colors.syntaxFunction },
  ['@tag.tsx'] = { fg = colors.syntaxConstant },
  ['@attribute'] = { fg = colors.syntaxConstant },
  ['@error'] = { link = 'Error' },
  ['@warning'] = { link = 'WarningMsg' },
  ['@info'] = { fg = colors.syntaxFunction },

  -- Specific languages
  -- overrides
  ['@label.json'] = { fg = colors.syntaxProperty }, -- For json
  ['@label.help'] = { link = '@texcolorscheme.uri' }, -- For help files
  ['@texcolorscheme.uri.html'] = { underline = true }, -- For html
  ['@markup.heading'] = { fg = colors.mainText, bold = true }, -- For markdown

  -- semantic highlighting
  ['@lsp.type.namespace'] = { link = '@namespace' },
  ['@lsp.type.type'] = { link = '@function' },
  ['@lsp.type.class'] = { link = '@type' },
  ['@lsp.type.enum'] = { link = '@type' },
  ['@lsp.type.enumMember'] = { fg = colors.syntaxFunction },
  ['@lsp.type.interface'] = { link = '@function' },
  ['@lsp.type.struct'] = { link = '@type' },
  ['@lsp.type.parameter'] = { link = '@parameter' },
  ['@lsp.type.property'] = { link = '@text' },
  ['@lsp.type.function'] = { link = '@function' },
  ['@lsp.type.method'] = { link = '@method' },
  ['@lsp.type.macro'] = { link = '@label' },
  ['@lsp.type.decorator'] = { link = '@label' },
  ['@lsp.type.variable'] = { link = '@text' },
  ['@lsp.typemod.function'] = { link = '@function' },
  ['@lsp.typemod.parameter.declaration'] = { link = '@text' },
  ['@lsp.typemod.variable.readonly'] = { link = '@text' },
  ['@lsp.typemod.variable.declaration'] = { fg = colors.syntaxConstant },
}

for group, parameters in pairs(groups) do
  vim.api.nvim_set_hl(0, group, parameters)
end
