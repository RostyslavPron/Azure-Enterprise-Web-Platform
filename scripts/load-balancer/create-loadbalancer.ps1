$resourceGroup = "rg-enterprise-prod"
$location = "canadacentral"

# Public IP
$publicIp = New-AzPublicIpAddress `
    -Name "web-lb-pip" `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -AllocationMethod Static `
    -Sku Standard

# Frontend Configuration
$frontendIp = New-AzLoadBalancerFrontendIpConfig `
    -Name "frontend-config" `
    -PublicIpAddress $publicIp

# Backend Pool
$backendPool = New-AzLoadBalancerBackendAddressPoolConfig `
    -Name "web-backend-pool"

# Health Probe
$probe = New-AzLoadBalancerProbeConfig `
    -Name "http-probe" `
    -Protocol Tcp `
    -Port 80 `
    -IntervalInSeconds 5 `
    -ProbeCount 2

# Load Balancing Rule
$rule = New-AzLoadBalancerRuleConfig `
    -Name "http-rule" `
    -FrontendIpConfiguration $frontendIp `
    -BackendAddressPool $backendPool `
    -Probe $probe `
    -Protocol Tcp `
    -FrontendPort 80 `
    -BackendPort 80

# Create Load Balancer
New-AzLoadBalancer `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Name "web-lb" `
    -Sku Standard `
    -FrontendIpConfiguration $frontendIp `
    -BackendAddressPool $backendPool `
    -Probe $probe `
    -LoadBalancingRule $rule