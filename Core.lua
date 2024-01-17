local addonName = "BarberShopProfiles"
local BarberShopProfiles = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")


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
    local isAltered = C_BarberShop.IsViewingAlteredForm()

    for id in pairs(self.db.race.profiles) do
        if self.db.race.profiles[id].isAltered == nil or self.db.race.profiles[id].isAltered == isAltered then
            table.insert(profiles, {
                id = id,
                name = self.db.race.profiles[id].name,
            })
        end
    end

    table.sort(profiles, function (keyL, keyR)
        return keyL.name:lower() < keyR.name:lower()
    end)

    return profiles
end

function BarberShopProfiles:IsCurrentProfileNew()
    return self.selected == self.systemProfile.id
end

function BarberShopProfiles:ApplyCurrentProfile()
    local profile = self.db.race.profiles[self.selected]
    local characterData = C_BarberShop.GetCurrentCharacterData()

    if not characterData then
        return
    end

    local applyChoices = function()
        for oid in pairs(profile.choices) do
            BarberShopFrame:SetCustomizationChoice(oid, profile.choices[oid])
        end
    end

    -- If we end up changing the sex, we need to wait for BARBER_SHOP_CAMERA_VALUES_UPDATED
    -- or appearance choices won't be visible on the model.
    if profile.sex ~= nil and profile.sex ~= characterData.sex then
        self:RegisterEvent("BARBER_SHOP_CAMERA_VALUES_UPDATED", applyChoices)
        BarberShopFrame:SetCharacterSex(profile.sex)
    else
        applyChoices()
    end
end

function BarberShopProfiles:SaveCurrentProfileAs(name)
    local choices = {}
    local categories = C_BarberShop.GetAvailableCustomizations()
    local characterData = C_BarberShop.GetCurrentCharacterData()
    local isAltered = C_BarberShop.IsViewingAlteredForm()

    if not categories or not characterData then
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
        sex = characterData.sex,
        isAltered = isAltered,
    }
end

function BarberShopProfiles:SetCurrentProfileTo(id)
    self.selected = id
end
