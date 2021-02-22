<!DOCTYPE HTML>
<html>
<head>

<meta charset="utf-8">
<title>AdCopyId提交</title>
<link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no">
<style>
.error {color: #FF0000;}
</style>
</head>
<body>

<?php
// 定义变量并默认设置为空值
$CampaignIDErr = $cActionErr = "";
$CampaignID = $cAction = "";
$nameErr = $cActionErr = "";
$name = $cAction = "";
$customerNameErr = $cActionErr = "";
$customerName = $cAction = "";
$adLengthErr = $cActionErr = "";
$adLength = $cAction = "";
$playCountErr = $cActionErr = "";
$playCount = $cAction = "";
$startTimeErr = $cActionErr = "";
$startTime = $cAction = "";
$deadlineErr = $cActionErr = "";
$deadline = $cAction = "";
$SBIDErr = $cActionErr = "";
$SBID = $cAction = "";

if ($_SERVER["REQUEST_METHOD"] == "POST")
{
    
    if (empty($_POST["name"]))
    {
        $nameErr = "广告素材ID不得为空";
    }
    else
    {
        $name = test_input($_POST["name"]);
        // 检测名字是否只包含数字跟字母B
        if (!preg_match("/^[0-9]*$/",$name))
        {
            $nameErr = "请填写正确的素材ID";
            $name = "";
        }
    }
	
    if (empty($_POST["cAction"]))
    {
        $cActionErr = "增加或者删除指示是必需的";
    }
    else
    {
        $cAction = test_input($_POST["cAction"]);
    }

    if (!empty($name) && !empty($cAction))
    {
      if ($cAction == "add")
        {
		$CampaignID = test_input($_POST["CampaignID"]);
		$customerName = test_input($_POST["customerName"]);
		$adLength = test_input($_POST["adLength"]);
		$playCount = test_input($_POST["playCount"]);
		$startTime = test_input($_POST["startTime"]);
		$deadline = test_input($_POST["deadline"]);
		$SBID = test_input($_POST["SBID"]);
		if (empty($SBID))
                {
                        $SBIDErr = "SB号不得为空";
                }
		if (empty($customerName))
                {
			$customerNameErr = "客户名称不得为空";	
                }
		if (!empty($adLength))
                {
                if (!preg_match("/^[0-9]*$/",$adLength))
                        {
                                $adLengthErr = "请填写正确的广告时长";
                                $adLength ="";
                        }
                }
                else
                {
                        $adLengthErr = "广告时长不得为空";
                }
		if (!empty($CampaignID))
		{
		if (!preg_match("/^[0-9]*$/",$CampaignID))
			{
				$CampaignIDErr = "请填写正确的CampaignID";
                        	$CampaignID ="";
			}	
		}
		else
		{
			$CampaignIDErr = "CampaignID不得为空";
		}	
		
		if (!empty($playCount))
                {
                if (!preg_match("/^[0-9]*$/",$playCount))
                        {
                                $playCountErr = "请填写正确的CampaignID";
                                $playCount ="";
                        }
                }
                else
                {
                        $playCountErr = "合同次数不得为空";
                }		

		if (!empty($startTime))
                {
                if (!preg_match("/^([0-9]{4})-([0-9]{2})-([0-9]{2})$/",$startTime))
                        {
                                $startTimeErr = "YYYY-MM-DD时间格式";
                                $startTime ="";
                        }
                }
                else
                {
                        $startTimeErr = "起始日期不得为空";
                }
		$Date = date('Y-m-d', time());
		if (!empty($deadline))
                {
                if (!preg_match("/^([0-9]{4})-([0-9]{2})-([0-9]{2})$/",$deadline))
                        {
                                $deadlineErr = "YYYY-MM-DD时间格式";
				$deadline ="";
                        }
			else
			{
			if (strtotime($deadline)<strtotime($Date))
                		{
                        		$deadlineErr = "截止时间已过期";
                        		$deadline ="";
                		}
			}
                }
                else
                {
                        $deadlineErr = "截止日期不得为空";
                }
		if (!empty($SBID) && !empty($customerName) && !empty($adLength) && !empty($CampaignID) && !empty($playCount) && !empty($deadline) && !empty($startTime))
		{
			$con = mysqli_connect('10.179.245.222','STD-MO','STdg123!','BAB');
                	mysqli_query($con,'set names utf8');
                	$sql = "INSERT INTO customerInfo (adCopyID,customerName,adLength,campaignID,planCount,startTime,endTime,sbID) VALUES ('$name','$customerName','$adLength','$CampaignID','$playCount','$startTime','$deadline','$SBID')";
        		$a = mysqli_query($con,$sql);
		}
	}
      else
        {
		if ($cAction == "delete")
		{
			$con = mysqli_connect('10.179.245.222','STD-MO','STdg123!','BAB');
                	mysqli_query($con,'set names utf8');
                	$sql = "DELETE FROM customerInfo where adCopyID=$name";
			$a = mysqli_query($con,$sql);
		}
		else
		{	
			$CampaignID = test_input($_POST["CampaignID"]);
                	$customerName = test_input($_POST["customerName"]);
                	$adLength = test_input($_POST["adLength"]);
                	$playCount = test_input($_POST["playCount"]);
                	$startTime = test_input($_POST["startTime"]);
                	$deadline = test_input($_POST["deadline"]);
			$SBID = test_input($_POST["SBID"]);	
			$con = mysqli_connect('10.179.245.222','STD-MO','STdg123!','BAB');
                        mysqli_query($con,'set names utf8');
			if (!empty($SBID))
                        {
                                $sql = "update customerInfo set sbID=$SBID where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
			if (!empty($customerName))
			{ 
				$sql = "update customerInfo set customerName=$customerName where adCopyID=$name";
				$a = mysqli_query($con,$sql);
			}
			if (!empty($CampaignID))
                        {
                                $sql = "update customerInfo set CampaignID=$CampaignID where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
			if (!empty($adLength))
                        {
                                $sql = "update customerInfo set adLength=$adLength where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
			if (!empty($playCount))
                        {
                                $sql = "update customerInfo set planCount=$playCount where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
			if (!empty($startTime))
                        {
                                $sql = "update customerInfo set startTime='$startTime' where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
			if (!empty($deadline))
                        {
                                $sql = "update customerInfo set endTime='$deadline' where adCopyID=$name";
                                $a = mysqli_query($con,$sql);
                        }
		}
        }
  
    }
}

function test_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}
?>

<div class = "container">
	<div class="row">
		<h2>合同次数录入</h2>
	</div>
	<div class="row">
		<p class="text-danger"><strong><span class="glyphicon glyphicon-exclamation-sign"></span>如需修改相关信息，请删除指定ID后新增</strong></p>
	</div>
	<div class="row">
		<form class="font" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
   		<div class="input-group">
   		<span class="input-group-addon">广告素材ID</span>
   		<input type="text" class="form-control" name="name" value="<?php echo $name;?>">
		<span class="input-group-addon error"><?php echo $nameErr;?></span>
        	</div>
		<div class="input-group">
   		<span class="input-group-addon">SB_ID</span>
   		<input type="text" class="form-control" name="SBID" value="<?php echo $SBID;?>">
		<span class="input-group-addon error"></span>
		</div>
		<div class="input-group">
   		<span class="input-group-addon">客户名称</span>
   		<input type="text" class="form-control"name="customerName" value="<?php echo $customerName;?>">
		<span class="input-group-addon error"><?php echo $customerNameErr;?></span>
        	</div>
		<div class="input-group">
   		<span class="input-group-addon">CampaignID</span>
   		<input type="text" class="form-control" name="CampaignID" value="<?php echo $CampaignID;?>">
		<span class="input-group-addon error"><?php echo $CampaignIDErr;?></span>
        	</div>
		<div class="input-group">
		<span class="input-group-addon">合同次数</span>
   		<input type="text" class="form-control" name="playCount" value="<?php echo $playCount;?>">
		<span class="input-group-addon error"><?php echo $playCountErr;?></span>
		</div>
		<div class="input-group">
   		<span class="input-group-addon">起始日期</span>
   		<input type="text" class="form-control" name="startTime" value="<?php echo $startTime;?>">
		<span class="input-group-addon error"><?php echo $startTimeErr;?></span>
        	</div>
		<div class="input-group">
   		<span class="input-group-addon">截止日期</span>
   		<input type="text" class="form-control" name="deadline" value="<?php echo $deadline;?>">
		<span class="input-group-addon error"><?php echo $deadlineErr;?></span>
		</div>
		<div class="input-group">
   		<span class="input-group-addon">广告时长</span>
   		<input type="text" class="form-control" name="adLength" value="<?php echo $adLength;?>">
		<span class="input-group-addon error"><?php echo $adLengthErr;?></span>
        	</div>
		<label>操作:</label>
		<div>
		<label class="checkbox-inline">
   		<input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="add") echo "checked";?>  value="add">增加
		</label>
		<label class="checkbox-inline">
   		<input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="delete") echo "checked";?>  value="delete">删除
		</label>
		<label class="checkbox-inline">
   		<input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="delete") echo "checked";?>  value="update">更新
		</label>
   		<span class="error"><?php echo $cActionErr;?></span>
		</div>
   		<input type="submit"  class="form-control" class="btn btn-block btn-info" name="submit" value="提交">
		</form>
	</div>
	<div>
	<hr style="border-top:1px dashed #F0F0F0;" width="100%" color="#F0F0F0" size=1>
	</div>
	<div class="row">
<?php
echo "<h4 class=\"text-center\"><strong>合同次数清单</strong></h4>";
?>
<?php
echo "<table class=\"table table-bordered table-striped\">";
echo "<tr><th>序号</th><th>客户名称</th><th>SB_ID</th><th>广告素材ID</th><th>CampaignID</th><th>合同次数</th><th>广告时长/s</th><th>起始时间</th><th>截止日期</th></tr>";

$Date = date('Y-m-d', time());

$con = mysqli_connect('10.179.245.222','STD-MO','STdg123!','BAB');
                        mysqli_query($con,'set names utf8');
                        $sql = "select * from `customerInfo` where `endTime` >= '$Date' ";
                        $res = mysqli_query($con,$sql);
                        /*长度*/
                        $num=mysqli_num_rows($res);
                        for($i=0;$i<$num;$i++)
                        {
                                $sql_arr=mysqli_fetch_assoc($res);
                                $adCopyID = $sql_arr['adCopyID'];
				$customerName = $sql_arr['customerName'];
				$adLength = $sql_arr['adLength'];
				$CampaignID = $sql_arr['campaignID'];
                                $playCount = $sql_arr['planCount'];
				$startTime = $sql_arr['startTime'];
                                $deadline = $sql_arr['endTime'];
 				$SBID = $sql_arr['sbID'];
                                echo "<tr><td width=\"20p\">";
				echo ($i + 1);
				echo "</td><td>$customerName</td><td>$SBID</td><td>$adCopyID</td><td>$CampaignID</td><td>$playCount</td><td>$adLength</td><td>$startTime</td><td>$deadline</td></tr>";
                        }
echo "</table>"
?>
</div>
</div>
</body>
</html>

