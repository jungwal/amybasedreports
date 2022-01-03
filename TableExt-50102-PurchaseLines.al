tableextension 50102 PurchseLines extends "Purchase line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Vendor Optional 1"; code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50002; "Vendor Optional 2"; code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50003; "Vendor Optional 3"; code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50004; "Vendor Optional 4"; code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50005; "Vendor Optional 5"; code[30])
        {
            TableRelation = Vendor."No.";
        }
        field(50006; "Created RFQ Line"; Boolean)
        {

        }
        field(50007; "Need Date"; Date)
        {

        }
        field(50009; Remarks; Text[250])
        {

        }
        field(50010; "Target Field"; Decimal)
        {

        }
    }

    var
        myInt: Integer;
}