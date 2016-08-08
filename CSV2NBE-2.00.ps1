#CSV2NBE 1/19/16 Jason Adipietro -  jadipietro@reliaquest.com
#Version 2.00
#This script will convert a Nessus CSV scan to NBE format to import into Alienvault
#Open a GUI to select the CSV file to be converted
Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}
$inputfile = Get-FileName
$csv = import-csv $inputfile
#Get the output file name
$outfile = read-host "What do you want to the output NBE file to be called?"
#Read CSV into NBE format
$line=1
foreach ($row in $csv){
    "results|"+$row.Host+"|"+$row.Host+"|"+$row.Port+"/"+$row.Protocol+"|"+$row."Plugin ID"+"|Security Note|Synopsis :\n\n"+$row.Synopsis+" \n\nDescription :\n\n"+$row.Description+" \n\nSolution :\n\n"+$row.Solution+" \n\nRisk Factor :\n\n"+$row.Risk+" / CVSS Base Score: "+$row.CVSS+" \n\nPlugin output :\n\n"+$row."Plugin Output"+" \n\nCVE:"+$row.CVE+"\n" | out-file -Append -Filepath $outfile -encoding Ascii
    [string]$line +"/"+ [string]$csv.count
    $line++
}
#Remove line feeds from converted file and adds a "\n" for Perl to create a new line, then add a line feed behind each carriage return to seperate results.
(get-content .\$outfile -Raw).Replace("`n","\n") | set-content .\$outfile -Force
(get-content .\$outfile -Raw).Replace("`r","`r`n") | set-content .\$outfile -Force
(get-content .\$outfile -Raw).Replace("\nresults","results") | set-content .\$outfile -Force
Exit
