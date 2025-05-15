page 50100 "RAA Assignment List"
{
    Caption = 'Assignment List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "RAA Assignment";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Id field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AIAssignment)
            {
                Caption = 'AI Assignment';
                ApplicationArea = All;
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LeChatMgt: Codeunit "RAA LeChat Mgt.";
                begin
                    LeChatMgt.GenerateAssignments('Hello Rasmus, Could you please help me move my paintings tomorrow.')
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AssignmentSetup: Record "RAA Assignment Setup";
        AssignmentError: ErrorInfo;
    begin
        AssignmentSetup.InsertIfNotExists();

        if AssignmentSetup."Assignment No." = '' then begin
            AssignmentError.Title('Missing Assignment Number Series');
            AssignmentError.Message('Please set up the Assignment Number Series in the Assignment Setup page.');
            AssignmentError.AddAction('Go to Assignment Setup', Codeunit::"RAA Assignment Error Handling", 'GoToAssignmentSetup');

            Error(AssignmentError);
        end;
    end;
}