# Install-Module -Name BcContainerHelper -force

$artifactUrl = Get-BCArtifactUrl -country es -select Latest -type Sandbox -version 24.5

New-BcContainer -accept_eula -artifactUrl $artifactUrl -auth UserPassword -containerName BC24CU5ES -includeTestLibrariesOnly -includeTestToolkit -updateHosts -useBestContainerOS