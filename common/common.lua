local common = {}

common.MAP_SCALE = 10
common.TIME_TO_BUILD_BUILDING = 5
common.ADVENTURE_DURATION = 5

common.setPropPosition = function(obj, x, y)
    obj.Position = { (x + 0.5) * common.MAP_SCALE, 0, (y + 0.5) * common.MAP_SCALE }
end

return common
