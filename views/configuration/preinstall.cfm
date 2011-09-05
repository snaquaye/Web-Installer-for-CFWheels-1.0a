<cfoutput>
	<h2>
		Step 
		#step#
	</h2>
	<p>
		Thank you for choosing XZY<!---#adminGet(name)#---> Portal. This wizard would guide you through
		the process of configuring this application.
	</p>
	<!--- TODO: Server details --->
	<div>
		<fieldset>
			<legend>
				License Agreement
			</legend>
			#includeContent("license")#
		</fieldset>
	</div>
	<p>#linkTo(text="I agree", action="firstRun", params="step=2")# #linkTo(text="I do not agree", action="cancelInstallation")#</p>
</cfoutput>