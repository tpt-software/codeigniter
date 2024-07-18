<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <meta http-equiv="X-UA-Compatible" content="IE=9">
        <title>Backstage management</title>
        <link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/layui/css/layui.css">
        <link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/admin/css/common.css?v=1.1">
        <link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
        <script src="<?=Web_Path?>packs/jquery/jquery.min.js"></script>
		<script src="<?=Web_Path?>packs/jquery/jquery.js"></script>
        <script src="<?=Web_Path?>packs/layui/layui.js"></script>
		<script src="<?=Web_Path?>js/chart.js"></script>
    </head>
    <body style="padding: 10px;">
        <table class="layui-table">
            <thead>
                <tr>
                    <th colspan="2">Login information</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="2"><b>Administrator</b> | <b>Last Login Time:</b> <font color="red"><i><?=date('Y-m-d H:i:s',$logtime)?></i></font> | <b>Last login IP:</b> <font color="red"><i><?=$logip?></td></i></font>
                </tr>
            </tbody>
			
            <thead>
                <tr>
                    <th colspan="2">Video Statistics</th>
                </tr>
            </thead>
            <tbody>
						<?php
// Định nghĩa các giá trị thống kê
$jcount;
$zcount;
$bcount;
$scount;
$count;
$dzcount;

// Tạo một mảng chứa các giá trị
$data = array(
    'Today quantity' => $jcount,
    'Yesterday quantity' => $zcount,
    'This Month' => $bcount,
    'Last Month' => $scount,
    'Total' => $count,
    /* 'To be transcoded' => $dzcount */
);

// Chuyển mảng dữ liệu thành mảng JSON
$data_json = json_encode($data);
?>
                <tr>
                    <td colspan="2"><b>Today's quantity:</b> <font color="red"><i><?=$jcount?></i></font> | <b>Yesterday's quantity:</b> <font color="red"><i><?=$zcount?></i></font> |  <b>Quantity of this month:</b> <font color="red"><i><?=$bcount?></i></font> |  <b>Last month's quantity:</b> <font color="red"><i><?=$scount?></i></font> | <b>The total amount:</b> <font color="red"><i><?=$count?></i></font> | <b>Quantity to be transcoded:</b> <font color="red"><i><?=$dzcount?></i></font> | <b>Quantity transcode fail:</b> <font color="red"><i><?=$fzcount?></i></font></td>
                </tr>
            </tbody>
			</table>
			<table>
			<!--canvas id="statisticsChart" style="width: 510px; height: 280px;"></canvas-->
			</table>
<script>
    // Lấy dữ liệu từ PHP
    var data = <?php echo json_encode($data); ?>;

    // Tạo mảng chứa các nhãn và giá trị từ dữ liệu PHP
    var labels = Object.keys(data);
    var values = Object.values(data);

    // Lấy thẻ canvas để vẽ biểu đồ
    var ctx = document.getElementById('statisticsChart').getContext('2d');

    // Vẽ biểu đồ
    var chart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [{
            label: 'Statistics',
            data: values,
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)', // Màu cho Today
                'rgba(54, 162, 235, 0.2)', // Màu cho Yesterday
                'rgba(255, 206, 86, 0.2)', // Màu cho This Month
                'rgba(75, 192, 192, 0.2)', // Màu cho Last Month
                'rgba(153, 102, 255, 0.2)', // Màu cho Total
                //'rgba(255, 159, 64, 0.2)' // Màu cho To be transcoded
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)', // Màu viền cho Today
                'rgba(54, 162, 235, 1)', // Màu viền cho Yesterday
                'rgba(255, 206, 86, 1)', // Màu viền cho This Month
                'rgba(75, 192, 192, 1)', // Màu viền cho Last Month
                'rgba(153, 102, 255, 1)', // Màu viền cho Total
                //'rgba(255, 159, 64, 1)' // Màu viền cho To be transcoded
            ],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
</script>
<table class="layui-table">
            <colgroup>
                <col width="140">
            </colgroup>
            <thead>
                <tr>
                    <th colspan="2">Basic information of the website</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><b>Name of software</b></td>
                    <td>Network disk cloud storage system V2.2</td>
                </tr>
                <tr>
                    <td><b>Maximum allowed uploads</b></td>
                    <td><?=get_cfg_var("upload_max_filesize")?></td>
                </tr>
                <tr>
                    <td><b>POST submission max</b></td>
                    <td><?=get_cfg_var("post_max_size")?></td>
                </tr>
                <tr>
                    <td><b>Server IP</b></td>
                    <td><?php if('/'==DIRECTORY_SEPARATOR){echo $_SERVER['SERVER_ADDR'];}else{echo gethostbyname($_SERVER['SERVER_NAME']);} ?></td>
                </tr>
                <tr>
                    <td><b>Source code</b></td>
                    <td><font color="red">14412882.com</font></td>
                </tr>
            </tbody>
        </table>
    </body>
</html>