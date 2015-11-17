/**
* Custom Application Security Interceptor
*/
component extends="coldbox.system.interceptor" output="true" {
	
	/*void function onException(event,struct interceptData, buffer){
		//logging here eventually
		
		//now send it to the auth handle error handler
		//writeDump(interceptData);abort;
		var stArgs = {
			"type" = "plain"
			,"contentType" = "application/json"
			,"statusCode" = 404
			,"statusText" = "Not Found"
			,"data" = customJSON.serialize(input={
					"msg" = interceptData.ehBean.getMissingAction()
					,"detail" = ""
					,"data" = interceptData.ehBean.getMemento()
			})
		};
	}*/
	/*function onInvalidEvent(event, interceptData) output="true"{
		// Log a warning eventually
		var stArgs = {
			"type" = "plain"
			,"contentType" = "application/json"
			,"statusCode" = 404
			,"statusText" = "Not Found"
			,"data" = {}
		};
		
		//finally render it out
		event.renderData(argumentCollection=stArgs).noExecution();
		return false;
	}*/
	
}
