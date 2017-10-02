// var empStates = <%=raw @states%>;
// var empStatesCompValues = <%=raw @empStatesComp.values%>;
// var empStatesInProgValues = <%=raw @empStatesInProg.values%>;


var barChartData = {

		labels : empStates,
		datasets : [
			{
				fillColor : "rgba(255,224,30,0.75)",
				strokeColor : "rgba(220,220,220,0.8)",
				highlightFill: "rgba(255,224,30,0.45)",
				highlightStroke: "rgba(220,220,220,1)",
				data : empStatesCompValues
			},
			{
				fillColor : "rgba(220,220,220,0.65)",
				strokeColor : "rgba(220,220,220,0.8)",
				highlightFill : "rgba(220,220,220,0.35)",
				highlightStroke : "rgba(220,220,220,1)",
				data : empStatesInProgValues
			}
		]

	}