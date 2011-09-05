<!--- Place functions here that should be globally available in your application. --->
<cffunction name="adminGet" access="public" hint="Gets the application wide configuration">
	<cfargument name="setting" required="true" hint="Setting to get">
	<cfreturn application.portal[arguments.setting]>
</cffunction>