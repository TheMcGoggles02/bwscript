# Bypass SSL certificate validation
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Measure the execution time of the entire operation
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Make 100 requests
$successCount = 0

1..100 | ForEach-Object {
    try {
        $response = Invoke-WebRequest `
            -Uri "http://localhost:1044/bwscript" `
            -Method GET `
            -TimeoutSec 50

        $successCount++
        Write-Host "Request $_ successful" -ForegroundColor Green
    }
    catch {
        Write-Host "Request $_ failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

$stopwatch.Stop()
Write-Host "`nTotal execution time: $($stopwatch.Elapsed.TotalSeconds) seconds"
Write-Host "Successful requests: $successCount"