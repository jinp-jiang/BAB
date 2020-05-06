<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>DP站点屏幕播放详情</title>
<link rel="stylesheet" type="text/css" href="css/hostID.css">
<style>
.error {color: #FF0000;}
.font {color: #eee;}
</style>
</head>
<body>

<!--<a class="font" href="index.html">返回上一页</a>



<br><br>--!>

<?php
echo "<table class=\"bordered\" cellpadding=\"0\" cellspacing=\"0\">";
/*echo "<tr style=\"position: fixed;\"><th style=\"width: 20p\">序号</th><th style=\"width: 60px\">站点屏幕</th>";*/
echo "<tr><th rowspan=2>序号</th><th rowspan=2>DP站点屏幕</th>";

$con = mysqli_connect('127.0.0.1','root','STdg123!','BAB');
	mysqli_query($con,'set names utf8');
	$sql = 'select `campaignID` from `DPadCopyId` group by `campaignID`';
        $res = mysqli_query($con,$sql);
	$num = mysqli_num_rows($res);
        for($i=0;$i<$num;$i++)
	{	
		$sql_arr=mysqli_fetch_assoc($res);
		$CampaignID = $sql_arr['campaignID'];
		echo "<th colspan=2>$CampaignID</th>";
	}
	echo "</tr>";
	echo "<tr>";
	for($i=0;$i<$num;$i++)
        {
                echo "<th>合同次数</th><th>实际次数</th>";
        }
	echo "</tr>";
	
	
	/*echo "</table>";
	echo "<br><br>";
	echo "<table class=\"bordered\" cellpadding=\"0\" cellspacing=\"0\">";*/
        $sqls = "SELECT `screenID` FROM `DPadCopyId` group by `screenID`";
	$ress = mysqli_query($con,$sqls);
        $nums=mysqli_num_rows($ress);
        for($i=0;$i<$nums;$i++)
        {
		$sql_arr = mysqli_fetch_assoc($ress);
		$screen = $sql_arr['screenID'];
		echo "<tr><td width=\"20p\">";
        	echo ($i + 1);
		echo "</td><td>$screen</td>";
		$sqlCam = "select `campaignID` from `DPadCopyId` group by `campaignID`";
		$resCam = mysqli_query($con,$sqlCam);
		$numCam = mysqli_num_rows($resCam);
		for ($a=0;$a<$numCam;$a++)
		{	
			$sql_arrCam = mysqli_fetch_assoc($resCam);
			$CampaignID = $sql_arrCam['campaignID'];
    			$sqlc = "select `historyCount`,`planCount` from `DPadCopyId` where `campaignID` = '{$CampaignID}' and `screenID` = '{$screen}'";
			$resc = mysqli_query($con,$sqlc);
			$sql_arrCount = mysqli_fetch_assoc($resc);
			$historyCount = $sql_arrCount['historyCount'];
			$planCount = $sql_arrCount['planCount'];
			echo "<td title=\"Campaign $CampaignID 合同次数\">$planCount</td><td title=\"Campaign $CampaignID 实际次数\">$historyCount</td>";
		}
		echo "</tr>";
	}
echo "</table>";
?>

<!--<footer class="footer">
 <p class="font">
Powered by MO-ITS
</p></footer>--!>
</body>
</html>

