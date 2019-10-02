Function Enter-CredSSPSession
{
	<#
	.SYNOPSIS
		Enters a remote PowerShell session into a server using CredSSP authentication.

	.DESCRIPTION
		By default, users cannot perform a "double-hop" by accessing another server via a remote PowerShell session.
  CredSSP authentication is required in order for this to happen, but connecting in this way requires several steps.
  This function automates this process.
	
	.PARAMETER Server
		The fully qualified domain name of the server you wish to connect to.

	.PARAMETER Credential
		The administrator credential you wish to use to connect. Enter using the following syntax: DOMAIN\USER
		
	.EXAMPLE
		PS C:\>Enter-CredSSPSession -Server myserver.mydomain.org -Credential mydomain.org\domainadmin
        
        ...

  You have opened a CredSSP Remote PowerShell Session with myserver.mydomain.org.
  When finished, exit the remote PS session with 'exit' and then use command 'Exit-CredSSPSession' to disable CredSSP on the remote server and your PC.


  [myserver.mydomain.org]: PS C:\Users\domainadmin\Documents>
		
	.NOTES
		Author: Joshua Morden

	#>

param(
[Parameter(Mandatory=$true)]
$Server,
[Parameter(Mandatory=$true)]
$Credential
)

#Enable CredSSP on the remote server.
Invoke-Command -ComputerName $Server -ScriptBlock {Enable-WSManCredSSP -Role Server -Force}
Invoke-Command -ComputerName $Server -ScriptBlock {Restart-Service -Name WinRM}

#Enable CredSSP on client machine
Enable-WSManCredSSP -DelegateComputer "$env:computername.$env:userdnsdomain" -Role Client -Force

#Open the CredSSP Remote PowerShell Session.
Enter-PSSession -ComputerName $Server -Authentication Credssp -credential $Credential
Write-Host ""
Write-Host "You have opened a CredSSP Remote PowerShell Session with $Server."
Write-Host "When finished, exit the remote PS session with 'exit' and then use command 'Exit-CredSSPSession' to disable CredSSP on the remote server."
Write-Host ""

}