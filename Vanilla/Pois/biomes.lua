local TEMPERATE = {
   "PlainsBiome", "RedPlainsBiome", "WhitePlainsBiome", "YellowPlainsBiome",
   "ForestBiome", "PineForestBiome", "FertileForestBiome", "BushlandBiome", "DipteroBiome",
   "HillsBiome", "HillsForestBiome",
}

return function()
   local list = {}
   for _, name in ipairs(TEMPERATE) do
      table.insert(list, Biome.get(name))
   end
   return list
end
