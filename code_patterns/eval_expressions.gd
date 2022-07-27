



## example of evaluating using variables from a dictionary:
static func evaluate_with_dict(command, variables : Dictionary, ref = null):
    return evaluate(command,ref,variables.keys(),variables.values())

## evaluate all options except error
static func evaluate(command, ref = null, variable_names = [], variable_values = []):
    ## https://docs.godotengine.org/en/stable/classes/class_expression.html
    ## https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html
    var expression = Expression.new()
    var error = expression.parse(command, variable_names)
    if error != OK:
        push_error(expression.get_error_text())
        return
    var result = expression.execute(variable_values, ref) # show error?
    if not expression.has_execute_failed():
        return result
