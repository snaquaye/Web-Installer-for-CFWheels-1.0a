<!---  --->
<cfcomponent displayname="Configuration" extends="Controller" output="false">
	<!--- todo: use dbmigratration tool to create the database, create the user model class using Russ 
	Johns login template --->
	<!--- Public methods --->
	
	<cffunction name="init">
		<!--- Filters --->
		
		<cfset filters(through="checkAppServer", except="checkAppServer")>
		<cfset filters(through="AppServerVersion", except="AppServerVersion")>
		<cfset filters(through="isAppConfigured", execpt="isAppConfigured")>
	</cffunction>
	
	<cffunction name="checkAppServer" 
	            hint="Checks if the application server is a ColdFusion server as only coldfusion server is supported at the moment">
		<cfset var loc = {}>
		<!--- Check if the application server is Coldfusion server --->
		<cfif server.ColdFusion.productName NEQ "Coldfusion Server">
			<cfset loc.error = "Only Adobe Coldfusion Server is supported">
			<cfset errorMessage = []>
			<cfset arrayAppend(errorMessage, loc.error)>
			<cfset $abortInstallation(errorMessage)>
		</cfif>
	</cffunction>
	
	<cffunction name="AppServerVersion" hint="Checks the version of the application server">
		<!---Get the version of the application server--->
		
		<cfset var loc = {}>
		<cfset loc.applicationServerVersion = #replace(server.ColdFusion.productversion, ",", ".", "all")#>
		<!---<cfset loc.applicationServerVersion = 7>--->
		
		<cfscript>
			//confirm if the version of the application server is 8 or greater
			if(loc.applicationServerVersion Lt 8)
			{
				loc.message = "Only versions of Coldfusion Server greater than version 7 is supported";
				info = [];
				arrayAppend(info, loc.message);
				$abortInstallation(info);
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="isAppConfigured" hint="Checks if the application has been configured">
		<cfset configPath = expandPath("config/")>
		<cfif NOT fileExists(configPath & "config.json.cfm")>
			<cfset redirectTo(controller="main", action="alreadyInstalled")>
		</cfif>
	</cffunction>
	
	<cffunction name="canelInstallation" 
	            hint="Action to cancel installation if client refuses license agreement">
	
		<cfscript>
			var loc = {};
			loc.message = "Installation of application cancelled by user";
			info = [];
			arrayAppend(info, loc.message);
			$abortInstallation(info);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="firstRun" hint="Do initial configuration of the application">
	
		<cfif Not isDefined("params.step") or params.step EQ ''>
			<cfset var loc = {}>
			<cfset info = []>
			<cfset loc.message = "The variable 'STEP' was not passed into the URL">
			<cfset arrayAppend(info, loc.message)>
			<cfset $abortInstallation(info)>
		
		<cfelse>
		
			<!--- Choose the view to render based on the variable passed from the URL --->
			
			<cfswitch expression="#params.step#">
				<!--- Displays the license agreement view --->
				<cfcase value="1">
					<cfset $getLicense()>
					<cfset renderPage(action="preinstall")>
				</cfcase>
				<!--- Render the datasource creation view --->
				<cfcase value="2">
					<cfset step = 2>
					<cfset renderPage(action="install")>
				</cfcase>
				<!--- Renders the mail server configuration page --->
				<cfcase value="3">
					<cfset step = 3>
					<cfset renderPage(action="install")>
				</cfcase>
				<!--- Renders the site configuration page --->
				<cfcase value="4">
					<cfset step = 4>
					<cfset admin = model("user").new()>
					<cfset renderPage(action="install")>
				</cfcase>
			
				<!--- No value was passed into the step variables --->
				<cfdefaultcase>
					<cfset $getLicense()>
					<cfset renderPage(action="preinstall")>
				</cfdefaultcase>
			</cfswitch>
			
		</cfif>
	</cffunction>
	
	<cffunction name="datasourceConfig" hint="Create the datasource configuration">
	
		<cfscript>
			//check for required fields
			var requiredFields = {};
			requiredFields.datasource = params.datasourceExist;
			requiredFields.dbUsername = params.dbUsername;
			requiredFields.dbType = params.dbType;
			requiredFields.adminPassword = params.adminPassword;
			requiredFields.serverName = params.serverName;
			requiredFields.dbName = params.dbName;
		
			//Checks if it contains error messages
			if(isArray($isEmpty(requiredFields)))
			{
				step = 2;
				errorMessages = $isEmpty(requiredFields);
				renderPage(action="install");
			}
			else
			{
				//check the value of the datasourceExists
				if(params.datasourceExist == "No")
				{
					if(server.ColdFusion.productName == "Coldfusion Server")
					{
						$addCFDatasource(adminusername=params.adminId, adminpassword=params.adminPassword, 
					                  datasource=params.datasourceName,dbName=params.dbName, 
					                  host=params.serverName,dbType=params.dbType, username=params.dbUsername, 
					                  password=params.dbPassword,databasePort=params.dbServerPortNo);
						$saveToSession(values=params, step=3);
					}
					else if(server.Coldfusion.productName == "Railo")
					{
						// TODO: Add support for Railo
						var loc = {};
						info = [];
						loc.message = "Railo is not supported at the moment";
						arrayAppend(info, loc.message);
						$abortInstallation(info);
					}
				}
				else
				{
					$saveToSession(values=params, step=3);
				}
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="mailServerConfig" access="public" hint="Set the mail server configurations">
	
		<cfscript>
			var requestedFields = {};
			requestedFields.mailServer = params.mailServer;
			requestedFields.stmpServer = params.stmpServer;
			requestedFields.popServer = params.popServer;
			if(isArray($isEmpty(requestedFields)))
			{
				step = 3;
				errorMessages = $isEmpty(requiredFields);
				renderPage(action="install");
			}
			else
			{
				//writeDump(var="#params#" abort="true")
				$saveToSession(values="#params#", step=4);
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="finalize" access="public" hint="Persist the user admin info to the database">
	
		<cfscript>
			var requiredFields = {};
			requiredFields.siteTitle = params.siteTitle;
			if(isArray($isEmpty(requiredFields)))
			{
				step = 4;
				errorMessages = $isEmpty(requiredFields);
				renderPage(action="install");
			}
			else
			{
				var siteInfo = {};
				siteInfo.siteTitle = params.siteTitle;
				siteInfo.siteAddress = params.siteAddress;
				$saveToSession(values="#siteInfo#", step="5");
			
				admin = model("user").save(params.admin);
				if(admin.save())
				{
					redirectTo(action="$saveConfiguration");
				}
				else
				{
					step = 4;
					renderPage(action="install");
				}
			}
		
		</cfscript>
		
	</cffunction>
	
	<!--- Private methods --->
	
	<cffunction name="$saveToSession" access="private" 
	            hint="Persist the passsed in configuration value to the session scope">
		<cfargument name="values" type="struct" hint="Configurations to set" required="true"/>
		<cfargument name="step" type="numeric" hint="the next step to take" required="false"/>
	
		<cfscript>
			if(!isDefined("session.config"))
			{
				session.config = [];
			}
			arrayAppend(session.config, arguments.values);
			redirectTo(action="firstRun", params="step=#arguments.step#");
		</cfscript>
		
	</cffunction>
	
	<cffunction name="$abortInstallation" access="private" 
	            hint="Cancel application configuration when an error occurs">
		<cfargument name="item" required="true" type="array"/>
	
		<!---<cfset var message = arguments.item>
		<cfdump var="#message#" abort="true">--->
		<cfset flashInsert(message=arguments.item[1])>
		<cfset renderPage(action="error")>
	</cffunction>
	
	<cffunction name="$getLicense" access="private">
		<!--- Confirms if the license text file exists --->
		
		<cfset step = 1>
		<cfif fileExists(expandPath("license\license.txt"))>
			<cffile action="read" file="#expandPath("license\license.txt")#" variable="license">
			<cfset contentFor(license=license)>
		<cfelse>
			<cfset contentFor(license="Could not find the license file")>
		</cfif>
	</cffunction>
	
	<cffunction name="$isEmpty" access="private" hint="Perform required form fields validation" 
	            returntype="Any">
		<cfargument name="field" required="true" type="struct"/>
	
		<cfset var errorMessages = []>
		<cfloop collection="#arguments.field#" item="key">
			<!--- TODO:Use friendly names for the required fields --->
			
			<cfscript>
				if(arguments.field[key] EQ "")
				{
					arrayAppend(errorMessages, key & " can't be empty");
				}
			</cfscript>
			
		</cfloop>
	
		<cfif NOT arrayIsEmpty(errorMessages)>
			<cfreturn errorMessages>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="$addCFDatasource" access="private" hint="Create a coldfusion datasource">
		<cfargument name="adminusername" required="true" default="admin" type="string"
		            hint="The username for coldfusion administrator"/>
		<cfargument name="adminpassword" required="true" type="string" 
		            hint="Password for accessing the server administrator"/>
		<cfargument name="datasource" required="true" type="string" hint="Datasource to create"/>
		<cfargument name="dbName" required="true" type="string" hint="Name of database in the DB Server"/>
		<cfargument name="host" required="true" type="string" hint="Host name for the DB server"/>
		<cfargument name="dbType" required="true" type="string" hint="Database type"/>
		<cfargument name="username" required="true" type="string" 
		            hint="Username for accessing the database"/>
		<cfargument name="password" required="false" type="string" 
		            hint="Password for accessing the database"/>
		<cfargument name="databasePort" required="false" type="numeric" 
		            hint="Database server port address"/>
	
		<cfscript>
			var loc = {};
			errorModelObject = [];//holds all errors generated by this function
			//Login to the coldfusion administrator
			var CFAdminAuthObj = createObject("component", "CFIDE.adminapi.administrator");
			loc.auth.result = CFAdminAuthObj.login(adminPassword="#arguments.adminpassword#", 
			                                       adminUserId="#arguments.adminusername#");
			//Confirms if the username and password supplied are correct
			if(loc.auth.result)
			{
				var dsObj = createObject("component", "CFIDE.adminapi.datasource");
			}
			else
			{
				error = "Invalid Coldfusion Administrator username or password";
				arrayAppend(errorModelObject, error);
				return errorModelObject;
			}
			//Checks if an instance of coldfusion datasource component is created
			if(isObject(dsObj))
			{
				try
				{
					dsObj.getDatasources(arguments.datasource);
				}
					//If it doesn't exist, it would throw an error
				catch(any exception)
				{
					loc.dsExists = false;
				}
			}
			if(loc.dsExists)
			{
				error = "Datasource name already exists";
				arrayAppend(errorModelObject, error);
				return errorModelObject;
			}
			//creates a new struct and assign it values needed to create datasource
			var dns = {};
			dns.name = arguments.datasource;
			dns.database = arguments.dbName;
			dns.username = arguments.username;
			dns.password = arguments.password;
			dns.host = arguments.host;
		
			//Checks if the database port is not empty
			if(arguments.databasePort NEQ "")
			{
				dns.port = arguments.databasePort;
			}
		
			//checks the database type
			if(arguments.dbType EQ "MSSQL2005" or arguments.dbType EQ "MSSQL2008")
			{
				dsObj.setMSSQL(argumentCollection=dns);
			}
			if(arguments.dbType EQ "MySQL")
			{
				//writeDump(var="#dns#", abort="true");
				dsObj.setMySQL5(argumentCollection=dns);
			}
			//verify the just created datasource
			loc.result.status = dsObj.verifyDsn(arguments.datasource);
			if(NOT loc.result.status)
			{
				dsObj.deleteDatasource(arguments.datasource);
				arrayAppend(errorModelObject, "Datasource verification failed. Check your setting");
				return errorModelObject;
			}
		</cfscript>
		
	</cffunction>
	
	<!--- TODO: Add support for Railo Datasource configuration --->
	
	<cffunction name="$addRailoDatasource" access="package" hint="Create the datasourc in railo">
	
	</cffunction>
	
	<cffunction name="$saveConfiguration" access="private" hint="creates the configuration file">
		<cfdump var="#session#" abort="true">
	</cffunction>
	
</cfcomponent>