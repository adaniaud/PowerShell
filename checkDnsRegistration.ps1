# Author : adaniaud
# Change to your hosts
$hosts = @("serv1", "serv2", "serv3", "serv4")
# Change to your DNS server
$DNS = '127.0.0.1'

foreach ($host in $hosts) {    
    Try     
    {         
        $ip = (Resolve-DnsName -Name "$host" -Server $DNS -ErrorAction Stop).ip4address        
        Write-Host "DNS record found for $host - ip : $ip"    
    }        
        Catch [System.ComponentModel.Win32Exception]     
    {         
    Write-Host "Host $host isn't registered in $DNS"     
    }
    
    Catch    
    {        
        Write-Host "Error for $host - $Error[0].Exception"    
    }
}
