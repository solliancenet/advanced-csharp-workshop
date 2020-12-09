Param (
  [Parameter(Mandatory = $true)]
  [string]
  $azureUsername,

  [string]
  $azurePassword,

  [string]
  $azureTenantID,

  [string]
  $azureSubscriptionID,

  [string]
  $odlId,
    
  [string]
  $deploymentId
)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

mkdir c:\labfiles -ea silentlycontinue;

#download the solliance pacakage
$WebClient = New-Object System.Net.WebClient;
$WebClient.DownloadFile("https://raw.githubusercontent.com/solliancenet/common-workshop/main/scripts/common.ps1","C:\LabFiles\common.ps1")

#run the solliance package
. C:\LabFiles\Common.ps1

DisableInternetExplorerESC

EnableIEFileDownload

InstallChocolaty;

InstallAzPowerShellModule

InstallNotepadPP;

$ext = @("ms-vscode.azurecli")
InstallVisualStudioCode $ext

InstallDotNetCore "3.1"

InstallDotNet5;

InstallGit;

InstallFiddler;

InstallPostman;

InstallAzureCli;

InstallPorter;

InstallDocker;

InstallDockerWin10;

InstallEdge;

InstallChrome;

$vsVersion = "community"
$year = "2019"
InstallVisualStudio $vsVersion $year;

UpdateVisualStudio $vsVersion $year;

AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.Azure";
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.NetCoreTools"
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.NetWeb"
AddVisualStudioWorkload $vsVersion "Component.GitHub.VisualStudio"
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Component.Git"

CreateLabFilesDirectory

cd "c:\labfiles";

CreateCredFile $azureUsername $azurePassword $azureTenantID $azureSubscriptionID $deploymentId $odlId

. C:\LabFiles\AzureCreds.ps1

$userName = $AzureUserName                # READ FROM FILE
$password = $AzurePassword                # READ FROM FILE
$clientId = $TokenGeneratorClientId       # READ FROM FILE

Uninstall-AzureRm

$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword

Connect-AzAccount -Credential $cred | Out-Null
         
#install sql server cmdlets
Install-Module -Name SqlServer

cd "c:\labfiles";

git clone https://github.com/solliancenet/advanced-dotnet-workshop

sleep 20

git clone https://github.com/kendrahavens/DevIntersection2020

sleep 20

git clone https://github.com/KathleenDollard/sample-csharp-6-9

sleep 20

Stop-Transcript

Restart-Computer -Force

return 0;