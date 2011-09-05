<cffunction name="adminUser">
	<cfif server.ColdFusion.productName EQ "Coldfusion Server">
		<cfoutput>
			#textFieldTag(label="CF Admin Id", name="adminId")##passwordFieldTag(label="CF Admin Password", 
		                                                                      name="adminPassword")#
		</cfoutput>
	<cfelseif server.ColdFusion.productName EQ "Railo">
		<cfoutput>
			#textFieldTag(label="Railo Admin Id", name="adminId")##passwordFieldTag(label="Railo Admin Password", 
		                                                                         name="adminPassword")#
		</cfoutput>
	</cfif>
</cffunction>

<cffunction name="showError">
	<cfif isDefined("errorMessages") AND isArray(errorMessages)>
		<cfloop index="i" from="1" to="#ArrayLen(errorMessages)#">
			<cfoutput>
				<li>
					#errorMessages[i]#
				</li>
			</cfoutput>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="objectError">
	<cfif isDefined("admin") AND admin.hasErrors()>
		<cfset errorMessagesFor("admin")>
	</cfif>
</cffunction>
