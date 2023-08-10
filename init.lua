--[[

ward_func.add_persistent_effect({
  name = string,  -- effect identifier. Will be overwritten if another effect is added to the same object with the same identifier.
  object = ObjectRef,   -- ObjectRef which is referenced and attached to the effect.
  duration = float,   -- amount of time until the effect is removed.
  effect = function(ObjectRef)  -- function that is run every time the effect is called.
  persistence = float,  -- how often (in seconds) the effect function is run.
})

Example:
  local player = minetest.get_player_by_name("JohnSmith")

  ward_func.add_persistent_effect({
    name = "damage_player",
    object = player,
    duration = 10, -- this effect will last 10 seconds
    effect = function(player)
      player:set_hp(player:get_hp()-1)
    end,
    persistence = 0.1, -- every 0.1 seconds for 10 seconds the previous function will be run.
  })


]]

persistent_effects = {
  effects = {}
}

function persistent_effects.add_persistent_effect(def)
  persistent_effects.effects[def.object] = persistent_effects.effects[def.object] or {}
  persistent_effects.effects[def.object][def.name] = {duration = minetest.get_gametime()+def.duration, persistence = {def.persistence, 0}, effect = def.effect}
end

minetest.register_globalstep(function(dtime)
  for object,defs in pairs(persistent_effects.effects) do
    for indexx,def in pairs(defs) do
      if def.duration < minetest.get_gametime() then
        persistent_effects.effects[object][indexx] = nil
      else
        def.persistance[2] = def.persistance[2] + dtime
        if def.persistance[2] > def.persistance[1] then
          def.effect(object)
          def.persistance[2] = 0
        end
      end
    end
  end
end)
