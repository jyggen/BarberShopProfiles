local addonName = "BarberShopProfiles"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonName)
local MainFrame = Core:NewModule("MainFrame")
local DeleteButtonFrame = Core:NewModule("DeleteButtonFrame")
local LoadButtonFrame = Core:NewModule("LoadButtonFrame")
local ProfilePickerFrame = Core:NewModule("ProfilePickerFrame")
local SaveButtonFrame = Core:NewModule("SaveButtonFrame")

StaticPopupDialogs["BARBERSHOPPROFILES_CONFIRM_DELETE"] = {
    text = "Are you sure you want to delete \"%s\"?",
    preferredIndex = 3,
    button1 = "Yes",
    button2 = "No",
    timeout = 0,
    hideOnEscape = true,
    OnAccept = function (self, data)
        Core:DeleteCurrentProfile()
        ProfilePickerFrame:SetValue(Core:GetCurrentProfileId())
    end,
}


StaticPopupDialogs["BARBERSHOPPROFILES_PROFILE_NAME"] = {
    text = "What do you want to name this profile?",
    preferredIndex = 3,
    button1 = "Save",
    button2 = "Cancel",
    timeout = 0,
    hasEditBox = true,
    hideOnEscape = true,
    OnAccept = function (self, data)
        Core:CreateProfile()
        Core:SaveCurrentProfileAs(self.editBox:GetText())
        ProfilePickerFrame:SetValue(Core:GetCurrentProfileId())
    end,
    OnShow = function (self, data)
        self.button1:Disable()
    end,
    EditBoxOnTextChanged = function (self, data)
        if string.len(self:GetText()) > 0 then
            self:GetParent().button1:Enable()
        else
            self:GetParent().button1:Disable()
        end
    end
}

function MainFrame:OnInitialize()
    self.frame = CreateFrame("FRAME", addonName .. "MainFrame", CharCustomizeFrame.SmallButtons, "HorizontalLayoutFrame")
    self.frame:SetPoint("TOPLEFT", CharCustomizeFrame.SmallButtons, "BOTTOMLEFT", 0, 0)
end

function DeleteButtonFrame:OnInitialize()
    self.frame = CreateFrame("BUTTON", addonName .. "DeleteButtonFrame", MainFrame.frame, "SquareIconButtonTemplate")

    self.frame.layoutIndex = 3
    self.frame:SetAtlas("common-icon-redx")
    self.frame:SetScript("OnClick", function (self, button, down)
        local dialog = StaticPopup_Show("BARBERSHOPPROFILES_CONFIRM_DELETE", Core:GetCurrentProfileName())

        dialog:SetParent(MainFrame.frame)
    end)
end

function LoadButtonFrame:OnInitialize()
    self.frame = CreateFrame("BUTTON", addonName .. "LoadButtonFrame", MainFrame.frame, "SquareIconButtonTemplate")

    self.frame.layoutIndex = 1
    self.frame:SetAtlas("common-icon-undo")
    self.frame:SetScript("OnClick", function (self, button, down)
        Core:ApplyCurrentProfile()
    end)
end

function ProfilePickerFrame:OnInitialize()
    self.frame = CreateFrame("FRAME", addonName .. "ProfilePickerFrame", MainFrame.frame, "UIDropDownMenuTemplate")

    self.frame:SetPoint("CENTER")
    self.frame.layoutIndex = 0

    UIDropDownMenu_SetWidth(self.frame, 200)

    UIDropDownMenu_Initialize(self.frame, function(self)
        local currentId = Core:GetCurrentProfileId()

        for i, profile in ipairs(Core:GetProfiles()) do
            local info = UIDropDownMenu_CreateInfo()
        
            info.checked = profile.id == currentId
            info.text = profile.name
            info.value = profile.id
            info.func = ProfilePickerFrame.SetValue
            info.arg1 = profile.id

            UIDropDownMenu_AddButton(info)
        end
    end)

    self:SetValue(Core:GetCurrentProfileId())
end

function ProfilePickerFrame:SetValue(newValue)
    Core:SetCurrentProfileTo(newValue)

    UIDropDownMenu_SetText(ProfilePickerFrame.frame, Core:GetCurrentProfileName())

    if Core:IsCurrentProfileNew() then
        DeleteButtonFrame.frame:Disable()
        LoadButtonFrame.frame:Disable()
    else
        DeleteButtonFrame.frame:Enable()
        LoadButtonFrame.frame:Enable()
    end
end

function SaveButtonFrame:OnInitialize()
    self.frame = CreateFrame("BUTTON", addonName .. "SaveButtonFrame", MainFrame.frame, "SquareIconButtonTemplate")

    self.frame.layoutIndex = 2
    self.frame:SetAtlas("common-icon-checkmark")
    self.frame:SetScript("OnClick", function (self, button, down)
        if Core:IsCurrentProfileNew() then
            local dialog = StaticPopup_Show("BARBERSHOPPROFILES_PROFILE_NAME")

            dialog:SetParent(MainFrame.frame)
        else
            Core:SaveCurrentProfileAs(Core:GetCurrentProfileName())
        end
    end)
end