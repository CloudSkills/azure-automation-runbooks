# azure-automation-runbooks

These Runbooks expect that you've created a Service Principal and have added the following items to shared resources:

* SPCreds (credential resource for the service principal)
* TenantId (variable resource for tenant id)

Here's a PowerShell function you can use to quickly create a service principal

<script src="https://gist.github.com/mikepfeiffer/b2cc488985e675de7e8c8d38a0943539.js"></script>
