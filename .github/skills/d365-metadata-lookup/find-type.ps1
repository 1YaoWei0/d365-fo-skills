<#
.SYNOPSIS
    find-type.ps1 — searches PackagesLocalDirectory for any X++ EDT, table, view,
    class, or enum by name, and reports type category, path, methods, and parent types.

.PARAMETER TypeName
    The X++ type name to search for. Can be exact or partial.

.PARAMETER PackagesLocalDir
    Optional override for the PackagesLocalDirectory path.

.EXAMPLE
    .\find-type.ps1 -TypeName "SalesTable"
    .\find-type.ps1 -TypeName "CustAccount"
    .\find-type.ps1 -TypeName "PurchLine"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$TypeName,

    [string]$PackagesLocalDir = "C:\AOSService\PackagesLocalDirectory"   # Update to your environment
)

# ── Type category detection ───────────────────────────────────────────────────
$typeMap = @{
    "AxClass" = "Class"
    "AxTable" = "Table"
    "AxView"  = "View (⚠️ NOT UPDATABLE — do not use DML)"
    "AxEdt"   = "Extended Data Type (EDT)"
    "AxEnum"  = "Enum"
    "AxForm"  = "Form"
    "AxQuery" = "Query"
}

Write-Host ""
Write-Host "=== D365 Metadata Lookup: $TypeName ===" -ForegroundColor Cyan

if (-not (Test-Path $PackagesLocalDir)) {
    Write-Error "PackagesLocalDirectory not found: $PackagesLocalDir"
    exit 1
}

# ── Search for XML files matching the type name ───────────────────────────────
$pattern  = "$TypeName.xml"
$matches  = Get-ChildItem -Path $PackagesLocalDir -Filter $pattern -Recurse -ErrorAction SilentlyContinue

if ($matches.Count -eq 0) {
    Write-Host "  ❌ No match found for '$TypeName' in $PackagesLocalDir" -ForegroundColor Red
    Write-Host "  Check spelling. Type names are case-sensitive in some contexts."
    exit 1
}

foreach ($file in $matches) {
    Write-Host ""
    Write-Host "  📄 File: $($file.FullName)"

    try {
        [xml]$xml = Get-Content $file.FullName -ErrorAction Stop
        $rootElement = $xml.DocumentElement.Name

        $category = $typeMap[$rootElement]
        if (-not $category) { $category = $rootElement }

        Write-Host "  📦 Type: $category" -ForegroundColor $(if ($rootElement -eq "AxView") { "Yellow" } else { "Green" })

        # View: show data sources (underlying tables)
        if ($rootElement -eq "AxView") {
            Write-Host "  ⚠️  This is a VIEW — do NOT use insert/update/delete/doInsert on it!" -ForegroundColor Red
            $dataSources = $xml.AxView.Query.DataSources.AxQuerySimpleDataSource
            if ($dataSources) {
                Write-Host "  Underlying table(s):"
                foreach ($ds in $dataSources) {
                    Write-Host "    → $($ds.Table)"
                }
            }
        }

        # EDT: show parent
        if ($rootElement -eq "AxEdt") {
            $extends = $xml.AxEdt.Extends
            if ($extends) { Write-Host "  Extends: $extends" }
            $baseType = $xml.AxEdt.BaseType
            if ($baseType) { Write-Host "  Base type: $baseType" }
        }

        # Class/Table: show method names
        if ($rootElement -in @("AxClass", "AxTable")) {
            $methods = $xml.$rootElement.SourceCode.Methods.Method
            if ($methods) {
                Write-Host "  Methods ($($methods.Count)):"
                foreach ($m in $methods) {
                    $name = $m.Name
                    if ($name) { Write-Host "    • $name" }
                }
            }
        }

        # Enum: show values
        if ($rootElement -eq "AxEnum") {
            $values = $xml.AxEnum.EnumValues.AxEnumValue
            if ($values) {
                Write-Host "  Values:"
                foreach ($v in $values) {
                    Write-Host "    • $($v.Name) = $($v.Value)"
                }
            }
        }

    } catch {
        Write-Host "  ⚠️  Could not parse XML: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== Lookup complete ===" -ForegroundColor Cyan
Write-Host ""
