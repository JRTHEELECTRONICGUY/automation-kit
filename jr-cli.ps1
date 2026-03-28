param(
    [Parameter()]
    [string]$Command,
    
    [Parameter()]
    [string]$ArgsList
)

# JR CLI PowerShell wrapper
# Built by John Readman

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$pythonScript = Join-Path $scriptPath "jr-cli.py"

function Show-Help {
    Write-Host @"
🚀 JR Electronic Automation Kit CLI
=====================================

Usage: jr-cli [command] [arguments]

Commands:
  setup              - Interactive setup wizard
  quickstart <level> - Start automation by level
    - beginner       - $50-100/day setup
    - intermediate   - $200-500/day setup  
    - advanced       - $1000+/day setup
    - agency         - 5+ client setup
  
  niche [action] [keywords] - Niche research
  outreach [params]        - Client outreach
  content [params]          - Content generation
  status                    - System status
  help                      - This help message

Examples:
  jr-cli setup
  jr-cli quickstart beginner
  jr-cli niche hunter "passive income"
  jr-cli content generate --keyword "crypto"

Visit: https://jr-systems.com
Discord: discord.gg/jr-systems
"@
}

if ([string]::IsNullOrWhiteSpace($Command)) {
    Show-Help
    exit 0
}

$pythonArgs = @($Command)
if (-not [string]::IsNullOrWhiteSpace($ArgsList)) {
    $pythonArgs += $ArgsList
}

& python $pythonScript @pythonArgs