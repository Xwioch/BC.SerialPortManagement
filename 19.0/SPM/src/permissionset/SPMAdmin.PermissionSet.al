permissionset 61000 "SPM.Admin"
{
    Caption = 'SPM.Admin';
    Assignable = true;

    Permissions =
        table "SPM Serial Port" = X,
        table "SPM Serial Port Buffer" = X,

        tabledata "SPM Serial Port" = RIMD,
        tabledata "SPM Serial Port Buffer" = RIMD,

        page "SPM Serial Port Connection" = X;
}