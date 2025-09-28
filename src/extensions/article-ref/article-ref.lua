local utils = require 'pandoc.utils'
local List = require 'pandoc.List'

local doc_cache = {}

-- Extract section numbers from header numbering
local function get_section_number(doc, target_id)
  for _, blk in ipairs(doc.blocks) do
    if blk.t == "Header" and blk.identifier == target_id then
      local num_parts = blk.attr and blk.attr.attributes["number"]
      if blk.number and #blk.number > 0 then
        return table.concat(blk.number, ".")
      end
    end
  end
  return nil
end

-- Load target document if not already cached
local function load_doc(path)
  if doc_cache[path] then
    return doc_cache[path]
  end
  local fh = io.popen("quarto pandoc --to=json " .. path)
  local json = fh:read("*a")
  fh:close()
  local doc = pandoc.read(json, "json")
  doc_cache[path] = doc
  return doc
end

-- Main filter function
function Link(el)
  local target = el.target

  -- Only process links that match pattern
  local file, fragment = string.match(target, "([^#]+)#(sec%-art%-%d+)")
  if not file or not fragment then
    return nil
  end

  local target_doc = load_doc(file)
  if not target_doc then
    io.stderr:write("Failed to load target file: " .. file .. "\n")
    return nil
  end

  local section_number = get_section_number(target_doc, fragment)
  if not section_number then
    return nil
  end

  local article_num = file:match("article(%d+)") or "?"
  local link_text = string.format("Article %s Section %s", article_num, section_number)

  -- Replace link text
  el.content = pandoc.Inlines(pandoc.Str(link_text))

  return el
end