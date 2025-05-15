page 50102 "RAA Assignment Wizard"
{
    Caption = 'Assignment';
    PageType = NavigatePage;
    SourceTable = "RAA Assignment Setup";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(StandardBanner)
            {
                ShowCaption = false;
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                ShowCaption = false;
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(Step1)
            {
                ShowCaption = false;
                Visible = Step1Visible;
                group("Welcome to Assignment")
                {
                    Caption = 'Welcome to Assignment Setup';
                    Visible = Step1Visible;
                    group(Group18)
                    {
                        ShowCaption = false;
                        InstructionalText = 'In this setup we will be setting up the final things for your assignments.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Group22)
                    {
                        ShowCaption = false;
                        InstructionalText = 'This is the first step of the setup.';
                    }
                }
            }

            group(Step2)
            {
                ShowCaption = false;
                InstructionalText = 'In this step you will be assigning the no. series used for each of your assignments.';
                Visible = Step2Visible;

                field("Assignment No."; Rec."Assignment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment No. field.', Comment = '%';
                    TableRelation = "No. Series";
                }
            }


            group(Step3)
            {
                ShowCaption = false;
                Visible = Step3Visible;
                group(Group23)
                {
                    ShowCaption = false;
                    InstructionalText = 'Congatulations! You have completed the setup, click Finish to save everything.';
                }
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Group25)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To save this setup, choose Finish.';
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction()
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    var
        AssignmentSetup: Record "RAA Assignment Setup";
    begin
        Rec.Init();
        if AssignmentSetup.Get() then
            Rec.TransferFields(AssignmentSetup);

        Rec.Insert();

        Step := Step::Start;
        EnableControls();
    end;

    var
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        Step: Option Start,Step2,Finish;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        TopBannerVisible: Boolean;

    local procedure EnableControls()
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure StoreAssignmentSetup()
    var
        AssignmentSetup: Record "RAA Assignment Setup";
    begin
        if not AssignmentSetup.Get() then begin
            AssignmentSetup.Init();
            AssignmentSetup.Insert();
        end;

        AssignmentSetup.TransferFields(Rec, false);
        AssignmentSetup.Modify(true);
    end;


    local procedure FinishAction()
    begin
        StoreAssignmentSetup();
        CurrPage.Close();
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;

        EnableControls();
    end;

    local procedure ShowStep1()
    begin
        Step1Visible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visible := true;
    end;

    local procedure ShowStep3()
    begin
        Step3Visible := true;

        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
            MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
                MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;
}