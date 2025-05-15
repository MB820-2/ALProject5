codeunit 50101 "RAA Assignment Setup Subs"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddExtensionAssistedSetup_OnRegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        TitleLbl: Label 'Assignment Setup Wizard';
        ShortTitleLbl: Label 'Assisted Assignment Setup';
        DescriptionLbl: Label 'Assisted setup for the Assignment Setup page.';
    begin
        GuidedExperience.InsertAssistedSetup(
            TitleLbl,
            ShortTitleLbl,
            DescriptionLbl,
            1,
            ObjectType::Page,
            GetPageId(),
            "Assisted Setup Group"::Extensions,
            'https://www.youtube.com/embed/fitTMAwHcJw',
            "Video Category"::Uncategorized,
            'https://www.waldo.be');

        UpdateStatus();
    end;

    //TODO: remove the following subscriber if not necessary to run
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnReRunOfCompletedAssistedSetup', '', false, false)]
    local procedure OnReRunOfCompletedSetup(ExtensionID: Guid; ObjectType: ObjectType; ObjectID: Integer; var Handled: Boolean)
    var
        SetupAlreadyDoneQst: Label 'This setup is already done. Do you want to open the setup page instead?';
    begin
        if ExtensionID <> GetAppId() then exit;
        if ObjectType <> ObjectType::Page then exit;
        if ObjectID <> GetPageId() then exit;

        if Confirm(SetupAlreadyDoneQst, true) then
            Page.Run(GetPageId()); //TODO: Might have to be be a different page (like not the wizard, but the setup page instead)

        Handled := true;
    end;

    //TODO: remove the following subscriber if not necessary to run 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnAfterRunAssistedSetup', '', false, false)]
    local procedure OnAfterRunOfSetup(ExtensionID: Guid; ObjectType: ObjectType; ObjectID: Integer)
    begin
        if ExtensionID <> GetAppId() then exit;
        if ObjectID <> GetPageId() then exit;

        //TODO: put code here to run 'OnAfterRunAssistedSetup' 
    end;

    procedure UpdateStatus()
    var
        Rec: Record "RAA Assignment Setup";
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if not Rec.Get() then exit;

        if Rec."Assignment No." <> '' then  //TODO: You probably are going to want to change this ;-)
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, GetPageId());
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
        Info: ModuleInfo;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    local procedure GetPageId(): Integer
    begin
        exit(Page::"RAA Assignment Wizard");
    end;

    //TODO: Call "SomeAssistedSetup.UpdateStatus(); in case the wizard is run without the assisted setup.  It should call the "UpdateStatus" of this codeunit.
}
