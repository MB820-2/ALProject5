tableextension 50100 "RAA ActivitiesCueExt" extends "Activities Cue"
{
    fields
    {
        field(50100; "RAA Assignments"; Integer)
        {
            CalcFormula = count("RAA Assignment");
            Caption = 'Assignments';
            FieldClass = FlowField;
        }
    }
}