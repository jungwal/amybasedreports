page 50105 "Material Request List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.") WHERE("Document Type" = FILTER("Blanket Order"));
    CardPageId = 50101;

    layout
    {
        area(Content)
        {
            repeater("")
            {
                field("No."; "No.")
                {
                    Caption = 'Requisition No.';
                    ApplicationArea = All;

                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Caption = 'Requesting Department';
                    ApplicationArea = all;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                }

                field("User Name"; "User Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}