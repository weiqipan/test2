<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<script type="text/javascript"
	src="http://api.map.baidu.com/api?v=2.0&ak=ielFb8cb0CKLGW2nDuWHGBTbejm5fusE"></script>
<script type="text/javascript" src="js/heatmap.js"></script>
<script type="text/javascript"
	src="http://api.map.baidu.com/library/Heatmap/2.0/src/Heatmap_min.js"></script>
<title>热力图功能示例</title>
<style type="text/css">
ul,li {
	list-style: none;
	margin: 0;
	padding: 0;
	float: left;
}

html {
	height: 100%
}

body {
	height: 100%;
	margin: 0px;
	padding: 0px;
	font-family: "微软雅黑";
}

#container {
	height: 650px;
	width: 100%;
}

#r-result {
	width: 100%;
}
</style>
</head>
<body>
	<div id="container"></div>
	<div id="r-result">
		<input type="button" onclick="openHeatmap();" value="显示热力图" /> 
		<input type="button" onclick="closeHeatmap();" value="关闭热力图" /> 
		<input type="button" onclick="openMarker()" value="打开标注" />
		<br>
		<form action="selectPriceToLoadMap.do" method="post">
		最低价格:<input type="text" name="minPrice">
		最高价格:<input type="text" name="maxPrice">
		<input type="submit" value="查询" onclick="openHeatmap();">
		</form>
	</div>
	<div>
		<textarea id="_position" hidden="hidden"></textarea>
	</div>
</body>
</html>
<script type="text/javascript">
	var map = new BMap.Map("container"); // 创建地图实例  

	var point = new BMap.Point(${avg_lng}, ${avg_lat});
	map.centerAndZoom(point, 15); // 初始化地图，设置中心点坐标和地图级别  
	map.enableScrollWheelZoom(); // 允许滚轮缩放  

	var points = ${usableHouses};
	//#这里面添加房价的经纬度，我的太多了，所以只拿了三个  

	if (!isSupportCanvas()) {
		alert('热力图目前只支持有canvas支持的浏览器,您所使用的浏览器不能使用热力图功能~')
	}
	//详细的参数,可以查看heatmap.js的文档 https://github.com/pa7/heatmap.js/blob/master/README.md  
	//参数说明如下:  
	/* visible 热力图是否显示,默认为true  
	 * opacity 热力的透明度,1-100  
	 * radius 势力图的每个点的半径大小  
	 * gradient  {JSON} 热力图的渐变区间 . gradient如下所示  
	 *  {  
	        .2:'rgb(0, 255, 255)',  
	        .5:'rgb(0, 110, 255)',  
	        .8:'rgb(100, 0, 255)'  
	    }  
	    其中 key 表示插值的位置, 0~1.  
	        value 为颜色值.  
	 */

	heatmapOverlay = new BMapLib.HeatmapOverlay({
		"radius" : 20,
		maxOpacity : .99,
		minOpacity : 0,
	});
	/* for (var i = 0; i < 10; i++) {
		var hotPoint = new BMap.Point(points[i].lng, points[i].lat);
		var marker = new BMap.Marker(hotPoint); // 创建标注
		map.addOverlay(marker); // 将标注添加到地图中    

		marker.addEventListener("click", getAttr);
		function getAttr() {
			var p = marker.getPosition(); //获取marker的位置
			p.id = "123";
			alert("点的位置是" + hotPoint.lng + "," + hotPoint.lat);
			alert("marker的位置是" + p.lng + "," + p.lat);
		}
	} */
	map.addOverlay(heatmapOverlay);
	/* map.addEventListener("mousemove",function(e){
		document.getElementById("_position").value=e.point.lng+","+e.point.lat;
	}); */

	heatmapOverlay.setDataSet({
		data : points,
		max : ${maxCount}

	});

	closeHeatmap();

	//判断浏览区是否支持canvas  
	function isSupportCanvas() {
		var elem = document.createElement('canvas');
		return !!(elem.getContext && elem.getContext('2d'));
	}

	function setGradient() {
		/*格式如下所示:  
		{  
		    0:'rgb(102, 255, 0)',  
		    .5:'rgb(255, 170, 0)',  
		    1:'rgb(255, 0, 0)'  
		}*/
		var gradient = {};
		var colors = document.querySelectorAll("input[type='color']");
		colors = [].slice.call(colors, 0);
		colors.forEach(function(ele) {
			gradient[ele.getAttribute("data-key")] = ele.value;
		});
		heatmapOverlay.setOptions({
			"gradient" : gradient
		});
	}

	function openHeatmap() {
		heatmapOverlay.show();
	}

	function closeHeatmap() {
		heatmapOverlay.hide();
	}
	function openMarker() {
		var _html;
		var p;
		for (var i = 0; i < 10; i++) {
			var hotPoint = new BMap.Point(points[i].lng, points[i].lat);
			var marker = new BMap.Marker(hotPoint); // 创建标注
			_html="<div>经纬度：";
			p=marker.getPosition();
			_html+=p.lng+","+p.lat;
			_html+="<img src=\"pic/东方君悦.jpg\" style=\"height:200px; \"></img>";
			_html+="</div>";
			map.addOverlay(marker); // 将标注添加到地图中    
			marker.addEventListener("click", function(e){		 
				this.openInfoWindow(new BMap.InfoWindow(_html));
			});
		}
	}
	
</script>
</body>
</html>
