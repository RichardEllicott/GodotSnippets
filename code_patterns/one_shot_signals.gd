"""

it is better practise to send a signal to a target node than to simply call a function on it

for example many people might call:

    if body.has_method("apply_damage"):
        body.apply_damage(33.0)



on a target body... however the code will now execute in the current thread, most of the time this is unproblematic however it is better to send a signal
the code running from the signal will be running on the node itself at a later point in time
the event model also is conviniant 


"""

#example of sending a one shot signal with a parameter:

# this will connect our "damage" signal to the target for one shot
# this could be called on a bullet for example, applying damage to a target

connect("damage", body, "_on_damage",[], CONNECT_ONESHOT )
# emit the damage
emit_signal("damage",damage_amount)


# dressed up as a function to save writing two lines:

# sig_name is the name of the defined signal, like "signal damage" for example that sends damage to a target
# target is the target node that has the callback on it
# the callback is the event function, that runs on the target (we use underscores as convention to mark callbacks)
# the par1 is one parameter to send the target (add more if required)

func send_one_shot_signal(sig_name,target,callback_name,par1):
    connect(sig_name, target, callback_name,[], CONNECT_ONESHOT )
    emit_signal(sig_name,par1)

