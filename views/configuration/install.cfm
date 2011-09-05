<cfoutput>
	<h2>
		Step 
		#step#
	</h2>
	#showError()#
	#objectError()#
	<cfswitch expression="#step#">
		<cfcase value="2">
			#startFormTag(action="datasourceConfig")#
				<fieldset>
					<p>
						Do you already have a data source set up for you?
						<br/>
						#radioButtonTag(label="Yes", name="datasourceExist", value="Yes")#
						#radioButtonTag(label="No", name="datasourceExist", value="No")#
					</p>
					<legend>
						Datasource Information
					</legend>
					<div id="datasourceInfo">
						#textFieldTag(label="Datasource name", name="datasourceName")#
						#textFieldTag(name="dbUsername", label="Database Username")#
						#textFieldTag(name="dbPassword", label="Database Password")#
					</div>
					<div id="newDatasource">
						#adminUser()#
						#textFieldTag(label="Datasource name", name="datasourceName")#
						<fieldSet>
							<legend>
								Database Type
							</legend>
							#radioButtonTag(label="Ms SQL 2005", value="Ms SQL 2005", name="dbType")#
							#radioButtonTag(label="Ms SQL 2008", value="Ms SQL 2008", name="dbType")#
							#radioButtonTag(label="MySQL", value="MySQL", name="dbType", checked="true")#
						</fieldSet>
						#textFieldTag(name="serverName", label="Database Host Address", value="127.0.0.1")#
						#textFieldTag(name="dbServerPortNo", label="Database Port Number", value="3306")#
						#textFieldTag(name="dbName", label="Database Name")#
						#textFieldTag(name="dbUsername", label="Database Username")#
						#textFieldTag(name="dbPassword", label="Database Password")#
					</div>
					#submitTag(value="Proceed to step " & step + 1, id="dsn")#
				</fieldset>
			#endFormTag()#
		</cfcase>
		<cfcase value="3">
			<fieldset>
				<legend>
					Mail Server Configuration
				</legend>
				#startFormTag(action="mailServerConfig")#
					#textFieldTag(name="mailServer", label="Mail Server Host Address", value="")#
					#textFieldTag(name="stmpServer", label="STMP Server Address")#
					#textFieldTag(name="stmpPort", label="STMP Port Number")#
					#textFieldTag(name="popServer", label="POP Server Address")#
					#textFieldTag(name="popPort", label="POP Port Number")#
				#submitTag(value="Proceed to step " & step + 1)#
				#endFormTag()#
			</fieldset>
		</cfcase>
		<cfcase value="4">
			#startFormTag(action="finalize")#
			<fieldset>
				<legend>
					Site Information
				</legend>
				#textFieldTag(label="Site Title", name="siteTitle")#
				#textFieldTag(label="Site Address", name="siteAddress")#
			</fieldset>
			<fieldset>
				<legend>
					Administrator Information
				</legend>
				#textField(label="Admin Username", objectName="admin", property="userName")#
				#passwordField(label="Password", property="password", objectName="admin")#
				#passwordField(label="Confirm Password", property="passwordConfirmation", objectName="admin")#
				#textField(label="Email", property="email", objectName="admin")#
			</fieldset>
			#submitTag(value="Submit")#
			#endFormTag()#
		</cfcase>
		<cfcase value="5">
			<p>You have successfully configured the application</p>
		</cfcase>
	</cfswitch>
	
</cfoutput>