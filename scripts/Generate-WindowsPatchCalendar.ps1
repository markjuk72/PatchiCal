param(
    [int]$YearsAhead = 2,
    [string]$OutputPath = "microsoft-patch-calendar.ics"
)

function Get-SecondTuesday {
    param(
        [int]$Year,
        [int]$Month
    )

    $firstOfMonth = Get-Date -Year $Year -Month $Month -Day 1
    $daysToTuesday = ([int][System.DayOfWeek]::Tuesday - [int]$firstOfMonth.DayOfWeek + 7) % 7
    $firstTuesday = $firstOfMonth.AddDays($daysToTuesday)
    $secondTuesday = $firstTuesday.AddDays(7)
    return $secondTuesday
}

function New-IcsEvent {
    param(
        [datetime]$Start,
        [datetime]$End,
        [string]$Summary,
        [string]$Description,
        [string]$Uid,
        [string]$Categories = ""
    )

    $categoryLine = if ($Categories) { "CATEGORIES:$Categories`r`n" } else { "" }

@"
BEGIN:VEVENT
UID:$Uid
DTSTAMP:$((Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))
DTSTART:$($Start.ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))
DTEND:$($End.ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))
SUMMARY:$Summary
DESCRIPTION:$Description
${categoryLine}END:VEVENT
"@
}

# Define Microsoft products and their patch schedules
$products = @(
    # Windows Client
    @{
        Id = "win11"
        Name = "Windows 11"
        Description = "Windows 11 security and quality updates"
        Category = "Windows Client"
    },
    @{
        Id = "win10"
        Name = "Windows 10"
        Description = "Windows 10 security and quality updates (supported versions)"
        Category = "Windows Client"
    },

    # Windows Server
    @{
        Id = "ws2025"
        Name = "Windows Server 2025"
        Description = "Windows Server 2025 security and quality updates"
        Category = "Windows Server"
    },
    @{
        Id = "ws2022"
        Name = "Windows Server 2022"
        Description = "Windows Server 2022 security and quality updates"
        Category = "Windows Server"
    },
    @{
        Id = "ws2019"
        Name = "Windows Server 2019"
        Description = "Windows Server 2019 security and quality updates"
        Category = "Windows Server"
    },

    # Microsoft 365 / Office
    @{
        Id = "m365"
        Name = "Microsoft 365 Apps"
        Description = "Microsoft 365 Apps (Office) security and feature updates"
        Category = "Microsoft 365"
    },

    # Microsoft Edge
    @{
        Id = "edge"
        Name = "Microsoft Edge"
        Description = "Microsoft Edge Stable channel security updates"
        Category = "Browser"
    },

    # .NET
    @{
        Id = "dotnet"
        Name = ".NET"
        Description = ".NET runtime and SDK security updates"
        Category = "Developer Tools"
    },

    # SQL Server
    @{
        Id = "sql2022"
        Name = "SQL Server 2022"
        Description = "SQL Server 2022 cumulative updates and security patches"
        Category = "SQL Server"
    },
    @{
        Id = "sql2019"
        Name = "SQL Server 2019"
        Description = "SQL Server 2019 cumulative updates and security patches"
        Category = "SQL Server"
    },

    # Azure
    @{
        Id = "azure"
        Name = "Azure Services"
        Description = "Azure platform security updates and advisories"
        Category = "Azure"
    },

    # Exchange Server
    @{
        Id = "exchange2019"
        Name = "Exchange Server 2019"
        Description = "Exchange Server 2019 security and cumulative updates"
        Category = "Exchange"
    },

    # SharePoint Server
    @{
        Id = "sharepoint"
        Name = "SharePoint Server"
        Description = "SharePoint Server security updates"
        Category = "SharePoint"
    }
)

$now = Get-Date
$endDate = $now.AddYears($YearsAhead)

$events = @()

for ($year = $now.Year; $year -le $endDate.Year; $year++) {
    for ($month = 1; $month -le 12; $month++) {
        $patchTuesday = Get-SecondTuesday -Year $year -Month $month

        if ($patchTuesday -lt $now.Date) { continue }
        if ($patchTuesday -gt $endDate) { break }

        # All-day event start (using DATE format for all-day events)
        $eventDate = $patchTuesday

        # Create events for each product
        foreach ($product in $products) {
            # Stagger event times slightly for better calendar visibility
            $startHour = switch ($product.Category) {
                "Windows Client"    { 17 }
                "Windows Server"    { 17 }
                "Microsoft 365"     { 18 }
                "Browser"           { 18 }
                "Developer Tools"   { 19 }
                "SQL Server"        { 19 }
                "Azure"             { 20 }
                "Exchange"          { 20 }
                "SharePoint"        { 20 }
                default             { 18 }
            }

            $start = Get-Date -Year $eventDate.Year -Month $eventDate.Month -Day $eventDate.Day -Hour $startHour -Minute 0 -Second 0
            $end = $start.AddHours(1)

            $events += New-IcsEvent `
                -Start $start `
                -End $end `
                -Summary "$($product.Name) Patch Tuesday" `
                -Description $product.Description `
                -Uid "$($product.Id)-$($patchTuesday.ToString('yyyyMMdd'))@patchical.github.io" `
                -Categories $product.Category
        }
    }
}

$icsContent = @"
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//PatchiCal//Microsoft Patch Calendar//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
X-WR-CALNAME:Microsoft Patch Tuesday Calendar
X-WR-CALDESC:Calendar of Microsoft Patch Tuesday releases for Windows, Office, SQL Server, and other Microsoft products
$($events -join "`r`n")
END:VCALENDAR
"@

$icsContent | Set-Content -Path $OutputPath -Encoding UTF8

Write-Host "Generated $($events.Count) events for $($products.Count) products"
Write-Host "Calendar saved to: $OutputPath"
