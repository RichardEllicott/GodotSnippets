"""

some of these functions are no use if you use "find_node"
https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-find-node


get_tree().get_root().find_node("Name819", true)


"""


# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
func _find_node_by_name(root, name):
    """
    finds a node by name in all childs of root
    intended to be used for global find function:
        mylib.find(name)
    """
    if(root.get_name() == name):
        return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = _find_node_by_name(child, name)
        if(found):
            return found
    return null

func find(name):
    """
    global find by name (searches whole scene)
    """
    var node = _find_node_by_name(get_tree().get_root(), name)
    if not node:
        print('WARNING: no object found named ""%s"' % name)
    return node



# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
# added depth 18/11/2022

func find_node_by_name(root, _name, max_depth = 3, depth = 0):
    """
    find_node_by_name with depth limit
    """
    
    print("looking for %s, depth = %s root = %s" % [_name, depth, root.name])
    
    if depth < max_depth:
        if(root.get_name() == _name): ## we have a mathc
            return root
        for child in root.get_children():
            if(child.get_name() == _name):
                return child
            var found = find_node_by_name(child, _name, max_depth, depth + 1)
            if(found):
                retu
    
    
    
https://godotengine.org/qa/110576/how-do-you-get-all-nodes-of-a-certain-class
func findByClass(node: Node, className : String, result : Array) -> void:
  if node.is_class(className) :
    result.push_back(node)
  for child in node.get_children():
    findByClass(child, className, result)
    
    
    
func find_node_no_recurse(root, _name, max_count = 1000):
    """
    this pattern built by me to use a stack, no recursion
    
    could be more effecient in some circumstances
    
    """
    
    var pop_back = true
    
    
    var count = 0
    
    var walk_stack = [root]
    
    while walk_stack.size() > 0:
        
        count += 1
        if count > max_count:
            return # we reach our limit return null
        
        var node = walk_stack.pop_back()
#        var node = walk_stack.pop_front()

        print("walk %s %s" % [count,node])
        
        if node.name == _name:
                
            print("walk match!!")
                
            return node
        
        for child in node.get_children(): ## we have no other result, push childs to stack
            walk_stack.push_back(child)
            
    
    
