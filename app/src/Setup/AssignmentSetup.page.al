page 50101 "RAA Assignment Setup"
{

    PageType = Card;
    SourceTable = "RAA Assignment Setup";
    Caption = 'Assignment Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    AboutTitle = 'Assignment Setup';
    AboutText = 'This page is used to set up the Assignment Setup.';


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Assignment No."; Rec."Assignment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The no series of the Assignments', Comment = '%';

                    AboutTitle = 'Assignment No.';
                    AboutText = 'Control which number series is used when creating new assignments.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
