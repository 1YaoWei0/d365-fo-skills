<#
.SYNOPSIS
    create-class.ps1 — scaffolds a new X++ runnable class XML and .rnrproj project file
    in the CBA model, applying all team X++ coding rules.

.PARAMETER ClassName
    PascalCase class name. Example: CBA_DeleteAttributeValues_RunnableClass

.PARAMETER Purpose
    One-line description used for the class label and Help text.

.EXAMPLE
    .\create-class.ps1 -ClassName "CBA_DeleteAttributeValues_RunnableClass" -Purpose "Deletes all attribute values for a given product"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ClassName,

    [Parameter(Mandatory = $true)]
    [string]$Purpose
)

# ── Configuration ──────────────────────────────────────────────────────────────
$PackagesLocalDir = "C:\AOSService\PackagesLocalDirectory"   # Update to your environment
$ModelName        = "CBA"
# ───────────────────────────────────────────────────────────────────────────────

$modelPath  = Join-Path $PackagesLocalDir $ModelName
$classDir   = Join-Path $modelPath $ClassName
$xmlFile    = Join-Path $classDir "$ClassName.xml"
$projFile   = Join-Path $classDir "$ClassName.rnrproj"

if (-not (Test-Path $modelPath)) {
    Write-Error "Model path not found: $modelPath"
    exit 1
}

# Create class directory
New-Item -ItemType Directory -Force -Path $classDir | Out-Null
Write-Host "  Created: $classDir"

# ── X++ class XML ─────────────────────────────────────────────────────────────
$classXml = @"
<?xml version="1.0" encoding="utf-8"?>
<AxClass xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
    <Name>$ClassName</Name>
    <SourceCode>
        <Declaration><![CDATA[
/// <summary>
/// $Purpose
/// </summary>
// TODO: Remove this comment and implement class logic
class $ClassName
{
}
        ]]></Declaration>
        <Methods>
            <Method>
                <Name>main</Name>
                <Source><![CDATA[
    /// <summary>
    /// Entry point for $ClassName.
    /// </summary>
    public static void main(Args _args)
    {
        $ClassName runner = new $ClassName();
        runner.run();
    }
                ]]></Source>
            </Method>
            <Method>
                <Name>run</Name>
                <Source><![CDATA[
    /// <summary>
    /// Contains the business logic for $ClassName.
    /// </summary>
    public void run()
    {
        // TODO: Implement business logic here
    }
                ]]></Source>
            </Method>
        </Methods>
    </SourceCode>
    <Label>$Purpose</Label>
    <HelpText>$Purpose</HelpText>
    <RunOn>Called from</RunOn>
</AxClass>
"@

Set-Content -Path $xmlFile -Value $classXml -Encoding UTF8
Write-Host "  Created: $xmlFile"

# ── .rnrproj project file ─────────────────────────────────────────────────────
$projXml = @"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="14.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="`$(MSBuildExtensionsPath)\`$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('`$(MSBuildExtensionsPath)\`$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '`$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '`$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{$(([System.Guid]::NewGuid().ToString().ToUpper()))}</ProjectGuid>
    <RootNamespace>$ClassName</RootNamespace>
    <AssemblyName>$ClassName</AssemblyName>
    <ModelModule>$ModelName</ModelModule>
    <DeployOnBuild>true</DeployOnBuild>
    <DeployOnline>True</DeployOnline>
    <StartupObject />
  </PropertyGroup>
  <ItemGroup>
    <AxClass Include="$ClassName.xml" />
  </ItemGroup>
</Project>
"@

Set-Content -Path $projFile -Value $projXml -Encoding UTF8
Write-Host "  Created: $projFile"

Write-Host ""
Write-Host "✅ Class scaffolded successfully:" -ForegroundColor Green
Write-Host "   XML:  $xmlFile"
Write-Host "   Proj: $projFile"
Write-Host ""
Write-Host "Next: Add the .rnrproj to your VS solution, implement the run() method, then use d365-build-and-deploy."
