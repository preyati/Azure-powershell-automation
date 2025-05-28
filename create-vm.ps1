param(
    [string]$vmUsername,
    [string]$vmPassword
)

# Login to Azure using Service Principal credentials passed as environment variables
$securePassword = ConvertTo-SecureString $env:AZURE_CLIENT_SECRET -AsPlainText -Force
$psCredential = New-Object System.Management.Automation.PSCredential ($env:AZURE_CLIENT_ID, $securePassword)

Connect-AzAccount `
  -ServicePrincipal `
  -Credential $psCredential `
  -TenantId $env:AZURE_TENANT_ID `
  -SubscriptionId $env:AZURE_SUBSCRIPTION_ID

# Set variables
$resourceGroup = "demoRG"
$location = "canadacentral"
$vmName = "WinVM"

# Convert VM password to secure string
$password = ConvertTo-SecureString $vmPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vmUsername, $password)

# Create the resource group (if it doesn't exist)
New-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction SilentlyContinue

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

