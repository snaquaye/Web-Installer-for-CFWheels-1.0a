<!--- Place HTML here that should be used as the default layout of your application --->
<html>
	<head>
		<title>Web Installer</title>
		<cfoutput>
			#javaScriptIncludeTag(sources="jquery-1.6.2.min, scripts")#
		</cfoutput>
	</head>
	<body>
		<cfoutput>#includeContent()#</cfoutput>
	</body>
</html>