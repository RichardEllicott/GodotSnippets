"""

property get set examples


"""


# triggers functions when you set/get the variables

export var prop_example = "prop test" setget set_prop_example, get_prop_example

func set_prop_example(new_value):
    prop_example = new_value

func get_prop_example():
    return prop_example


# enumerator example, useful for tool mode

enum PropEnum {
    none,
    apple,
    tangerine,
   }

export(PropEnum) var prop_enum_example = PropEnum.none setget set_prop_enum_example, get_prop_enum_example

func set_prop_enum_example(new_value):
    prop_enum_example = new_value

func get_prop_enum_example():
    return prop_enum_example

