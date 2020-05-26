<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>AdCopyId提交</title>
<link rel="stylesheet" type="text/css" href="css/publicGoodList.css">
<style>
.error {color: #FF0000;}
.font {color: #eee;}
</style>
</head>
<body  bgcolor="#334960">

<a class="font" href="index.html">返回上一页</a>


<?php
// 定义变量并默认设置为空值
$CampaignIDErr = $cActionErr = "";
$CampaignID = $cAction = "";
$nameErr = $cActionErr = "";
$name = $cAction = "";
$playCountErr = $cActionErr = "";
$playCount = $cAction = "";
$startTimeErr = $cActionErr = "";
$startTime = $cAction = "";
$deadlineErr = $cActionErr = "";
$deadline = $cAction = "";

if ($_SERVER["REQUEST_METHOD"] == "POST")
{
    
    /*if (empty($_POST["CampaignID"]))
    {
        $CampaignIDErr = "CampaignID不得为空";
    }
    else
    {
        $CampaignID = test_input($_POST["CampaignID"]);
        // 检测名字是否只包含数字跟字母B
        if (!preg_match("/^[0-9]*$/",$CampaignID))
        {
            $CampaignIDErr = "请填写正确的CampaignID";
            $CampaignID = "";
        }
    }*/

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
	
    /*if (empty($_POST["playCount"]))
    {
        $playCountErr = "合同次数不得为空";
    }
    else
    {
        $playCount = test_input($_POST["playCount"]);
        // 检测名字是否只包含数字跟字母B
        if (!preg_match("/^[0-9]*$/",$playCount))
        {
            $playCountErr = "请填写正确的合同次数";
            $playCount = "";
        }
    }*/

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
		$playCount = test_input($_POST["playCount"]);
		$startTime = test_input($_POST["startTime"]);
		$deadline = test_input($_POST["deadline"]);
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
                        if (strtotime($deadline)<=strtotime($Date))
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
		if (!empty($CampaignID) && !empty($playCount) && !empty($deadline) && !empty($startTime))
		{
			/*if (!preg_match("/^([0-9]{4})-([0-9]{2})-([0-9]{2})$/",$deadline))
			{
				$deadlineErr = "截止日期只允许YYYY-MM-DD时间格式";
				$deadline ="";
                                CampaignIDErr = "请填写正确的CampaignID";
                                $CampaignID ="";
                                $playCountErr = "请填写正确的合同次数";
                                $playCount ="";
				$startTimeErr = "起始日期只允许YYYY-MM-DD时间格式";
                                $startTime ="";
			}	
			else
			{*/
			$con = mysqli_connect('127.0.0.1','root','STdg123!','BAB');
                	mysqli_query($con,'set names utf8');
                	$sql = "INSERT INTO adCopy (adCopyID,campaign,playCount,startTime,deadline) VALUES ('$name','$CampaignID','$playCount','$startTime','$deadline')";
        		$a = mysqli_query($con,$sql);
			/*}*/
		}
		/*else
		{
		$CampaignIDErr = "CampaignID不得为空";
		$playCountErr = "合同次数不得为空";
		$startTimeErr = "起始日期不得为空";
		$deadlineErr = "截止日期不得为空";
		}*/		
	}
      else
        {
		$con = mysqli_connect('127.0.0.1','root','STdg123!','BAB');
                mysqli_query($con,'set names utf8');
                $sql = "DELETE FROM adCopy where adCopyID=$name";
		$a = mysqli_query($con,$sql);
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

<h2 class="font">合同次数录入</h2>
<p><span class="error">* 号为必需字段</span></p>
<p><span class="error">如需修改相关信息，请删除指定ID后新增</span></p>
<form class="font" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
   <table>
   <tr>
   <td></td>
   <td><span class="error"><?php echo $nameErr;?></span></td>
   <td></td>
   <td><span class="error"><?php echo $CampaignIDErr;?></span></td>
   <td></td>
   <td><span class="error"><?php echo $playCountErr;?></span></td>
   <tr>
   <td>广告素材ID: </td>
   <td><input type="text" name="name" value="<?php echo $name;?>">
        <span class="error">*</span></td>
   <td>CampaignID: </td>
   <td><input type="text" name="CampaignID" value="<?php echo $CampaignID;?>">
        <span class="error">*</span></td>
   <td>合同次数：</td>
   <td><input type="text" name="playCount" value="<?php echo $playCount;?>">
	<span class="error">*</span></td></tr>
   <tr>
   <td></td>
   <td><span class="error"><?php echo $startTimeErr;?></span></td>
   <td></td>
   <td><span class="error"><?php echo $deadlineErr;?></span></td></tr>
   <tr>
   <td>起始日期：</td>
   <td><input type="text" name="startTime" value="<?php echo $startTime;?>">
        <span class="error">*</span></td></td>
   <td>截止日期：</td>
   <td><input type="text" name="deadline" value="<?php echo $deadline;?>">
	<span class="error">*</span></td></td></tr>
   </table>
<br>
   操作:
   <input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="add") echo "checked";?>  value="add">增加
   <input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="delete") echo "checked";?>  value="delete">删除
<!--   <input type="radio" name="cAction" <?php if (isset($cAction) && $cAction=="modify") echo "checked";?>  value="modify">修改 --!>
   <span class="error">* <?php echo $cActionErr;?></span>
   <br><br>
   <input type="submit" name="submit" value="提交">
</form>
<?php
echo "<h3 class=\"font\">合同次数清单:</h3>";
?>
<?php
echo "<table class=\"bordered\">";
echo "<tr><th>序号</th><th>广告素材ID</th><th>CampaignID</th><th>合同次数</th><th>起始时间</th><th>截止日期</th></tr>";

$Date = date('Y-m-d', time());

$con = mysqli_connect('127.0.0.1','root','STdg123!','BAB');
                        mysqli_query($con,'set names utf8');
                        $sql = "select * from `adCopy` where `deadline` >= '$Date' ";
                        $res = mysqli_query($con,$sql);
                        /*长度*/
                        $num=mysqli_num_rows($res);
                        for($i=0;$i<$num;$i++)
                        {
                                $sql_arr=mysqli_fetch_assoc($res);
                                $adCopyID = $sql_arr['adCopyID'];
				$CampaignID = $sql_arr['campaign'];
                                $playCount = $sql_arr['playCount'];
				$startTime = $sql_arr['startTime'];
                                $deadline = $sql_arr['deadline'];
                                echo "<tr><td width=\"20p\">";
				echo ($i + 1);
				echo "</td><td>$adCopyID</td><td>$CampaignID</td><td>$playCount</td><td>$startTime</td><td>$deadline</td></tr>";
                        }
echo "</table>"
?>

<footer class="footer">
 <p class="font">
Powered by MO-ITS
</p></footer>
</body>
</html>

