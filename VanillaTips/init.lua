local VanillaTipsMod = {}

function VanillaTipsMod.init()
    db:from_table({
        class = "StaticTip",
        name = "StackTransfers",
        label = {"StackTransfers", "tips"},
        description = {"StackTransfersDescription", "tips"},
        image = "StackTransfers.png"
    })
end

function VanillaTipsMod.pre_init()
end

function VanillaTipsMod.post_init()
end

db:mod(VanillaTipsMod)