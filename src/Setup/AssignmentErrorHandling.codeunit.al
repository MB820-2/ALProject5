codeunit 50102 "RAA Assignment Error Handling"
{
    procedure GoToAssignmentSetup(AssignmentError: ErrorInfo)
    begin
        Page.RunModal(Page::"RAA Assignment Setup");

        if not VerifyThatItHasBeenSetUp() then
            Error('Assignment Setup is not set up. Please set it up before proceeding.');

        Page.Run(Page::"RAA Assignment List");
    end;

    local procedure VerifyThatItHasBeenSetUp(): Boolean
    var
        AssignmentSetup: Record "RAA Assignment Setup";
    begin
        AssignmentSetup.InsertIfNotExists();
        exit(AssignmentSetup."Assignment No." <> '');
    end;
}