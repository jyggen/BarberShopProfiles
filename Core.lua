local addonName = "BarberShopProfiles"
local BarberShopProfiles = LibStub("AceAddon-3.0"):NewAddon(addonName)


function BarberShopProfiles:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(addonName .. "DB", {
        race = {
            profiles = {},
        },
    })

    self.systemProfile = {
        id = -1,
        name = "<new profile>",
    }

    self:SetCurrentProfileTo(self.systemProfile.id)
end

function BarberShopProfiles:CreateProfile()
    local profileId = #self.db.race.profiles + 1
    self.db.race.profiles[profileId] = {
        name = "Unknown",
        choices = {},
    }

    self:SetCurrentProfileTo(profileId)
end

function BarberShopProfiles:DeleteCurrentProfile()
    self.db.race.profiles[self:GetCurrentProfileId()] = nil
    self:SetCurrentProfileTo(self.systemProfile.id)
end

function BarberShopProfiles:GetCurrentProfileId()
    return self.selected
end

function BarberShopProfiles:GetCurrentProfileName()
    if self:IsCurrentProfileNew() then
        return self.systemProfile.name
    end 

    return self.db.race.profiles[self.selected].name
end

function BarberShopProfiles:GetProfiles()
    local profiles = {}

    for id in pairs(self.db.race.profiles) do
        table.insert(profiles, {
            id = id,
            name = self.db.race.profiles[id].name,
        })
    end

    table.sort(profiles, function (keyL, keyR)
        return keyL.name:lower() < keyR.name:lower()
    end)

    table.insert(profiles, {
        id = self.systemProfile.id,
        name = self.systemProfile.name,
    })

    return profiles
end

function BarberShopProfiles:IsCurrentProfileNew()
    return self.selected == self.systemProfile.id
end

function BarberShopProfiles:ApplyCurrentProfile()
    local choices = self.db.race.profiles[self.selected].choices

    for oid in pairs(choices) do
        C_BarberShop.SetCustomizationChoice(oid, choices[oid])
    end

    BarberShopFrame:UpdateCharCustomizationFrame()
end

function BarberShopProfiles:SaveCurrentProfileAs(name)
    local choices = {}
    local categories = C_BarberShop.GetAvailableCustomizations()

    if not categories then
        return
    end

    for cid, category in ipairs(categories) do
        for oid, option in ipairs(category.options) do
            choices[option.id] = option.choices[option.currentChoiceIndex].id
        end
    end

    self.db.race.profiles[self.selected] = {
        name = name,
        choices = choices,
    }
end

function BarberShopProfiles:SetCurrentProfileTo(id)
    self.selected = id
end