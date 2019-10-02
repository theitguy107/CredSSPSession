# CredSSPSession

This module automates the process of opening a remote PowerShell session into a server with CredSSP authentication. By default, administrators are unable to connect to a erver from a remote session of another server. This is called a "double-hop" phenomenon. For example, you cannot open a remote PowerShell session and then copy files from that server to another file share even if your PowerShell user has NTFS and share permissions to that folder. The solution is to use Credential Security Support Provider (CredSSP) which provides a TLS-encrypted connection using Kerberos or NTLM for authentication. (You can read more about CredSSP [here](https://docs.microsoft.com/en-us/windows/desktop/SecAuthN/credential-security-support-provider).)

Normally, opening a CredSSP remote PowerShell session with a server requires 3 steps:

1. Enable CredSSP with server role on the server.
2. Enable CredSSP with client role on your workstation.
3. Open a remote PowerShell session with CredSSP.

This module automates all these steps into one with the Enter-CredSSPSession cmdlet. It also also can automate disabling CredSSP on both server and client with the Exit-CredSSPSession cmdlet.

## Prerequisites

* PowerShell 5.1 and greater (Should also work on version 4.0 and above, but I have not tested it).
* GPO object allowing delegation of fresh credentials (see installation instructions below).

## Installing

There are two steps required to use this module: (1) Create a CredSSP GPO, (2) Install the module.

### Create a CredSSP GPO

1. Create a new group policy object called CredSSP and enable this setting: "Computer Configuration/Policies/Administrative Templates/System/Credentials Delegation/Allow delegating fresh credentials"

2. Click the Show button and add either your domain or server(s) to the list. If you wish to use CredSSP authentication on all servers on your network, enter WSMAN/*.domain (e.g., WSMAN/*.company.com). If you only wish to add one or more servers to the list, add them as WSMAN/server.domain (e.g., WSMAN/domaincontroller.company.com).

### Install the module

1. Open PowerShell and install the module with this command:

Install-Module -Name CredSSPSession

## Using this module

This module features two cmdlets: Enter-CredSSPSession and Exit-CredSSPSession.

### Enter-CredSSPSession

	NAME
		Enter-CredSSPSession
		
	SYNOPSIS
		Enters a remote PowerShell session into a server using CredSSP authentication.
		
		
	SYNTAX
		Enter-CredSSPSession [-Server] <Object> [-Credential] <Object> [<CommonParameters>]
		
		
	DESCRIPTION
		By default, users cannot perform a "double-hop" by accessing another server via a remote PowerShell session.
		CredSSP authentication is required in order for this to happen, but connecting in this way requires several steps.
		This function automates this process.
		

	PARAMETERS
	NAME
		Enter-CredSSPSession
		
	SYNOPSIS
		Enters a remote PowerShell session into a server using CredSSP authentication.
		
		
	SYNTAX
		Enter-CredSSPSession [-Server] <Object> [-Credential] <Object> [<CommonParameters>]
		
		
	DESCRIPTION
		By default, users cannot perform a "double-hop" by accessing another server via a remote PowerShell session.
		CredSSP authentication is required in order for this to happen, but connecting in this way requires several steps.
		This function automates this process.
		

	PARAMETERS
		-Server <Object>
        The fully qualified domain name of the server you wish to connect to.
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Credential <Object>
        The administrator credential you wish to use to connect. Enter using the following syntax: DOMAIN\USER
        
        Required?                    true
        Position?                    2
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
	INPUTS
		
	OUTPUTS
		
	NOTES
    
    
        Author: Joshua Morden
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Enter-CredSSPSession -Server myserver.mydomain.org -Credential mydomain.org\domainadmin
    
    ...
    
    You have opened a CredSSP Remote PowerShell Session with myserver.mydomain.org.
    When finished, exit the remote PS session with 'exit' and then use command 'Exit-CredSSPSession' to disable CredSSP on the remote server and your PC.
    
    
    [myserver.mydomain.org]: PS C:\Users\domainadmin\Documents>

### Exit-CredSSPSession

	NAME
		Exit-CredSSPSession
		
	SYNOPSIS
		Exits a CredSSP remote PowerShell session on a server and disables CredSSP on the server and client.
		
		
	SYNTAX
		Exit-CredSSPSession [-Server] <Object> [-DisableClient] [<CommonParameters>]
		
		
	DESCRIPTION
		This cmdlet disables CredSSP on a server with the option to disable CredSSP on your workstation if desired. This command should be used after
		

	PARAMETERS
		-Server <Object>
        The fully qualified domain name of the server you are connected to.
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -DisableClient [<SwitchParameter>]
        This is an optional switch parameter that disables CredSSP on your workstation when used.
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Exit-CredSSPSession -Server myserver.mydomain.org
    
    CredSSP has been disabled on the remote server and your PC.
    
    PS C:\>
    
    Description
    
    -----------
    
    Disable CredSSP on the server and leave CredSSP enabled on your workstation. This is a good option to use if you are working on multiple servers at a time.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Exit-CredSSPSession -Server myserver.mydomain.org -DisableClient
    
    Description
    
    -----------
    
    Disable CredSSP on both the server and your workstation.

## Versioning

1.1

## Authors

Joshua Morden

## Acknowledgments

These are the resources that were very helpful in the writing of this module. Thank you to everyone!

* Microsoft PowerShell Documentation
* https://riptutorial.com/powershell/example/27240/create-a-module-manifest
* Adam Bertram - https://www.youtube.com/watch?v=ssl0dNDl3hE
* Ed Wilson - https://devblogs.microsoft.com/scripting/enable-powershell-second-hop-functionality-with-credssp/