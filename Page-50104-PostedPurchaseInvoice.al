pageextension 50104 PostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Order No.")
        {
            field("RFQ No."; "RFQ No.")
            {
                ApplicationArea = all;
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