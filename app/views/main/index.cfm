<cfoutput>
<div class="jumbotron">
	<div class="row">
		<div class="col-md-5">
			<img src="includes/images/ColdBoxLogo2015_300.png" class="pull-left margin10" alt="logo"/>
			<p class="text-center">
				<a class="btn btn-primary" href="http://coldbox.ortusbooks.com" target="_blank" title="Read our ColdBox Manual" rel="tooltip">
					<strong>Read ColdBox Manual</strong>
				</a>
			</p>
		</div>

		<div class="col-md-7">
			<h1>#prc.welcomeMessage#</h1>
			<p>
				You are now running <strong>#getSetting("codename",1)# #getSetting("version",1)# (#getsetting("suffix",1)#)</strong> outside the webroot.
				Welcome to the next generation of ColdFusion (CFML) applications.  You can now start building your application with ease, we already did the hard work
				for you (Luis did)...
			</p>
		</div>
	</div>
</div>


</cfoutput>