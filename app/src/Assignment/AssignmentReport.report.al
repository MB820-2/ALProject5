report 50100 "RAA Assignment Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = WordLayout;

    dataset
    {
        dataitem("RAA Assignment"; "RAA Assignment")
        {

            column(No_RAAAssignment; "No.")
            {
            }
            column(Title_RAAAssignment; Title)
            {
            }
            column(Description_RAAAssignment; Description)
            {
            }
            column(Status_RAAAssignment; Status)
            {
            }
            column(UserId_RAAAssignment; "User Id")
            {
            }
        }
    }


    rendering
    {
        layout(ExcelLayout)
        {
            Type = Excel;
            LayoutFile = './src/Assignment/Layout/AssignmentReport.xlsx';
        }

        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = './src/Assignment/Layout/AssignmentReport.docx';
        }
    }
}