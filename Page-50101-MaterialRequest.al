page 50101 "Material Request"
{
    PageType = Document;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.") WHERE("Document Type" = FILTER("Blanket Order"));
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = (Status = Status::Open) OR (Status = Status::Released);
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    Caption = 'Dummy Vendor No.';
                }
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
                    //Caption = 'Requesting Department';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
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
            part(PurchLines; "Material Request Subform")
            {
                // Editable = (Status = Status::Open) OR (Status = Status::Released);

                ApplicationArea = Suite;
                //Editable = "Buy-from Vendor No." <> '';
                // Enabled = "Buy-from Vendor No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {

                action(Approve)
                {
                    ApplicationArea = all;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = all;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = all;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = all;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            action(SendApprovalRequest)
            {
                ApplicationArea = all;
                Caption = 'Send A&pproval Request';
                Enabled = NOT OpenApprovalEntriesExist;
                Image = SendApprovalRequest;
                //Promoted = true;
                // PromotedCategory = Process;
                //PromotedIsBig = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                        ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                end;

            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = all;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                // Promoted = true;
                //PromotedCategory = Process;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                end;
            }
            action("Create RFQ")
            {
                ApplicationArea = all;
                Caption = 'Create RFQ';
                Image = Process;
                //  Promoted = true;
                //PromotedCategory = Process;
                Visible = Status = Status::Released;
                trigger OnAction()
                var
                    CurrentRecHeader: Record "Purchase Header";
                    CurrentRecLine: Record "Purchase Line";
                    NewRecHeader: Record "Purchase Header";
                    NewRecLine: Record "Purchase Line";
                begin
                    //-----------For Optional Vendor 1------------------
                    CurrentRecHeader.Reset();
                    CurrentRecHeader.SetRange("No.", "No.");
                    if CurrentRecHeader.FindFirst() then begin
                        CurrentRecLine.SetRange("Document No.", CurrentRecHeader."No.");
                        CurrentRecLine.SetRange("Created RFQ Line", false);
                        if CurrentRecLine.FindFirst() then
                            repeat
                                if CurrentRecLine."Vendor Optional 1" <> '' then begin
                                    NewRecHeader.Init();
                                    NewRecHeader."No." := '';
                                    NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 1";
                                    NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 1");
                                    NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                    NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                    NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                    NewRecHeader.Insert(true);
                                    NewRecLine.init;
                                    NewRecLine."Document No." := NewRecHeader."No.";
                                    NewRecLine.Type := CurrentRecLine.Type;
                                    NewRecLine."No." := CurrentRecLine."No.";
                                    NewRecLine.Description := CurrentRecLine.Description;
                                    NewRecLine.Quantity := CurrentRecLine.Quantity;
                                    NewRecLine.Insert(true);
                                    Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                    CurrentRecLine."Created RFQ Line" := true;
                                    CurrentRecLine.Modify(true);
                                end;
                                // until CurrentRecLine.Next() = 0;
                                //-----For Second Vendor----------------
                                // if CurrentRecLine.FindFirst() then
                                // repeat
                                if CurrentRecLine."Vendor Optional 2" <> '' then begin
                                    NewRecHeader.Init();
                                    NewRecHeader."No." := '';
                                    NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 2";
                                    NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 2");
                                    NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                    NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                    NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                    NewRecHeader.Insert(true);
                                    NewRecLine.init;
                                    NewRecLine."Document No." := NewRecHeader."No.";
                                    NewRecLine.Type := CurrentRecLine.Type;
                                    NewRecLine."No." := CurrentRecLine."No.";
                                    NewRecLine.Description := CurrentRecLine.Description;
                                    NewRecLine.Quantity := CurrentRecLine.Quantity;
                                    NewRecLine.Insert(true);
                                    Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                    CurrentRecLine."Created RFQ Line" := true;
                                    CurrentRecLine.Modify(true);
                                end;
                                //until CurrentRecLine.Next() = 0;
                                //-----------For Third Line-------------------
                                // CurrentRecLine.TestField("Vendor Optional 3");
                                // if CurrentRecLine.FindFirst() then
                                //   repeat
                                if CurrentRecLine."Vendor Optional 3" <> '' then begin
                                    NewRecHeader.Init();
                                    NewRecHeader."No." := '';
                                    NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 3";
                                    NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 3");
                                    NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                    NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                    NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                    NewRecHeader.Insert(true);
                                    NewRecLine.init;
                                    NewRecLine."Document No." := NewRecHeader."No.";
                                    NewRecLine.Type := CurrentRecLine.Type;
                                    NewRecLine."No." := CurrentRecLine."No.";
                                    NewRecLine.Description := CurrentRecLine.Description;
                                    NewRecLine.Quantity := CurrentRecLine.Quantity;
                                    NewRecLine.Insert(true);
                                    Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                    CurrentRecLine."Created RFQ Line" := true;
                                    CurrentRecLine.Modify(true);
                                end;
                                // until CurrentRecLine.Next() = 0;
                                //-----For Fourth Line-------------------
                                // if CurrentRecLine.FindFirst() then
                                //  repeat
                                if CurrentRecLine."Vendor Optional 4" <> '' then begin
                                    NewRecHeader.Init();
                                    NewRecHeader."No." := '';
                                    NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 4";
                                    NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 4");
                                    NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                    NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                    NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                    NewRecHeader.Insert(true);
                                    NewRecLine.init;
                                    NewRecLine."Document No." := NewRecHeader."No.";
                                    NewRecLine.Type := CurrentRecLine.Type;
                                    NewRecLine."No." := CurrentRecLine."No.";
                                    NewRecLine.Description := CurrentRecLine.Description;
                                    NewRecLine.Quantity := CurrentRecLine.Quantity;
                                    NewRecLine.Insert(true);
                                    Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                    CurrentRecLine."Created RFQ Line" := true;
                                    CurrentRecLine.Modify(true);
                                end;
                                //  until CurrentRecLine.Next() = 0;
                                //---------For 5th Line----------------------
                                //if CurrentRecLine.FindFirst() then
                                //   repeat
                                if CurrentRecLine."Vendor Optional 5" <> '' then begin
                                    NewRecHeader.Init();
                                    NewRecHeader."No." := '';
                                    NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 5";
                                    NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 5");
                                    NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                    NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                    NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                    NewRecHeader.Insert(true);
                                    NewRecLine.init;
                                    NewRecLine."Document No." := NewRecHeader."No.";
                                    NewRecLine.Type := CurrentRecLine.Type;
                                    NewRecLine."No." := CurrentRecLine."No.";
                                    NewRecLine.Description := CurrentRecLine.Description;
                                    NewRecLine.Quantity := CurrentRecLine.Quantity;
                                    NewRecLine.Insert(true);
                                    Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                    CurrentRecLine."Created RFQ Line" := true;
                                    CurrentRecLine.Modify(true);
                                end;
                            until CurrentRecLine.Next() = 0;

                    end;
































                    ///---------End For One Line--------------------------------
                    /// -------------------
                    /// -------------------------
                    /// --------------------------
                    /// ------------------------------------------
                    /// ------------Start for Second Line-----------------------
                    /// 
                    /*     //-----------For Optional Vendor 2------------------
                         CurrentRecHeader.Reset();
                         CurrentRecHeader.SetRange("No.", "No.");

                         if CurrentRecHeader.FindFirst() then begin
                             CurrentRecLine.SetRange("Document No.", CurrentRecHeader."No.");
                             CurrentRecLine.SetRange("Created RFQ Line", false);

                             if CurrentRecLine.FindFirst() then
                                 repeat
                                     CurrentRecLine.TestField("Vendor Optional 2");
                                     NewRecHeader.Init();
                                     NewRecHeader."No." := '';
                                     NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 2";
                                     NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 2");
                                     NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                     NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                     NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                     NewRecHeader.Insert(true);
                                     NewRecLine.init;
                                     NewRecLine."Document No." := NewRecHeader."No.";
                                     NewRecLine.Type := CurrentRecLine.Type;
                                     NewRecLine."No." := CurrentRecLine."No.";
                                     NewRecLine.Description := CurrentRecLine.Description;
                                     NewRecLine.Quantity := CurrentRecLine.Quantity;
                                     NewRecLine.Insert(true);
                                     Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                     CurrentRecLine."Created RFQ Line" := true;
                                     CurrentRecLine.Modify(true);
                                 until CurrentRecLine.Next() = 0;

                         end;
                         //--------------------For Vendor 3-----------------
                         CurrentRecHeader.Reset();
                         CurrentRecHeader.SetRange("No.", "No.");

                         if CurrentRecHeader.FindFirst() then begin
                             CurrentRecLine.SetRange("Document No.", CurrentRecHeader."No.");
                             CurrentRecLine.SetRange("Created RFQ Line", false);


                             if CurrentRecLine.FindFirst() then
                                 repeat
                                     CurrentRecLine.TestField("Vendor Optional 3");
                                     NewRecHeader.Init();
                                     NewRecHeader."No." := '';
                                     NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 3";
                                     NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 3");
                                     NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                     NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                     NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                     NewRecHeader.Insert(true);
                                     NewRecLine.init;
                                     NewRecLine."Document No." := NewRecHeader."No.";
                                     NewRecLine.Type := CurrentRecLine.Type;
                                     NewRecLine."No." := CurrentRecLine."No.";
                                     NewRecLine.Description := CurrentRecLine.Description;
                                     NewRecLine.Quantity := CurrentRecLine.Quantity;
                                     NewRecLine.Insert(true);
                                     Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                     CurrentRecLine."Created RFQ Line" := true;
                                     CurrentRecLine.Modify(true);
                                 until CurrentRecLine.Next() = 0;

                         end;
                         //----------------For Vendor 4----------------------

                         CurrentRecHeader.Reset();
                         CurrentRecHeader.SetRange("No.", "No.");

                         if CurrentRecHeader.FindFirst() then begin
                             CurrentRecLine.SetRange("Document No.", CurrentRecHeader."No.");
                             CurrentRecLine.SetRange("Created RFQ Line", false);


                             if CurrentRecLine.FindFirst() then
                                 repeat
                                     CurrentRecLine.TestField("Vendor Optional 4");
                                     NewRecHeader.Init();
                                     NewRecHeader."No." := '';
                                     NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 4";
                                     NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 4");
                                     NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                     NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                     NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                     NewRecHeader.Insert(true);
                                     NewRecLine.init;
                                     NewRecLine."Document No." := NewRecHeader."No.";
                                     NewRecLine.Type := CurrentRecLine.Type;
                                     NewRecLine."No." := CurrentRecLine."No.";
                                     NewRecLine.Description := CurrentRecLine.Description;
                                     NewRecLine.Quantity := CurrentRecLine.Quantity;
                                     NewRecLine.Insert(true);
                                     Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                     CurrentRecLine."Created RFQ Line" := true;
                                     CurrentRecLine.Modify(true);
                                 until CurrentRecLine.Next() = 0;

                         end;

                         //--------For Vendor 5------------------

                         CurrentRecHeader.Reset();
                         CurrentRecHeader.SetRange("No.", "No.");

                         if CurrentRecHeader.FindFirst() then begin
                             CurrentRecLine.SetRange("Document No.", CurrentRecHeader."No.");
                             CurrentRecLine.SetRange("Created RFQ Line", false);


                             if CurrentRecLine.FindFirst() then
                                 repeat
                                     CurrentRecLine.TestField("Vendor Optional 5");
                                     NewRecHeader.Init();
                                     NewRecHeader."No." := '';
                                     NewRecHeader."Buy-from Vendor No." := CurrentRecLine."Vendor Optional 5";
                                     NewRecHeader.Validate("Buy-from Vendor No.", CurrentRecLine."Vendor Optional 5");
                                     NewRecHeader."External Document No." := CurrentRecHeader."External Document No.";
                                     NewRecHeader."Posting Date" := CurrentRecHeader."Posting Date";
                                     NewRecHeader."RFQ No." := CurrentRecHeader."No.";
                                     NewRecHeader.Insert(true);
                                     NewRecLine.init;
                                     NewRecLine."Document No." := NewRecHeader."No.";
                                     NewRecLine.Type := CurrentRecLine.Type;
                                     NewRecLine."No." := CurrentRecLine."No.";
                                     NewRecLine.Description := CurrentRecLine.Description;
                                     NewRecLine.Quantity := CurrentRecLine.Quantity;
                                     NewRecLine.Insert(true);
                                     Message('RFQ Created For %1', NewRecHeader."Buy-from Vendor No.");
                                     CurrentRecLine."Created RFQ Line" := true;
                                     CurrentRecLine.Modify(true);
                                 until CurrentRecLine.Next() = 0;

                         end;*/
                end;



            }
            action("Print RFQ Report")
            {
                ApplicationArea = Suite;
                // Caption = 'Create RFQ';
                Image = Report;
                // Promoted = true;
                // PromotedCategory = Process;
                Visible = Status = Status::Released;
                trigger OnAction()
                var
                    CurrRecheader: Record "Purchase Header";

                begin
                    CurrRecheader.SetRange("No.", "No.");
                    if CurrRecheader.FindFirst() then
                        Report.RunModal(50061, true, false, CurrRecheader);
                end;
            }

        }

    }





    var
        myInt: Integer;
        OpenApprovalEntriesExist: Boolean;
        UserMgt: Codeunit "User Setup Management";

        OpenApprovalEntriesExistForCurrUser: Boolean;
        CanCancelApprovalForRecord: Boolean;
        RecPurchaseLines: Record "Purchase Line";
        RFQ: Report "Material Request Report";
        usersetup: Record "User Setup";
        Aprrover: Boolean;


    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    trigger OnOpenPage()
    begin

        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            FILTERGROUP(0);
        END;

    end;

    procedure createheader(Purcheader: Record "Purchase Header")

    var
        RFQHeader: Record "Purchase Header";
        ForPurchaseHeader: Record "Purchase Header";
        RecPurchaseHeader: Record "Purchase Header";
        RecPurchaseLine: Record "Purchase Line";
        QuoteLine: Record "Purchase Line";
        ForPurchaseLine: Record "Purchase Line";
    begin
        /* RFQHeader.Reset();
         RFQHeader.SetRange("No.", "No.");
         RFQHeader.SetRange("Document Type", "Document Type"::"Blanket Order");
         // RFQHeader.SetRange("Created RFQ Header", false);
         if RFQHeader.FindFirst() then
             if RecPurchaseHeader."No." <> RFQHeader."No." then begin
                 RecPurchaseLine.SetRange("Document No.", RFQHeader."No.");
                 RecPurchaseLine.SetRange("Document Type", "Document Type"::"Blanket Order");
                 RecPurchaseLine.SetRange("Created RFQ Line", false);
                 if RecPurchaseLine.FindFirst() then
                     repeat
                         RecPurchaseLine.TestField("Vendor Optional 1");
                         if RecPurchaseLine."Vendor Optional 1" <> '' then begin
                             RecPurchaseHeader.Init();
                             RecPurchaseHeader."Document Type" := RecPurchaseHeader."Document Type"::Quote;
                             RecPurchaseHeader."No." := '';
                             RecPurchaseHeader."Buy-from Vendor No." := RecPurchaseLine."Vendor Optional 1";
                             RecPurchaseHeader.Validate("Buy-from Vendor No.", RecPurchaseLine."Vendor Optional 1");
                             RecPurchaseHeader."Document Date" := RFQHeader."Document Date";
                             RecPurchaseHeader."External Document No." := RFQHeader."External Document No.";
                             RecPurchaseHeader."RFQ No." := RFQHeader."No.";
                             RecPurchaseHeader.Insert(true);
                             Message('Created %1', RecPurchaseHeader."Buy-from Vendor No.");

                         end;

                     until RecPurchaseLine.Next() = 0;
             end;
         /* ForPurchaseLine.Reset();
          ForPurchaseLine.SetRange("Document No.", RecPurchaseLine."Document No.");
          ForPurchaseLine.SetRange("Vendor Optional 1", RecPurchaseLine."Vendor Optional 1");*/
        /* if RecPurchaseLine.FindFirst() then
             repeat
                 RecPurchaseHeader.SetRange(RecPurchaseHeader."RFQ No.", RFQHeader."No.");
                 RecPurchaseHeader.SetRange("Buy-from Vendor No.", RecPurchaseLine."Vendor Optional 1");
                 if RecPurchaseHeader.FindFirst() then
                     repeat


                         QuoteLine.init;

                         QuoteLine."Document No." := RecPurchaseHeader."No.";

                         QuoteLine."No." := RecPurchaseLine."No.";
                         QuoteLine."Buy-from Vendor No." := ForPurchaseLine."Vendor Optional 1";
                         QuoteLine.Type := RecPurchaseLine.Type;
                         QuoteLine."Document Type" := QuoteLine."Document Type"::Quote;
                         QuoteLine.Quantity := RecPurchaseLine.Quantity;
                         QuoteLine.Description := RecPurchaseLine.Description;
                         QuoteLine."Line No." := RecPurchaseLine."Line No.";
                         RecPurchaseLine."Created RFQ Line" := true;
                         QuoteLine.Insert(true);
                         RecPurchaseLine.Modify(true);

                         Message('RFQ Created For %1', RecPurchaseLine."Vendor Optional 1");


                     until ForPurchaseLine.Next() = 0;
             until RecPurchaseHeader.Next() = 0;
     end;*/
        ForPurchaseHeader.Reset();
        ForPurchaseLine.Reset();
        ForPurchaseHeader.SetRange("Document Type", "Document Type"::Quote);
        ForPurchaseHeader.SetRange("RFQ No.", Rec."No.");

        if ForPurchaseHeader.FindFirst() then
            repeat
                ForPurchaseLine.SetRange(ForPurchaseLine."Document No.", ForPurchaseHeader."No.");
                if ForPurchaseLine.FindSet() then begin
                    RecPurchaseLine.SetRange("Document No.", "No.");

                    if RecPurchaseLine.FindFirst() then
                        repeat
                            ForPurchaseLine."No." := RecPurchaseLine."No.";
                            ForPurchaseLine.Description := RecPurchaseLine.Description;
                            ForPurchaseLine.Quantity := RecPurchaseLine.Quantity;
                            ForPurchaseLine."Line No." := RecPurchaseLine."Line No.";
                            ForPurchaseLine.Modify(true);
                        until RecPurchaseLine.Next() = 0;
                end;


            until ForPurchaseHeader.Next() = 0;
    end;
}