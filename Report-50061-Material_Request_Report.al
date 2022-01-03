report 50061 "Material Request Report"
{

    ApplicationArea = All;
    Caption = 'Material Request';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'MaterialRequest.rdl';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST("Blanket Order"));
            column(No_; "No.")
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {

            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {

            }
            column(Priority; Priority)
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(User_Name; "User Name")
            {

            }
            column(CompanyName; CompanyInformation.Name)
            {

            }
            column(Company_Picture; CompanyInformation.Picture)
            {

            }
            column(Adress; Adress)
            {

            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
                Adress := StrSubstNo('%1 %2 %3 %4', CompanyInformation.Address, CompanyInformation."Address 2", CompanyInformation.City, CompanyInformation."Country/Region Code");
            end;


        }
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemLinkReference = "Purchase Header";
            DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            column(Type; Type)
            {

            }
            column(itemNo_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Need_Date; "Need Date")
            {

            }
            column(Vendor_Optional_1; "Vendor Optional 1")
            {

            }
            column(Vendor_Optional_2; "Vendor Optional 2")
            {

            }
            column(Vendor_Optional_3; "Vendor Optional 3")
            {

            }
            column(Vendor_Optional_4; "Vendor Optional 4")
            {

            }
            column(Vendor_Optional_5; "Vendor Optional 5")
            {

            }
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /* field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     }*/
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
        CompanyInformation: Record "Company Information";
        Adress: Text[250];
}