"""

some of these functions are no use if you use "find_node"
https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-find-node


get_tree().get_root().find_node("Name819", true)




"""


# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name




# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
# added depth 18/11/2022

func find_node_by_name(root, _name, max_depth = 3, depth = 0):
    """
    find_node_by_name with depth limit
    
    find_node_by_name(get_tree().get_root(), "NameInWholeScene") ## use the top of the tree as the root for a global search
    
    """    
    if depth < max_depth:
        if(root.get_name() == _name): ## we have a mathc
            return root
        for child in root.get_children():
            if(child.get_name() == _name):
                return child
            var found = find_node_by_name(child, _name, max_depth, depth + 1)
            if(found):
                return found
    return null
    
    
    
https://godotengine.org/qa/110576/how-do-you-get-all-nodes-of-a-certain-class
func findByClass(node: Node, className : String, result : Array) -> void:
  if node.is_class(className) :
    result.push_back(node)
  for child in node.get_children():
    findByClass(child, className, result)
    
    

func find_node_no_recurse(root, _name, max_depth = 100, max_count = 1000):
    """
    this pattern built by me to use a stack, no recursion, it looks more complicated but should use less memory and be faster
    
    could be more effecient in some circumstances
    
    """
        
    var count = 0 # current count
    
    var walk_stack = [root] # this tracks the nodes to check, these act as stacks (faster)
    var walk_stack_depth = [0] # this tracks the depth (parrel arrays)
    
    while walk_stack.size() > 0:
        
        count += 1
        if count > max_count:
            break
        
        ## popping back is faster, but ends up search all tree top to bottom
        var node = walk_stack.pop_back()
        var node_depth = walk_stack_depth.pop_back()
        
#        ## if we used this alternate pattern, we would search in slices
#        ## this could be faster but pop_front is also slower
#        var node = walk_stack.pop_front()
#        var node_depth = walk_stack_depth.pop_front()
        
        print("walk (%s) %s depth=%s" % [count,node,node_depth])
        
        if node.name == _name: ## we have a match, exit the function
            return node
            
        if node_depth < max_depth: ## as long as we are less than max_depth
            
#            ## this method ends up backwards due to the stack pattern
#            for child in node.get_children(): ## we have no other result, push childs to stack
#                walk_stack.push_back(child)
#                walk_stack_depth.push_back(node_depth + 1)
            
            ## this pattern iterates the children backwards padawan (ensures search is forwards)
            var i = node.get_child_count()
            while i > 0:
                i -= 1
                walk_stack.push_back(node.get_child(i))
                walk_stack_depth.push_back(node_depth + 1)
                
                
                
                
## how to make a more complicated search with a predicate, essentially a query, like all buttons with a certain name etc


func predicate_example(x):
    return x.name == "DebugLabel" and x is RichTextLabel ## you could make multiple stipulations


func get_all_buttons():
    return find_nodes_by_predicate(self, funcref(self, "is_button_predicate")) ## usage example

func is_button_predicate(x):
    return x is Button

func find_nodes_by_predicate(root : Node, predicate : FuncRef, max_depth : int = 100, max_count : int = 1000):
    """
    this pattern built by me to use a stack, no recursion
    
    could be more effecient in some circumstances
    
    """
        
    var count = 0 # current count
    
    var walk_stack = [root] # this tracks the nodes to check, these act as stacks (faster)
    var walk_stack_depth = [0] # this tracks the depth (parrel arrays)
    
    var search_results = []
    
    while walk_stack.size() > 0:
        
        count += 1
        if count > max_count:
            break
        
        ## popping back is faster, but ends up search all tree top to bottom
        var node = walk_stack.pop_back()
        var node_depth = walk_stack_depth.pop_back()
        
        print("walk (%s) %s depth=%s" % [count,node,node_depth])
        
        if predicate.call_func(node): ## our predicate returns tur
            search_results.append(node)
            
        if node_depth < max_depth: ## as long as we are less than max_depth
            
            ## this pattern iterates the children backwards padawan (ensures search is forwards)
            var i = node.get_child_count()
            while i > 0:
                i -= 1
                walk_stack.push_back(node.get_child(i))
                walk_stack_depth.push_back(node_depth + 1)
                
    return search_results
    
    
    
## far more simple way but may be a bit slow
func get_all_buttons():
    var ret = []
    for child in get_all_children(self):
        
        if child is Button:
            ret.append(child)
    return ret



    
    
# recursive get all nodes
static func get_all_children(node : Node, array : Array = []) -> Array:
    array.push_back(node)
    for child in node.get_children():
        array = get_all_children(child,array)
    return array  
    
    
## recursive get all nodes, solved with depth now 21/11/2022

static func get_all_children(node : Node, max_depth = 100, array : Array = [], depth = 0) -> Array:
    ## get all childs, recursive with depth
    ## get_all_children(get_tree().get_root()) # get all of scene
    if depth <= max_depth:
        array.push_back(node)
        for child in node.get_children():
            array = get_all_children(child,max_depth,array,depth+1)
    return array  
