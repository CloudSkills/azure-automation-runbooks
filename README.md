# azure-automation-runbooks

These Runbooks expect that you've created a Service Principal and have added the following items to shared resources:

* SPCreds (credential resource for the service principal)
* TenantId (variable resource for tenant id)

Here's a PowerShell function you can use to quickly create a service principal

```
function New-Sp {
  param($Name, $Password)

  $spParams = @{ 
    StartDate = Get-Date
    EndDate = Get-Date -Year 2030
    Password = $Password
  }

  $cred= New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property $spParams
  $sp = New-AzAdServicePrincipal -DisplayName $Name -PasswordCredential $cred

  Write-Output $sp
}
```
