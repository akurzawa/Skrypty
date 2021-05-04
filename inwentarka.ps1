hello
<#zmienne:

co w pliku?

- data wykonania skanu
- hostaneme
- whoami
- wersja windowsa home pro
- ram
- czy komp wpiety w domene
- lista softu
#>


#gdzie
$path = "C:\Temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
Set-Location C:\Temp
$dataczas = Get-Date -Format "yyMMddHHmm"
$serialnumber = (gwmi win32_bios).serialnumber
$nazwa_pliku = -join @($serialnumber,"_",$dataczas,".txt")
md $serialnumber
New-Item $serialnumber\$nazwa_pliku
Set-Location C:\Temp\$serialnumber

#funkcja zrzutDoLoga
function LOG
{
}

$dataczas = Get-Date -Format "yyMMddHHmm"
$serialnumber = (gwmi win32_bios).serialnumber
$ram = (gwmi win32_physicalmemory).capacity
$os = (Get-WmiObject -class Win32_OperatingSystem).Caption
$disk = Get-PhysicalDisk | Select MediaType, Size
$cpu = (gwmi win32_Processor).name

$tablica = @(
$dataczas
Write-Output "=======================================================================";
Write-Output "Windows Version:";
$os
Write-Output "=======================================================================";
Write-Output "Nazwa komputera:";
$env:ComputerName
Write-Output "=======================================================================";
Write-Output "Serial Number:";
$serialnumber
Write-Output "=======================================================================";
Write-Output "Disk Type:";
$disk
Write-Output "=======================================================================";
Write-Output "RAM size:";
$ram
Write-Output "=======================================================================";
Write-Output "Proccessor:";
$cpu
)
$tablica | Out-File -Append $nazwa_pliku
Get-WmiObject -Class Win32_Product | select Name, Vendor, Version >> $nazwa_pliku
Write-Output "*********************************************************************************************************************";



$Dir="C:\Temp\$serialnumber\nazwa_pliku"
$ftp = "ftp://ftp.pdsa.pdsa.pl/inventura"
$user = "inventura"
$pass = "inventura"
$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)

foreach($item in (dir $Dir "*.trc")){ 
"Uploading $item..."
$uri = New-Object System.Uri($ftp+$item.Name) 
$webclient.UploadFile($uri, $item.FullName) 
 }
