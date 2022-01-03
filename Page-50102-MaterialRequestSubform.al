page 50102 "Material Request Subform"
{

    AutoSplitKey = true;
    LinksAllowed = false;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = listPart;
    // ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Purchase Line";
    // SourceTableView = SORTING("Document Type", "No.") WHERE("Document Type" = FILTER("Blanket Order"));
    SourceTableView = WHERE("Document Type" = FILTER("Blanket Order"));
    layout
    {
        area(Content)
        {
            repeater("")
            {
                Editable = editPage;

                field(Type; Type)
                {
                    ApplicationArea = All;

                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Need Date"; "Need Date")
                {
                    ApplicationArea = all;
                }
                field("Target Field"; "Target Field")
                {
                    ApplicationArea = all;
                    Caption = 'Target Amount';
                }
                field(Remarks; Remarks)
                {

                    ApplicationArea = all;
                }
                field("Vendor Optional 1"; "Vendor Optional 1")
                {
                    Visible = Show;
                    ApplicationArea = all;
                }
                field("Vendor Optional 2"; "Vendor Optional 2")
                {
                    Visible = Show;
                    ApplicationArea = all;
                }
                field("Vendor Optional 3"; "Vendor Optional 3")
                {
                    Visible = Show;
                    ApplicationArea = all;
                }
                field("Vendor Optional 4"; "Vendor Optional 4")
                {
                    Visible = Show;
                    ApplicationArea = all;

                }
                field("Vendor Optional 5"; "Vendor Optional 5")
                {
                    Visible = Show;

                    ApplicationArea = all;
                }
                field("Created RFQ Line"; "Created RFQ Line")
                {
                    Caption = 'RFQ Created';
                    ApplicationArea = all;

                    //Editable = false;
                }


            }

        }

    }


    actions
    {
        area(Processing)
        {
            action("Dimensions")
            {
                ApplicationArea = All;
                Image = Dimensions;


                trigger OnAction()
                begin
                    ShowDimensions;

                end;
            }
        }
    }

    var
        myInt: Integer;
        PurchaseHeader: Record "Purchase Header";
        Show: Boolean;
        EditPAge: Boolean;



    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Line No." += "Line Amount" + 1000;
    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", "Document No.");
        if PurchaseHeader.FindSet() then begin
            if PurchaseHeader.Status = PurchaseHeader.Status::Released then
                Show := true;

        end;


    end;

    trigger OnAfterGetCurrRecord()
    begin
        PurchaseHeader.SetRange("No.", "Document No.");
        if PurchaseHeader.FindSet() then
            if (PurchaseHeader.Status = PurchaseHeader.Status::Released) OR (PurchaseHeader.Status = PurchaseHeader.Status::Open) then begin


                CurrPage.Editable(true);

                EditPAge := true;
            end;
    end;


}