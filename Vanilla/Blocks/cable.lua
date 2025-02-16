require('Blocks/common')

local logic = function(self)
    local conductor = ConductorBlockLogic.cast(self)

    local metalMap = {
        "CopperConnector",
        "OFCCable",
        "GCable",
        "CNCable",
        "YBCOCable",
        "PCable",
        "TNCable",
        "ABCCOCable",
    }

    local rubberMap = {
        "CableCenterLV",
        "CableCenterLV",
        "CableCenterMV",
        "CableCenterMV",
        "CableCenterMV",
        "CableCenterHV",
        "CableCenterHV",
        "CableCenterHV",
    }

    conductor.side_cover = StaticCover.find(metalMap[conductor.static_block.tier])
    conductor.center_cover = StaticCover.find(rubberMap[conductor.static_block.tier])
end

return { logic_init = logic }