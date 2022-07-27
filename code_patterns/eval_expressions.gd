

func eval_expression(command : String):
    ## https://docs.godotengine.org/en/stable/classes/class_expression.html
    var expression = Expression.new()
    var error = expression.parse(command, [])
    if error != OK:
        print(expression.get_error_text())
        return
    var result = expression.execute([], null, true)
    if not expression.has_execute_failed():
        return str(result)
