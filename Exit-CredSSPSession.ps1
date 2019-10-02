Function Exit-CredSSPSession
{
	<#
	.SYNOPSIS
		Exits a CredSSP remote PowerShell session on a server and disables CredSSP on the server and client.

    .DESCRIPTION
        This cmdlet disables CredSSP on a server with the option to disable CredSSP on your workstation if desired. This command should be used after

	.PARAMETER Server
		The fully qualified domain name of the server you are connected to.

    .PARAMETER DisableClient
        This is an optional switch parameter that disables CredSSP on your workstation when used.

	.EXAMPLE
        PS C:\>Exit-CredSSPSession -Server myserver.mydomain.org
        CredSSP has been disabled on the remote server and your PC.

  PS C:\>

    Description
    
    -----------

  		Disable CredSSP on the server and leave CredSSP enabled on your workstation. This is a good option to use if you are working on multiple servers at a time.
        
        
    .EXAMPLE

        PS C:\>Exit-CredSSPSession -Server myserver.mydomain.org -DisableClient

    Description
    
    -----------

        Disable CredSSP on both the server and your workstation.

		
	.NOTES
		Author: Joshua Morden

	#>

param(
[Parameter(Mandatory=$true)]
$Server,
[Parameter()]
[Switch]$DisableClient
)


#Disable CredSSP on the remote server.
Invoke-Command -ComputerName $Server -ScriptBlock {Disable-WSManCredSSP -Role Server}

#Disable CredSSP on the user's workstation
if ($DisableClient.IsPresent)
    {
        Disable-WSManCredSSP -Role Client
    }

}
