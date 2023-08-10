# persistent_api
A minetest api that allows for easy creation of persistent effects. for example: changing a players health over time with a set interval (eg; poison or healing)

### how to use:
Simply use the one function
```lua
persistent_api.add_persistent_effect(def)
```
like this
```lua
persistent_api.add_persistent_effect({
  name = string,
  -- effect identifier. Will be overwritten if another effect is added to the same object with the same identifier.

  object = ObjectRef,
  -- ObjectRef which is referenced and attached to the effect.

  duration = float,
  -- amount of time until the effect is removed.

  effect = function(ObjectRef)
  -- function that is run every time the effect is called.

  persistence = float,
  -- how often (in seconds) the effect function is run.
})
```
for example
```lua
local player = minetest.get_player_by_name("JohnSmith")

  persistent_api.add_persistent_effect({
    name = "damage_player", -- identifier
    object = player, -- affected object
    duration = 10, -- this effect will last 10 seconds
    effect = function(player)
      player:set_hp(player:get_hp()-1) -- damage the player one half heart
    end,
    persistence = 0.1, -- every 0.1 seconds for 10 seconds the previous function will be run.
  })
```
