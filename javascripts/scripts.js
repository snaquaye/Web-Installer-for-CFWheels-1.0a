/**
 * @author SQuaye
 */
$("document").ready(function(){
	//Hides the new and exisiting datasource form 
	$("div#datasourceInfo").css("display","none");
	$("div#newDatasource").css("display","none");
	//Hides or show a form based on the input from the user.
	$("input[name=datasourceExist]").change(function(){
		if($("input[name=datasourceExist]:checked").val() == "Yes"){
			$("div#datasourceInfo").show();
			$("div#newDatasource").css("display","none");
		}else{
			$("div#datasourceInfo").css("display","none");
			$("div#newDatasource").show();
		}
	})
})