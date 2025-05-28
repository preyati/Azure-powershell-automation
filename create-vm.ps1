param(
    [string]$vmUsername,
    [string]$vmPassword
)

# Set variables
$resourceGroup = "demoRG"
$location = "canadacentral"
$vmName = "WinVM"

# Convert plain password to secure string
$password = ConvertTo-SecureString $vmPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vmUsername, $password)

# Login to Azure (only if running locally)
#if (-not (Get-AzContext)) {
#    Connect-AzAccount
#}

# Create the resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create the VM
New-AzVm `
    -ResourceGroupName $resourceGroup `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkName "${vmName}VNET" `
    -SubnetName "${vmName}Subnet" `
    -SecurityGroupName "${vmName}NSG" `
    -PublicIpAddressName "${vmName}PublicIP" `
    -Credential $cred `
    -ImageName "Win2019Datacenter" `
    -OpenPorts 80,3389
