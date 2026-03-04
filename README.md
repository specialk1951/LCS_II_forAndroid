# Loan Calculator Simplified

<img src="Resources/AppIcon/Calculator-512.png" width="80"/>

A cross-platform loan calculator built with .NET MAUI targeting Android, iOS, macOS, and Windows.

## Screenshot

<img src="Resources/Images/Screenshot_LCS_II.jpg" width="300"/>

## Features

Enter any 3 of the 4 loan variables and tap the corresponding button to calculate the missing value:

- **Loan Amount** — the principal borrowed
- **Interest Rate** — annual interest rate (0.1% to 100%)
- **Number of Payments** — total number of monthly payments
- **Payment Amount** — monthly payment amount

**Total Interest** is calculated and displayed automatically after each calculation.

## How to Use

1. Fill in any 3 of the 4 fields
2. Tap the button next to the field you want to calculate
3. The result is filled in along with the total interest paid
4. Tap **Clear** to reset all fields

## Requirements

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- .NET MAUI workload (`dotnet workload install maui`)
- Android SDK (for Android deployment)

## Build & Deploy

### Run on Android device

```bash
dotnet build -t:Run -f net9.0-android
```

### Run on Windows

```bash
dotnet build -t:Run -f net9.0-windows10.0.19041.0
```
