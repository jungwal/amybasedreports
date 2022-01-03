pageextension 50103 PurchaseQuote extends "Purchase Quote"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Order No.")
        {
            field("RFQ No."; "RFQ No.")
            {
                ApplicationArea = all;
                Caption = 'RFQ No.';
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