tableextension 50001 PurchaseHeader extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Priority"; Option)
        {
            OptionMembers = "Low","Medium","High";
        }
        field(50001; "External Document No."; text[50])
        {

        }
        field(50002; "Notes to Store"; Text[250])
        {

        }
        field(50003; "User Name"; code[50])
        {

        }
        field(50004; "Created RFQ Header"; Boolean)
        {

        }
        field(50005; "RFQ No."; Code[30])
        {

        }


    }


    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "User Name" := UserId;

    end;
}