# Append these two functions

# global variables
$CYBERARK_HOST = "cyberark-fra.oa.pnrad.net"
$CYBERARK_API = "https://$CYBERARK_HOST/PasswordVault/API"

function castorecred {
 
    $cred_file = "$env:USERPROFILE\.ssh\user_cred.xml"
    $credential = Get-Credential
    $credential | Export-CliXml -Path $cred_file
    Write-Host ('User "' + $credential.username + '" credentials stored in file: ' + $cred_file) -ForegroundColor Green
  
}

function ca_api {
    param (
        [Parameter(Mandatory = $true)]
        [string]$data,
        [Parameter(Mandatory = $true)]
        [string]$url
    )

    $headers = @{
        "authorization" = $CYBERARK_TOKEN
        "content-type"  = "application/json"
    }

    Invoke-RestMethod -Uri $url -Method Post -Body $data -Headers $headers
}

function ca_api_get {
    param (
        [Parameter(Mandatory = $true)]
        [string]$url
    )

    $headers = @{
        "authorization" = $CYBERARK_TOKEN
        "content-type"  = "application/json"
    }

    Invoke-RestMethod -Uri $url -Headers $headers    
}

function ca_get_credential {
    $CRED_FILE = "$env:USERPROFILE\.ssh\user_cred.xml"
    # get user credentials from file, if stored
    if (Test-Path $CRED_FILE) {
        $credential = Import-CliXml -Path $CRED_FILE
        if (!$?) {
            Write-Host "There is issue with reading credential file, please input manually"
            $credential = Get-Credential
        }
    }
    else {
        $credential = Get-Credential
    }
    $credential
}

function ca_get_token {
    $ErrorActionPreference = "Stop"
    $CYBERARK_LOGON = "$CYBERARK_API/auth/RADIUS/Logon"
    $CYBERARK_TOKEN = ""

    $credential = ca_get_credential

    $POST_DATA = @{
        username          = $credential.username
        password          = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.password))
        concurrentSession = $true
    } | ConvertTo-Json

    Write-Host "Obtaining token (approve the request in authenticator)"

    $TOKEN = (ca_api -data $POST_DATA -url $CYBERARK_LOGON).Trim('"')

    $TOKEN
}


function carenewtoken {
    $TOKEN_FILE = "$env:USERPROFILE\.ssh\user_token.xml"
    $data = @{
        token = "" 
    }

    # get user token from file, if stored
    if (Test-Path $TOKEN_FILE) {
        $data = Import-CliXml -Path $TOKEN_FILE
        if (!$?) {
            Write-Host "No valid token found"
            $data.token = ca_get_token
        }
        else {
            try {
                $CYBERARK_TOKEN = $data.token
                $noout = ca_api_get $CYBERARK_API/PSM/Servers/
                Write-Host "Token still valid, reusing"
            }
            catch {
                if ($_.Exception.Response.StatusCode.value__ -ge 400) {
                    Write-Host "Token expired"
                    $data.token = ca_get_token
                }
            }
        }
    }
    else {
        Write-Host "No token file found"
        $data.token = ca_get_token
    }

    $data | Export-CliXml -Path $TOKEN_FILE

    ($data.token).trim()
}


function cagetcert {
    $ErrorActionPreference = "Stop"
    $CYBERARK_KEYGEN = "$CYBERARK_API/Users/Secret/SSHKeys/Cache"
    $SSH_OUTPUT_PRIVKEY = "$env:USERPROFILE\.ssh\cyberark-ssh-mfa.key"

    # Write-Host $POST_DATA

    $CYBERARK_TOKEN = carenewtoken
    Write-Host "Token obtained"

    # generate private key, available formats "PPK", "PEM", "OpenSSH"
    $POST_DATA = @{
        formats     = @("PEM")
        keyPassword = ""
    } | ConvertTo-Json

    Write-Host "Obtaining SSH key"
    $RESPONSE = ca_api -data $POST_DATA -url $CYBERARK_KEYGEN
    $RESPONSE.Value.privateKey | Out-File -Encoding ascii $SSH_OUTPUT_PRIVKEY

    Write-Host "SSH key saved to $SSH_OUTPUT_PRIVKEY"
    
}

