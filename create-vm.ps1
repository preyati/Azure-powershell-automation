# Set variables
$resourceGroup = "demoRG"
$location = "canadacentral"
$vmName = "WinVM"
$username = "azureuser"
$password = ConvertTo-SecureString "Pkd@1012122000" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# Login to Azure (only needed when running locally)
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
    -OpenPorts 80,3389 `

