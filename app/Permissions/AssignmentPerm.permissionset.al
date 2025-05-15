namespace Rasmus.ALProject5;

permissionset 50100 "Assignment Super"
{
    Assignable = true;
    Permissions = tabledata "RAA Assignment" = RIMD,
        table "RAA Assignment" = X,
        report "RAA Assignment Report" = X,
        page "RAA Assignment List" = X,
        tabledata "RAA Assignment Setup" = RIMD,
        table "RAA Assignment Setup" = X,
        page "RAA Assignment Setup" = X;
}