function ca_psm_session {
    param (
        [Parameter(Mandatory = $true)]
        [string]$component,
        [Parameter(Mandatory = $false)]
        [string]$address
    )
    $ErrorActionPreference = "Stop"
    $RDP_OUTPUT = "$env:USERPROFILE\session.rdp"

    $CYBERARK_TOKEN = carenewtoken
    Write-Host "Token obtained"

    $credential = ca_get_credential
    $CYBERARK_ACCOUNT_NAME = $credential.username
    $CYBERARK_ACCOUNTS_URL = "$CYBERARK_API/Accounts?search=${CYBERARK_ACCOUNT_NAME}_t1&limit=1"

    $CYBERARK_ACCOUNT = (ca_api_get $CYBERARK_ACCOUNTS_URL).Value.id


    Write-Host "Account id obtained: $CYBERARK_ACCOUNT"
    $CYBERARK_ACCOUNT_URL = "$CYBERARK_API/Accounts/$CYBERARK_ACCOUNT/PSMConnect"

    # generate RDP file
    $POST_DATA = @{
        reason              = ""
        ConnectionComponent = $component
        ConnectionParams    = @{
            AllowMappingLocalDrives = @{
                value      = "Yes"
                ShouldSave = "false"
            }
            LogonDomain = @{
                value      = "oaad"
                ShouldSave = "false"
            }
            PSMRemoteMachine = @{
                value      = "$address"
                ShouldSave = "false"
            }
        }
    } | ConvertTo-Json

    Write-Host "Obtaining RDP file"
    $RESPONSE = ca_api -data $POST_DATA -url $CYBERARK_ACCOUNT_URL

    $RESPONSE | Out-File -Encoding ascii $RDP_OUTPUT
    Write-Host "RDP saved to $RDP_OUTPUT"

    $RDP_OUTPUT  
}


function ca_psm_adhoc {
    param (
        [Parameter(Mandatory = $true)]
        [string]$platformId,
        [Parameter(Mandatory = $true)]
        [string]$component
    )
    $ErrorActionPreference = "Stop"
    $RDP_OUTPUT = "$env:USERPROFILE\session.rdp"
    $credential = ca_get_credential

    $CYBERARK_TOKEN = carenewtoken
    Write-Host "Token obtained"

    $CYBERARK_CONNECT_URL = "$CYBERARK_API/Accounts/AdHocConnect"

    # generate RDP file
    $POST_DATA = @{
        address                 = "a"
        userName                = $credential.username
        secret                  = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.password))
        platformId              = $platformId
        PSMConnectPrerequisites = @{
            ConnectionComponent = $component
            Reason              = ""
            TicketingSystemName = ""
            TicketId            = ""
            ConnectionParams    = ""
        }
        extraFields             = @{
            AllowMappingLocalDrives = "Yes"
            RedirectSmartCards      = "Yes"
        }
    } | ConvertTo-Json

    Write-Host "Obtaining RDP file"
    $RESPONSE = ca_api -data $POST_DATA -url $CYBERARK_CONNECT_URL

    $RESPONSE | Out-File -Encoding ascii $RDP_OUTPUT
    Write-Host "RDP saved to $RDP_OUTPUT"

    $RDP_OUTPUT  
}

function cajenkins {
    $RDP_OUTPUT = ca_psm_session -component "PSM-JenkinsLDAP" -address "englobjci1.deutsche-boerse.de"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}

function catfe {
    $RDP_OUTPUT = ca_psm_session -component "PSM-Terraform" -address "tfe.deutsche-boerse.de"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}

function cagcp {
    $RDP_OUTPUT = ca_psm_session -component "PSM-GCPAzureAD"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}


function cavsphere {
    $RDP_OUTPUT = ca_psm_session -component "PSM-VMware-vSphere-HTML5" -address "englobvc.oa.pnrad.net"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}


function cacitrix {
    $RDP_OUTPUT = ca_psm_adhoc -platformId "PSMSecureConnect" -component "Citrix_Netscaler_IE_PROD_session"
    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}

function cardp1 {
    $RDP_OUTPUT = ca_psm_session -component "PSM-RDP" -address "frpegy01.oa.pnrad.net"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}

function cardp2 {
    $RDP_OUTPUT = ca_psm_session -component "PSM-RDP" -address "frpegy02.oa.pnrad.net"

    Write-Host "Launching RDP session"
    mstsc.exe $RDP_OUTPUT
}
