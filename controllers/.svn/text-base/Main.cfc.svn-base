<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
		<!--- Filters --->
		
		<cfset filters(through="checkInstall", except="checkInstall")>
	</cffunction>
	
	<cffunction name="checkInstall" hint="checks if application has been configured">
		<cfset configPath = expandPath("config/")>
		<cfif not fileExists(configPath & "config.json.cfm")>
			<cfset redirectTo(controller="configuration", action="firstRun", params="step=1")>
		</cfif>
	</cffunction>
	
</cfcomponent>