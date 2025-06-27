function New-HuduNetwork {
    <#
    .SYNOPSIS
    Creates a new network in Hudu.

    .DESCRIPTION
    Sends a POST request to the Hudu API to create a new network with the specified parameters.

    .PARAMETER Name
    The name of the network.

    .PARAMETER Description
    The description of the network.

    .PARAMETER Address
    The network address (e.g., 192.168.1.0/24).  API will validate this is a valid CIDR notation and throw an error if it is not.

    .PARAMETER CompanyId
    The ID of the company associated with the network.

    .PARAMETER VlanId
    The VLAN ID for the network.

    .PARAMETER Archived
    Boolean indicating if the network is archived.

    .EXAMPLE
    New-HuduNetwork -Name "Office Network" -Description "Main office local network" -Address "192.168.1.0/24" -NetworkType 1 -CompanyId 5 -LocationId 12 -VlanId 100 -Archived $false
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter(Mandatory)]
        [string]$Address,

        [Parameter(Mandatory)]
        [int]$CompanyId,

        [Parameter()]
        [int]$VlanId,

        [Parameter()]
        [bool]$Archived = $false
    )
    
    $Network = [ordered]@{network = [ordered]@{} }

    $Network.Network.add('name', $Name)

    if ($Description) {
        $Network.Network.add('description', $Description)
    }

    $Network.Network.add('company_id', $CompanyId)

    $Network.Network.add('address', $Address)

    if ($VlanId) {
        $Network.Network.add('vlan_id', $VlanId)
    }

    if ($Archived) {
        $Network.Network.add('archived', $Archived)
    }    

    $JSON = $Network | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess($Name)) {
        Invoke-HuduRequest -Method post -Resource '/api/v1/networks' -Body $JSON
    }
}
