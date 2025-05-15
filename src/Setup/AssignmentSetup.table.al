table 50101 "RAA Assignment Setup"
{
    Caption = 'Assignment Setup';
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';

        }

        field(2; "Assignment No."; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = SystemMetadata;
            Caption = 'Assignment No.';
        }

        //API Key 6dswgupHlHo5iR31AzAzpcgemEt5mL0G
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}