local addonName = "BarberShopProfiles"
local Core = LibStub("AceAddon-3.0"):GetAddon(addonName)
local MainFrame = Core:NewModule("MainFrame")
local DeleteButtonFrame = Core:NewModule("DeleteButtonFrame")
local LoadButtonFrame = Core:NewModule("LoadButtonFrame")
local ProfilePickerFrame = Core:NewModule("ProfilePickerFrame", "AceEvent-3.0")
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

StaticPopupDialogs["BARBERSHOPPROFILES_CONFIRM_SAVE"] = {
    text = "Are you sure you want to overwrite \"%s\"?",
    preferredIndex = 3,
    button1 = "Yes",
    button2 = "No",
    timeout = 0,
    hideOnEscape = true,
    OnAccept = function (self, data)
        Core:SaveCurrentProfileAs(Core:GetCurrentProfileName())
    end,
}


StaticPopupDialogs["BARBERSHOPPROFILES_NEW_PROFILE"] = {
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

local function prepareTooltipOptions(frame, text)
    frame:AddTooltipLine(text, HIGHLIGHT_FONT_COLOR)
    frame.tooltipAnchor = "ANCHOR_BOTTOMRIGHT"
    frame.tooltipXOffset = -5
    frame.tooltipYOffset = -5
    frame.tooltipMinWidth = nil
end

function MainFrame:OnInitialize()
    self.frame = CreateFrame("FRAME", addonName .. "MainFrame", CharCustomizeFrame.SmallButtons, "HorizontalLayoutFrame")
    self.frame:SetPoint("TOPLEFT", CharCustomizeFrame.SmallButtons, "BOTTOMLEFT", 0, 0)
end

function DeleteButtonFrame:OnInitialize()
    self.frame = CreateFrame("BUTTON", addonName .. "DeleteButtonFrame", MainFrame.frame, "SquareIconButtonTemplate,CustomizeFrameWithTooltipTemplate")

    prepareTooltipOptions(self.frame, "Delete")

    self.frame.layoutIndex = 3
    self.frame:SetAtlas("common-icon-redx", true)
    self.frame:SetScript("OnClick", function (self, button, down)
        local dialog = StaticPopup_Show("BARBERSHOPPROFILES_CONFIRM_DELETE", Core:GetCurrentProfileName())

        dialog:SetParent(MainFrame.frame)
    end)
end

function LoadButtonFrame:OnInitialize()
    self.frame = CreateFrame("BUTTON", addonName .. "LoadButtonFrame", MainFrame.frame, "SquareIconButtonTemplate,CustomizeFrameWithTooltipTemplate")

    prepareTooltipOptions(self.frame, "Load")

    self.frame.layoutIndex = 1
    self.frame:SetAtlas("common-icon-undo", true)
    self.frame:SetScript("OnClick", function (self, button, down)
        Core:ApplyCurrentProfile()
    end)
end

function ProfilePickerFrame:OnInitialize()
    self.frame = CreateFrame("FRAME", addonName .. "ProfilePickerFrame", MainFrame.frame, "UIDropDownMenuTemplate")
    self.page = 1
    self.limit = 25

    self.frame:SetPoint("CENTER")
    self.frame.layoutIndex = 0

    local initializeDropdown = function()
        Core:SetCurrentProfileTo(Core.systemProfile.id)

        UIDropDownMenu_Initialize(self.frame, function(self)
            local currentId = Core:GetCurrentProfileId()
            local maxPage = math.max(math.ceil(#Core:GetProfiles() / ProfilePickerFrame.limit), 1)

            if ProfilePickerFrame.page > maxPage then
                ProfilePickerFrame.page = maxPage
            end

            local upper = (ProfilePickerFrame.page*ProfilePickerFrame.limit)
            local lower = upper-ProfilePickerFrame.limit

            local info = UIDropDownMenu_CreateInfo()
            info.text = "Profiles"
            info.isTitle = true
            UIDropDownMenu_AddButton(info)

            for i, profile in ipairs(Core:GetProfiles()) do
                if i <= upper and i > lower then
                    local info = UIDropDownMenu_CreateInfo()

                    info.checked = profile.id == currentId
                    info.text = profile.name
                    info.value = profile.id
                    info.func = ProfilePickerFrame.SetValue
                    info.arg1 = profile.id

                    UIDropDownMenu_AddButton(info)
                end
            end

            local info = UIDropDownMenu_CreateInfo()

            info.checked = Core.systemProfile.id == currentId
            info.text = Core.systemProfile.name
            info.value = Core.systemProfile.id
            info.func = ProfilePickerFrame.SetValue
            info.arg1 = Core.systemProfile.id

            UIDropDownMenu_AddButton(info)

            if maxPage > 1 then
                local info = UIDropDownMenu_CreateInfo()
                info.text = "Pages (" .. ProfilePickerFrame.page .. " of " .. maxPage .. ")"
                info.isTitle = true
                UIDropDownMenu_AddButton(info)

                if ProfilePickerFrame.page > 1 then
                    local info = UIDropDownMenu_CreateInfo()

                    info.text = "Previous Page"
                    info.func = ProfilePickerFrame.PreviousPage

                    UIDropDownMenu_AddButton(info)
                end

                if ProfilePickerFrame.page < maxPage then
                    local info = UIDropDownMenu_CreateInfo()

                    info.text = "Next Page"
                    info.func = ProfilePickerFrame.NextPage

                    UIDropDownMenu_AddButton(info)
                end
            end
        end)

        UIDropDownMenu_SetWidth(self.frame, 200)

        self:SetValue(Core:GetCurrentProfileId())
    end

    self:RegisterEvent("BARBER_SHOP_CAMERA_VALUES_UPDATED", initializeDropdown)
    initializeDropdown()
end

function ProfilePickerFrame:PreviousPage()
    ProfilePickerFrame.page = ProfilePickerFrame.page-1
end

function ProfilePickerFrame:NextPage()
    ProfilePickerFrame.page = ProfilePickerFrame.page+1
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
    self.frame = CreateFrame("BUTTON", addonName .. "SaveButtonFrame", MainFrame.frame, "SquareIconButtonTemplate,CustomizeFrameWithTooltipTemplate")

    prepareTooltipOptions(self.frame, "Save")

    self.frame.layoutIndex = 2
    self.frame:SetAtlas("common-icon-checkmark", true)
    self.frame:SetScript("OnClick", function (self, button, down)
        if Core:IsCurrentProfileNew() then
            local dialog = StaticPopup_Show("BARBERSHOPPROFILES_NEW_PROFILE")

            dialog:SetParent(MainFrame.frame)
        else
            local dialog = StaticPopup_Show("BARBERSHOPPROFILES_CONFIRM_SAVE", Core:GetCurrentProfileName())

            dialog:SetParent(MainFrame.frame)
        end
    end)
end
