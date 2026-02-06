# PatchiCal

A subscribable iCal feed for Microsoft Patch Tuesday releases. Subscribe in Outlook, Google Calendar, Apple Calendar, or any iCal-compatible client to stay informed about upcoming Microsoft security updates.

## Subscribe to the Calendar

Once this repository is published to GitHub, you can subscribe using this URL:

```
https://raw.githubusercontent.com/YOUR_USERNAME/PatchiCal/main/microsoft-patch-calendar.ics
```

Replace `YOUR_USERNAME` with your GitHub username.

### Subscribe in Outlook (Desktop)

1. Open Outlook
2. Go to **Calendar** view
3. Click **Add Calendar** > **From Internet...**
4. Paste the raw GitHub URL above
5. Click **OK**

### Subscribe in Outlook (Web / Microsoft 365)

1. Go to [outlook.office.com](https://outlook.office.com) and open Calendar
2. Click **Add calendar** in the left sidebar
3. Select **Subscribe from web**
4. Paste the raw GitHub URL
5. Give it a name (e.g., "Microsoft Patch Tuesday")
6. Click **Import**

### Subscribe in Google Calendar

1. Open [Google Calendar](https://calendar.google.com)
2. Click the **+** next to "Other calendars"
3. Select **From URL**
4. Paste the raw GitHub URL
5. Click **Add calendar**

### Subscribe in Apple Calendar

1. Open Calendar app
2. Go to **File** > **New Calendar Subscription...**
3. Paste the raw GitHub URL
4. Configure refresh frequency and click **OK**

## Products Covered

The calendar includes Patch Tuesday events for:

| Category | Products |
|----------|----------|
| **Windows Client** | Windows 11, Windows 10 |
| **Windows Server** | Windows Server 2025, 2022, 2019 |
| **Microsoft 365** | Microsoft 365 Apps (Office) |
| **Browser** | Microsoft Edge |
| **Developer Tools** | .NET |
| **SQL Server** | SQL Server 2022, SQL Server 2019 |
| **Azure** | Azure Services |
| **Exchange** | Exchange Server 2019 |
| **SharePoint** | SharePoint Server |

## What is Patch Tuesday?

Microsoft releases security updates on the second Tuesday of each month, commonly known as "Patch Tuesday". This calendar helps you plan for these releases by adding events to your calendar automatically.

## How It Works

1. A PowerShell script calculates all Patch Tuesday dates (2nd Tuesday of each month)
2. GitHub Actions runs daily to regenerate the calendar
3. The `.ics` file is committed to the repository
4. Your calendar client fetches updates automatically

## Local Generation

To generate the calendar locally:

```powershell
# Generate calendar for the next 2 years (default)
./scripts/Generate-WindowsPatchCalendar.ps1

# Generate for a custom period
./scripts/Generate-WindowsPatchCalendar.ps1 -YearsAhead 3 -OutputPath "my-calendar.ics"
```

## Repository Structure

```
PatchiCal/
├── .github/
│   └── workflows/
│       └── generate-calendar.yml    # GitHub Actions automation
├── scripts/
│   └── Generate-WindowsPatchCalendar.ps1  # Calendar generator
├── microsoft-patch-calendar.ics     # Generated calendar (after first run)
├── README.md
└── LICENSE
```

## Contributing

Contributions are welcome! Ideas for improvement:

- Add more Microsoft products
- Include links to release notes in event descriptions
- Add preview/beta channel release schedules
- Support for other vendors (Adobe, Oracle, etc.)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Disclaimer

This calendar is based on Microsoft's historical Patch Tuesday schedule (2nd Tuesday of each month). Actual release dates may occasionally vary. Always verify critical updates through official Microsoft channels.

## Links

- [Microsoft Security Update Guide](https://msrc.microsoft.com/update-guide/)
- [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/)
- [Windows Release Health](https://learn.microsoft.com/en-us/windows/release-health/)
