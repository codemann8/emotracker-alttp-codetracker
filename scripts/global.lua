START_CLOCK = os.clock()

function initGlobalVars()
    OBJ_DUNGEON = Tracker:FindObjectForCode("dungeon")

    if Tracker.ActiveVariantUID ~= "items_only" then
        OBJ_KEYSANITY = Tracker:FindObjectForCode("keysanity_mode")
        OBJ_ENTRANCE = Tracker:FindObjectForCode("entrance_shuffle")
        OBJ_DOORSHUFFLE = Tracker:FindObjectForCode("door_shuffle")

        OBJ_DOORDUNGEON = Tracker:FindObjectForCode("door_dungeonselect")
        OBJ_DOORCHEST = Tracker:FindObjectForCode("door_totalchest")
    end
end

function loadMCBK()
    MapCompassBK("Hyrule Castle Map/Compass/Big Key", "hc")
    MapCompassBK("Eastern Palace Map/Compass/Big Key", "ep")
    MapCompassBK("Desert Palace Map/Compass/Big Key", "dp")
    MapCompassBK("Tower of Hera Map/Compass/Big Key", "toh")
    MapCompassBK("Aganihm's Tower Map/Compass/Big Key", "at")
    MapCompassBK("Palace of Darkness Map/Compass/Big Key", "pod")
    MapCompassBK("Swamp Palace Map/Compass/Big Key", "sp")
    MapCompassBK("Skull Woods Map/Compass/Big Key", "sw")
    MapCompassBK("Thieves Town Map/Compass/Big Key", "tt")
    MapCompassBK("Ice Palace Map/Compass/Big Key", "ip")
    MapCompassBK("Misery Mire Map/Compass/Big Key", "mm")
    MapCompassBK("Turtle Rock Map/Compass/Big Key", "tr")
    MapCompassBK("Ganon's Tower Map/Compass/Big Key", "gt")
end

function updateIcons()
    local dungeons = { "hc", "ep", "dp", "at", "sp", "pod", "mm", "sw", "ip", "toh", "tt", "tr", "gt" }
    for i = 1, 13 do
        local item = Tracker:FindObjectForCode(dungeons[i] .. "_item")
        local key = Tracker:FindObjectForCode(dungeons[i] .. "_smallkey")
        if OBJ_DOORSHUFFLE.CurrentStage == 2 then
            if item.Section.ChestCount ~= 99 then
                item.Section.ChestCount = 99
                item.Section.AvailableChestCount = 0
                item.Section.Owner.OpenChestImage = ImageReference:FromPackRelativePath("images/0058.png")
            end
            key.MaxCount = 99
            key.Icon = ImageReference:FromPackRelativePath("images/SmallKey2.png", "@disabled")

            if dungeons[i] == "hc" or dungeons[i] == "at" then
                Tracker:FindObjectForCode(dungeons[i] .. "_bigkey").Icon = ImageReference:FromPackRelativePath("images/BigKey.png", "@disabled")
            end
        else
            local chestkey = Tracker:FindObjectForCode(dungeons[i] .. "_chestkey")
            
            if key.MaxCount == 0 then
                key.Icon = ""
            end
            key.MaxCount = chestkey.MaxCount

            if dungeons[i] == "hc" or dungeons[i] == "at" then
                local bk = Tracker:FindObjectForCode(dungeons[i] .. "_bigkey")
                if bk.Icon ~= "" then
                    bk.Icon = ""
                end
            end

            local found = 0
            if item.Section.ChestCount ~= 99 then
                found = item.Section.ChestCount - item.Section.AvailableChestCount
            end

            local chest = Tracker:FindObjectForCode(dungeons[i] .. "_chest")
            item.Section.ChestCount = chest.MaxCount
            if OBJ_KEYSANITY.CurrentStage <= 2 and dungeons[i] ~= "hc" and dungeons[i] ~= "at" then
                item.Section.ChestCount = item.Section.ChestCount - 1
            end
            if OBJ_KEYSANITY.CurrentStage <= 1 and key then
                item.Section.ChestCount = item.Section.ChestCount - key.MaxCount
            end
            if OBJ_KEYSANITY.CurrentStage == 0 then
                if dungeons[i] == "hc" then
                    item.Section.ChestCount = item.Section.ChestCount - 1
                elseif dungeons[i] ~= "at" then
                    item.Section.ChestCount = item.Section.ChestCount - 2
                end
            end
            
            item.Section.Owner.OpenChestImage = ImageReference:FromPackRelativePath("images/0059.png")
            item.Section.AvailableChestCount = math.max(item.Section.ChestCount - found, 0)
        end
    end

    OBJ_DOORDUNGEON.ItemState:updateIcon()
    OBJ_DOORCHEST.ItemState:updateIcon()
end