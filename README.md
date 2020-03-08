# Demo Automation Runbooks

These Runbooks show two examples of how to automate routine tasks with Azure Automation.

* DataDiskSnapshot - a runbook designed to run on a schedule that takes a snapshot of VM data disks for all Windows Servers in a specific resource group
* StopVM - a runbook designed to be invoked via webhook to shutdown VMs identified in the request body

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
Add the function to your shell session (paste it in or dot source it from a script) and then:

```
New-Sp -Name <SP NAME> -Password <PASSWORD>
```

# Working with the StopVM Runbook

After you create a webhook for the StopVM Runbook you can use the following PowerShell snippet to invoke your Runbook via the webhook. This example would shutdown two VMs name web1 and web2 in the "webservers" resource group:

```

$uri = "https://s4events.azure-automation.net/webhooks?token=<YOUR TOKEN>"

$vms  = @(
            @{ Name="web1";ResourceGroup="webservers"},
            @{ Name="web2";ResourceGroup="webservers"}
        )

$body = ConvertTo-Json -InputObject $vms
$header = @{ message="Started by CloudSkills.io"}

Invoke-WebRequest -Method Post -Uri $uri -Body $body -Headers $header

```
