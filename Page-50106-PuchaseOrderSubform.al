pageextension 50106 purchaseordersubform extends "Purchase order subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Amount")
        {
            field("Target Field"; "Target Field")
            {
                ApplicationArea = all;
                Caption = 'PR Budgeted Amount';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}