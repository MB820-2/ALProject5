pageextension 50101 "RAA O365ActivitiesExt" extends "O365 Activities"
{
    layout
    {
        addafter("My Incoming Documents")
        {
            field("RAA Assignments"; Rec."RAA Assignments")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assignments field.', Comment = '%';
            }
        }
    }
}