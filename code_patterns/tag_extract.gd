"""

functions concerning metadata from strings

for example i often use "tags" that are inside []

like this:

"this is a sentance[tag1][tag2]"


the purpose of the pattern is you can embed instructions in strings, you can put these symbols in node names for example
you can also put them in blender exports


"""



static func tag_extract(input_string, open_symbol = '[', close_symbol = ']') -> Array:
    """
    takes an input string which might have many tags like
    "this is[tag] a sentance[end]"
    =>
    ["this is a sentance", "tag", "end"]
    
    this is used to extra hidden comman tags
    
    https://github.com/RichardEllicott/GodotSnippets/blob/master/code_patterns/tag_extract.gd
    """
    var nest = 0
    var open_brackets = false
    var text = ""
    var instructions = []
    var bracketed_text = ""
    
    for _char in input_string:
        if _char == open_symbol: ## when we open the brackets
            nest += 1
            if nest == 1:
                open_brackets = true
        elif _char == close_symbol: ## when we close the brackets
            nest -= 1
            if nest == 0:
                open_brackets = false
                instructions.append(bracketed_text)
                bracketed_text = ""
        else:
            if open_brackets:
                bracketed_text += _char
            else:
                text += _char
    return [text] + instructions
