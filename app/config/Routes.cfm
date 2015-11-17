<cfscript>
	// Allow unique URL or combination of URLs, we recommend both enabled
	setUniqueURLS(true);
	// Auto reload configuration, true in dev makes sense to reload the routes on every request
	//setAutoReload(false);
	// Sets automatic route extension detection and places the extension in the rc.format variable
	setExtensionDetection(true);
	// The valid extensions this interceptor will detect
	setValidExtensions('json');
	// If enabled, the interceptor will throw a 406 exception that an invalid format was detected or just ignore it
	// setThrowOnInvalidExtension(true);
	// Base URL
	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL("http://#cgi.HTTP_HOST#/");
	}
	else{
		setBaseURL("http://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/");
	}

	// default route actions
	idActions = { GET="getByID", PUT="update", DELETE="remove" };
	nonIdActions = { GET="list", POST="create" };
	
	//Auth
	with(pattern="/auth", handler="Auth")
		.addRoute(pattern="/index", action={GET="index"})
		.addRoute(pattern="/ping", action={GET="ping"})
		.addRoute(pattern="/logout", action={GET="logout"})
		.addRoute(pattern="/login", action={POST="login"})
		.addRoute(pattern="/user", handler="Users", action={GET="index", PUT="update"})
	.endWith();
	
	//AccessGroups / Menu
	addRoute(pattern="/accessgroups", handler="AccessGroups", action=nonIdActions);
	addRoute(pattern="/menu", handler="AccessGroups", action={GET="getCPMenu"});
	addRoute(pattern="/config/:configToken/menu", handler="AccessGroups", action={GET="getConfigMenu"});
	
	//GroupStatuses
	addRoute(pattern="/groupStatuses", handler="Groups", action={GET="listGroupStatuses"});

	//Stats
	addRoute(pattern="/configs/:configToken/stats", handler="Stats", action={POST="fetch"});
	
	//Partners
	with(pattern="/partners", handler="Partners", appsection="partners")
		.addRoute(pattern="/:partnerToken", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith(); 

	//Groups
	with(pattern="/configs/:configToken/groups", handler="Groups", appsection="groups")
		.addRoute(pattern="/:groupToken", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();

	//Activities
	with(pattern="/configs/:configToken/activities", handler="Activities", appsection="activities")
		.addRoute(pattern="/:activityID", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();
	
	//Barcodes
	with(pattern="/configs/:configToken/barcodes", handler="Barcodes", appsection="customers")
		.addRoute(pattern="/:barcode", action={GET="getByID", PUT="update", POST="create", DELETE="remove"})
	.endWith(); 
	
	//Docs
	with(pattern="/configs/:configToken/customers/:custToken/docs", handler="Docs", appsection="customers")
		.addRoute(pattern="/:docToken", action=idActions)
		.addRoute(pattern="/:docToken/serve", action={GET="serve"})
		.addRoute(pattern="/", action=nonIdActions)
	.endWith(); 
	
	//Members
	with(pattern="/configs/:configToken/members", handler="Members", appsection="customers")
		.addRoute(pattern="/:memberToken/verify", action={POST="verify"})
		.addRoute(pattern="/:memberToken", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith(); 
	
	//Customers
	with(pattern="/configs/:configToken/customers", handler="Customers", appsection="customers")
		.addRoute(pattern="/:custToken", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();

	//FieldGroups
	with(pattern="/configs/:configToken/flows/:flowSlug/revisions/:flowRevID/steps/:flowStepID/fieldGroups", 
				handler="FieldGroups", 
				appsection="processes")
		.addRoute(pattern="/:fieldGroupID", action={GET="getByID", POST="update", DELETE="remove"})
		.addRoute(pattern="/", action={GET="list", POST="create"} )
	.endWith();

	//FlowSteps
	with(pattern="/configs/:configToken/flows/:flowSlug/revisions/:flowRevID/steps", handler="FlowSteps", appsection="processes")
		.addRoute(pattern="/:flowStepID", action={GET="getByID", PUT="update", DELETE="remove"})
		.addRoute(pattern="/", action={GET="list", POST="create"} )
	.endWith();

	//FlowRevisions
	with(pattern="/configs/:configToken/flows/:flowSlug/revisions", handler="FlowRevisions", appsection="processes")
		.addRoute(pattern="/:flowRevID", action={GET="getByID", POST="update", DELETE="remove"})
		.addRoute(pattern="/", action={GET="list", POST="create"} )
	.endWith(); 
	
	//Flows
	with(pattern="/configs/:configToken/flows", handler="Flows", appsection="processes")
		.addRoute(pattern="/:flowSlug/setup-info", action={GET="getSetupInfo"}, anonymousActions=['getSetupInfo'] )
		.addRoute(pattern="/:flowSlug", action={GET="getByID", POST="update", DELETE="remove"})
		.addRoute(pattern="/", action={GET="list", POST="create"} )
	.endWith();


	//Documents
	with(pattern="/configs/:configToken/documents", handler="Documents", appsection="docs")
		.addRoute(pattern="/:documentID", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();
	
	//Configs
	with(pattern="/configs", handler="Configs", appsection="configs")
		.addRoute(pattern="/:configToken/barcodes/:barcode", action=idActions)
		.addRoute(pattern="/:configToken", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();
	
	//Users
	with(pattern="/users", handler="Users", appsection="users")
		.addRoute(pattern="/:userID", action=idActions)
		.addRoute(pattern="/", action=nonIdActions)
	.endWith();

	//questionTypes
	with(pattern="/questionTypes", handler="QuestionTypes", appsection="processes")
		.addRoute(pattern="/:questionType", action={ GET="getByID" })
		.addRoute(pattern="/", action={ GET="list" })
	.endWith();
	
	//UserTypes
	addRoute(pattern="/usertypes", handler="UserTypes", action=nonIdActions);
	
	// Your Application Routes
	addRoute(pattern=":handler/:action?");


	/** Developers can modify the CGI.PATH_INFO value in advance of the SES
		interceptor to do all sorts of manipulations in advance of route
		detection. If provided, this function will be called by the SES
		interceptor instead of referencing the value CGI.PATH_INFO.

		This is a great place to perform custom manipulations to fix systemic
		URL issues your Web site may have or simplify routes for i18n sites.

		@Event The ColdBox RequestContext Object
	**/
	function PathInfoProvider(Event){
		/* Example:
		var URI = CGI.PATH_INFO;
		if (URI eq "api/foo/bar")
		{
			Event.setProxyRequest(true);
			return "some/other/value/for/your/routes";
		}
		*/
		return CGI.PATH_INFO;
	}
</cfscript>