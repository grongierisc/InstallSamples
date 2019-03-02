Include %occInclude

Class App.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>

 <Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_IRISSYS:RW,%Admin_Secure:U" />

    <Log Text="Version d'IRIS ${VERSION}" Level="0"/>

    <If Condition='(##class(Config.Namespaces).Exists("SAMPLES")=0)'>
        <Log Text="Creating namespace SAMPLES" Level="0"/>
        <CopyDir  
		    Src="${DirSamples}"
            Target="${MGRDIR}/SAMPLES"
            IgnoreErrors="0"/>
            
        <Namespace Name="SAMPLES" Create="yes" Code="SAMPLES" Ensemble="1" Data="SAMPLES">
            <Configuration>
                <Database Name="SAMPLES" Dir="${MGRDIR}/SAMPLES" Create="no"/>
            </Configuration>
        
            <CSPApplication Url="/csp/SAMPLES" Directory="${CSPDIR}/SAMPLES" AuthenticationMethods="64" IsNamespaceDefault="true" Grant="AppRole" />

        </Namespace>
    </If>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
	
     Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

}
