<#-------------------------------------------------#>
<# (c) 2020 B&R Vision Demo Team                   #>
<#-------------------------------------------------#>
Param (
    [Parameter(Mandatory=$false, HelpMessage='Use $(WIN32_AS_PROJECT_PATH) in AS settings.')][string]$ProjectPath,
    [Parameter(Mandatory=$false, HelpMessage='Use $(AS_CONFIGURATION) in AS settings.')][string]$ProjectCfg
 )
echo "------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------"
echo "RouteInfo_Tool.ps1 (c) 2020 B&R Vision Demo Team"
echo "------------------------------------------------------------------------------------"
<#-------------------------------------------------#>
<# Check if files exist                            #>
<#-------------------------------------------------#>
echo "Searching file <Vi_Image\Main>..."
$ViImageFile  = "$($PSScriptRoot)\Vi_Image\Main.st"
if(![System.IO.File]::Exists($ViImageFile)){
    echo "ERROR: File <Vi_Image\Main.st> not found! Exiting!"
    exit;
}
echo "<Vi_Image\Main.st> found: $g_ViImageFile"
echo "Searching file <Hardware.hw>..."
if(!$PSBoundParameters.ContainsKey('ProjectPath') -or !$PSBoundParameters.ContainsKey('ProjectCfg')){
    echo "ERROR: File <Hardware.hw> not found, parameter missing! Exiting!"
    exit;
} else {
    if($ProjectPath -eq "" -or $ProjectCfg -eq ""){
        echo "ERROR: File <Hardware.hw> not found, parameter empty! Exiting!"
        exit;
    }
}
$HwFile = "$($ProjectPath)\Physical\$($ProjectCfg)\Hardware.hw"
if(![System.IO.File]::Exists($HwFile)){
    echo "ERROR: File <Hardware.hw> not found! Exiting!"
    exit;
}
echo "<Hardware.hw> found: $g_HwFile"

<#-------------------------------------------------#>
<# Load Hardware.hw file content (ETH IP)          #>
<#-------------------------------------------------#>
$NewFile = Get-Content $HwFile
$pattern = "`"(?smi)IF2.*?InternetAddress`" Value=`"(.*?)`""
$EthIP = [Regex]::Match($NewFile, $pattern)
$EthIpStr = $EthIP.Groups[1].Value
echo "IF2 (Ethernet) IP Address: $EthIpStr"

$NewFile = Get-Content $ViImageFile
$pattern = "(?smi)PlkIPWithoutNode.*?:= '(.*?)'"
$PlkIP = [Regex]::Match($NewFile, $pattern)
$PlkIpStr = $PlkIP.Groups[1].Value + "0"
echo "IFx (Powerlink) IP Address: $PlkIpStr (needs to be set at the PLK IF!)"
echo "To create the route in windows, open the Command Prompt with Administrator rights and create a route with the following command"
echo "route add $PlkIpStr mask 255.255.255.0 $EthIpStr"
echo "Description: route add <Powerlink IF IP address with 0 at the end> mask 255.255.255.0 <Eth IP of the PLC>"
echo "Hint: If the route already exists, you can delete it"
echo "route delete $PlkIpStr"
echo " ... OK!"
echo "------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------"
