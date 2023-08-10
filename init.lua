--[[

persistent_api.add_persistent_effect({
  name = string,  -- effect identifier. Will be overwritten if another effect is added to the same object with the same identifier.
  object = ObjectRef,   -- ObjectRef which is referenced and attached to the effect.
  duration = float,   -- amount of time until the effect is removed.
  effect = function(ObjectRef)  -- function that is run every time the effect is called.
  persistence = float,  -- how often (in seconds) the effect function is run.
})

Example:
  local player = minetest.get_player_by_name("JohnSmith")

  persistent_api.add_persistent_effect({
    name = "damage_player",
    object = player,
    duration = 10, -- this effect will last 10 seconds
    effect = function(player)
      player:set_hp(player:get_hp()-1)
    end,
    persistence = 0.1, -- every 0.1 seconds for 10 seconds the previous function will be run.
  })


]]

persistent_api = {
  effects = {}
}

function persistent_api.add_persistent_effect(def)
  persistent_api.effects[def.object] = persistent_api.effects[def.object] or {}
  persistent_api.effects[def.object][def.name] = {duration = minetest.get_gametime()+def.duration, persistence = {def.persistence, 0}, effect = def.effect}
end

local lsls = false

minetest.register_globalstep(function(dtime)
  for object,defs in pairs(persistent_api.effects) do
    for indexx,def in pairs(defs) do
      if def.duration < minetest.get_gametime() then
        persistent_api.effects[object][indexx] = nil
      else
        def.persistence[2] = def.persistence[2] + dtime
        if def.persistence[2] > def.persistence[1] then
          def.effect(object)
          def.persistence[2] = 0
        end
      end
    end
  end
end)
