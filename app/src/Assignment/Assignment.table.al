table 50100 "RAA Assignment"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "RAA Assignment List";
    LookupPageId = "RAA Assignment List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the value of the No. field.';
            DataClassification = SystemMetadata;
        }

        field(2; "User Id"; Integer)
        {
            Caption = 'User Id';
            ToolTip = 'Specifies the value of the User Id field.';
            DataClassification = EndUserPseudonymousIdentifiers;
        }

        field(3; Title; Text[100])
        {
            Caption = 'Title';
            ToolTip = 'Specifies the value of the Title field.';
            DataClassification = CustomerContent;
        }

        field(4; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the value of the Description field.';
            DataClassification = CustomerContent;
        }

        field(5; Status; Enum "RAA Assignment Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the value of the Status field.';
            DataClassification = SystemMetadata;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    var
        Assignment: Record "RAA Assignment";
        AssignmnetSetup: Record "RAA Assignment Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if Rec."No." = '' then begin
            AssignmnetSetup.InsertIfNotExists();
            AssignmnetSetup.TestField("Assignment No.");

            Rec."No." := NoSeries.GetNextNo(AssignmnetSetup."Assignment No.");
            Assignment.ReadIsolation(IsolationLevel::ReadUncommitted);
            Assignment.SetLoadFields("No.");
            while Assignment.Get(Rec."No.") do
                Rec."No." := NoSeries.GetNextNo(AssignmnetSetup."Assignment No.");
        end;
    end;

}