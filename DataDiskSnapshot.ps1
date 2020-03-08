#Get service principal details from shared resources
$cred = Get-AutomationPSCredential -Name 'SPCreds'
$tenantId = Get-AutomationVariable -Name 'TenantId'

#Auth with service principal
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenantId

#Get all Windows VMs in the WebServers resource group
$vms = Get-AzVM -ResourceGroupName webservers | 
  Where-Object {$_.StorageProfile.OsDisk.OsType -eq 'Windows'}

#Loop over each VMs data disks and cut a snapshot of them
foreach($vm in $vms) {
  $vmName = $vm.name
  $vm.StorageProfile.DataDisks | ForEach-Object {
    $snapConfig = New-AzSnapshotConfig -SourceUri $_.ManagedDisk.id -Location 'westus2' -CreateOption copy
    
    $snap = New-AzSnapshot -Snapshot $snapConfig -SnapshotName "$vmName-$($_.name)-snap-$((Get-Date).ToString('MM-dd-yyyy'))" -ResourceGroupName webservers
    
    Set-AzResource -ResourceId $snap.Id -Tag @{Created=(Get-Date).ToLongDateString()} -Force
  }
}