<!DOCTYPE html>
<head>
<link href="/packs/assets/css/faq.min.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layer/theme/default/layer.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/admin/css/custom/vod_my.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/modules/layer/default/layer.css">
		<script src="<?=Web_Path?>packs/layui/layui.js"></script>
</head>
<body>
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row" >
                <div class="col-md-12">
                    <div class="portlet light portlet-fit portlet-form bordered">
                        <div class="portlet-title">
                            <div class="caption">
                                <i class="fa fa-question-circle fa-lg font-blue"></i>
                                <span class="caption-subject  font-blue sbold uppercase">Documents &nbsp;</span>
                                <span class="caption-helper"> （If you have more questions, please join the webmaster mutual help Telegram: <a href="https://t.me/+qH8JONlo_LI4M2Q9"> teeboyvz</a>） </span>
                            </div>
                        </div>
                        <div class="portlet-body">
                            <div class="faq-page faq-content-1">
                        <div class="faq-content-container">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="faq-section">
                                        <div class="panel-group accordion faq-content" id="accordion1">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <i class="fa fa-circle"></i>
                                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse_1"> How to use the "API"?</a>
                                                    </h4>
                                                </div>
                                                <div id="collapse_1" class="panel-collapse collapse">
                                                    <div class="panel-body">
                                                        <div class="">
    <div class="">
	<div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
				<div class="portlet-title">
                        <div class="caption">
                        <i class="fa fa-exclamation-triangle fa-lg font-red"></i>
                        <span class="caption-subject font-red bold uppercase">Important: Do not public your API KEY in anywhere</span>
                        </div>
                    </div>
					</div>
					</div>
					</div>
    <!--div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                        <i class="fa fa-clone fa-lg font-blue"></i>
                        <span class="caption-subject font-blue-sharp bold uppercase">Upload Video</span>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <pre><?= 'POST https://' . Web_Url . '/api/upload' ?></pre>
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_5">
                                <div style="margin-bottom: 10px;"><strong>Header Param:</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Content-Type</td>
                                        <td style="text-align: left;">
                                            multipart/form-data
                                        </td>
                                        <td>multipart/form-data</td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_6">
                                <div style="margin-bottom: 10px;"><strong>Post Data(Form Data):</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Video</td>
                                        <td style="text-align: left;">
                                            Mp4 file needs to be uploaded binary format
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>API Key</td>
                                        <td style="text-align: left;">
                                            User's API Key, get it from Member Center -> Account Settings -> API Key
                                        </td>
                                        <td><?=$user->apikey?></td>
                                    </tr>
                                    <tr>
                                        <td>CID</td>
                                        <td style="text-align: left;">
                                            Video class ID, obtained from api get video class /api/getvideoclass
                                        </td>
                                        <td>15</td>
                                    </tr>
                                    <tr>
                                        <td>FID</td>
                                        <td style="text-align: left;">
                                            Server ID, obtained from api get video class /api/getserver
                                        </td>
                                        <td>12</td>
                                    </tr>
                                    <tr>
                                        <td>MyCID</td>
                                        <td style="text-align: left;">
                                            My class id, obtained from api get my class /api/getmyclass
                                        </td>
                                        <td>17</td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="">
                        <div style="margin-bottom: 10px;"><strong>Response(json):</strong></div>
                        
<textarea cols="150" rows="13" disabled style="resize: none;">
{
    "status": "success", // Success or Error
    "msg": "Video upload complete",
    "did": 89276 // ID of the uploaded video
}</textarea>
                        
                    </div>
                </div>
            </div>
        </div-->
    <!--div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                <i class="fa fa-clone fa-lg font-blue"></i>
                <span class="caption-subject font-blue-sharp bold uppercase">Upload Video By Url (google drive / dropbox)</span>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <pre>POST {{base_url}}/api/uploadbyurl</pre>
                <div class="tab-content">
                <div class="tab-pane active" id="overview_5">
                    <div style="margin-bottom: 10px;">
                    <strong>Header Param:</strong>
                    </div>
                    <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>
                        <th> Param name </th>
                        <th> Description </th>
                        <th> Example </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>Content-Type</td>
                        <td style="text-align: left;"> application/json </td>
                        <td>application/json</td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <div class="tab-content">
                <div class="tab-pane active" id="overview_6">
                    <div style="margin-bottom: 10px;">
                    <strong>Post Data(Form Data):</strong>
                    </div>
                    <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>
                        <th> Param name </th>
                        <th> Description </th>
                        <th> Example </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>videoUrl</td>
                        <td style="text-align: left;"> Google drive or Dropbox </td>
                        <td>https://drive.google.com/file/d/1Cbk2t123123BPNXLf8yPaIA9h5VYIqId/view?usp=sharing</td>
                        </tr>
                        <tr>
                        <td>apikey</td>
                        <td style="text-align: left;"> User's API Key, get it from Member Center -&gt; Account Settings -&gt; API Key </td>
                        <td>O7J5oib2YXlCR3WtG2Oh5yIHsArH7</td>
                        </tr>
                        <tr>
                        <td>cid</td>
                        <td style="text-align: left;"> Video class ID, obtained from api get video class /api/getvideoclass </td>
                        <td>15</td>
                        </tr>
                        <tr>
                        <td>fid</td>
                        <td style="text-align: left;"> Server ID, obtained from api get video class /api/getserver </td>
                        <td>12</td>
                        </tr>
                        <tr>
                        <td>mycid</td>
                        <td style="text-align: left;"> My class id, obtained from api get my class /api/getmyclass </td>
                        <td>17</td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                </div>
            </div>
            <div class="">
                <div style="margin-bottom: 10px;">
                <strong>Response(json):</strong>
                </div>
<textarea cols="150" rows="13" disabled="" style="resize: none;">{
    "status": "success", // Success or Error
    "msg": "Video upload complete",
    "did": 89276 // ID of the uploaded video
}</textarea>
            </div>
            </div>
        </div>
    </div-->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                <i class="fa fa-clone fa-lg font-blue"></i>
                <span class="caption-subject font-blue-sharp bold uppercase">Update video</span>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <pre>POST {{base_url}}/api/updatevideo/{{vid}}</pre>
                <div class="tab-content">
                <div class="tab-content">
                    <div class="tab-pane active" id="overview_5">
                        <div style="margin-bottom: 10px;">
                        <strong>Url Param:</strong>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                            <th> Param name </th>
                            <th> Description </th>
                            <th> Example </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td>vid</td>
                            <td style="text-align: left;"> vid of video </td>
                            <td>abmnidiflg</td>
                            </tr>
                        </tbody>
                        </table>
                    </div>
                </div>
                <div class="tab-pane active" id="overview_5">
                    <div style="margin-bottom: 10px;">
                    <strong>Header Param:</strong>
                    </div>
                    <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>
                        <th> Param name </th>
                        <th> Description </th>
                        <th> Example </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>Content-Type</td>
                        <td style="text-align: left;"> application/json </td>
                        <td>application/json</td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <div class="tab-content">
                <div class="tab-pane active" id="overview_6">
                    <div style="margin-bottom: 10px;">
                    <strong>Post Data(Form Data):</strong>
                    </div>
                    <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>
                        <th> Param name </th>
                        <th> Description </th>
                        <th> Example </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>name</td>
                        <td style="text-align: left;"> Name of video (optional)</td>
                        <td>This is video name</td>
                        </tr>
                        <tr>
                        <td>apikey</td>
                        <td style="text-align: left;"> User's API Key, get it from Member Center -&gt; Account Settings -&gt; API Key (required)</td>
                        <td>O7J5oib2YXlCR3WtG2Oh5yIHsArH7</td>
                        </tr>
                        <tr>
                        <td>cid</td>
                        <td style="text-align: left;"> Video class ID, obtained from api get video class /api/getvideoclass (optional)</td>
                        <td>15</td>
                        </tr>
                        <tr>
                        <td>mycid</td>
                        <td style="text-align: left;"> My class id, obtained from api get my class /api/getmyclass (optional)</td>
                        <td>17</td>
                        </tr>
                    </tbody>
                    </table>
                </div>
                </div>
            </div>
            <div class="">
                <div style="margin-bottom: 10px;">
                <strong>Response(json):</strong>
                </div>
<textarea cols="150" rows="13" disabled="" style="resize: none;">{
    "status": "success", // Success or Error
    "msg": "Updated"
}</textarea>
            </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                <i class="fa fa-clone fa-lg font-blue"></i>
                <span class="caption-subject font-blue-sharp bold uppercase">Delete video</span>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <pre>POST {{base_url}}/api/deletevideo/{{vid}}</pre>
                <div class="tab-content">
                    <div class="tab-pane active" id="overview_5">
                        <div style="margin-bottom: 10px;">
                        <strong>Url Param:</strong>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                            <th> Param name </th>
                            <th> Description </th>
                            <th> Example </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td>vid</td>
                            <td style="text-align: left;"> vid of video </td>
                            <td>abmnidiflg</td>
                            </tr>
                        </tbody>
                        </table>
                    </div>
                </div>
                <div class="tab-content">
                    <div class="tab-pane active" id="overview_5">
                        <div style="margin-bottom: 10px;">
                        <strong>Header Param:</strong>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                            <th> Param name </th>
                            <th> Description </th>
                            <th> Example </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td>Content-Type</td>
                            <td style="text-align: left;"> application/json </td>
                            <td>application/json</td>
                            </tr>
                        </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <div class="tab-content">
                <div class="tab-pane active" id="overview_6">
                    <div style="margin-bottom: 10px;">
                    <strong>Post Data(Form Data):</strong>
                    </div>
                    <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>
                        <th> Param name </th>
                        <th> Description </th>
                        <th> Example </th>
                        </tr>
                    </thead>
                    <tbody>
                       
                        <tr>
                        <td>apikey</td>
                        <td style="text-align: left;"> User's API Key, get it from Member Center -&gt; Account Settings -&gt; API Key (required)</td>
                        <td>O7J5oib2YXlCR3WtG2Oh5yIHsArH7</td>
                        </tr>
                        
                    </tbody>
                    </table>
                </div>
                </div>
            </div>
            <div class="">
                <div style="margin-bottom: 10px;">
                <strong>Response(json):</strong>
                </div>
<textarea cols="150" rows="13" disabled="" style="resize: none;">{
    "status": "success", // Success or Error
    "msg": "Deleted!"
}</textarea>
            </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                <i class="fa fa-clone fa-lg font-blue"></i>
                <span class="caption-subject font-blue-sharp bold uppercase">Get detail of video</span>
                </div>
            </div>
            <div class="portlet-body tabbable-line">
                <pre>POST {{base_url}}/api/getvideodetail/{{vid}}?apikey={{apikey}}</pre>
                <div class="tab-content">
                    <div class="tab-pane active" id="overview_5">
                        <div style="margin-bottom: 10px;">
                        <strong>Url Param:</strong>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                            <th> Param name </th>
                            <th> Description </th>
                            <th> Example </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td>vid</td>
                            <td style="text-align: left;"> vid of video </td>
                            <td>abmnidiflg</td>
                            </tr>
                            <tr>
                            <td>apikey</td>
                            <td style="text-align: left;"> User's API Key, get it from Member Center -&gt; Account Settings -&gt; API Key (required) </td>
                            <td>O7J5oib2YXlCR3WtG2Oh5yIHsArH7</td>
                            </tr>
                        </tbody>
                        </table>
                    </div>
                </div>
                <div class="tab-content">
                    <div class="tab-pane active" id="overview_5">
                        <div style="margin-bottom: 10px;">
                        <strong>Header Param:</strong>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                        <thead>
                            <tr>
                            <th> Param name </th>
                            <th> Description </th>
                            <th> Example </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td>Content-Type</td>
                            <td style="text-align: left;"> application/json </td>
                            <td>application/json</td>
                            </tr>
                        </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="">
                <div style="margin-bottom: 10px;">
                <strong>Response(json):</strong>
                </div>
<textarea cols="150" rows="13" disabled="" style="resize: none;">{
    "status": "success",
    "msg": "Success",
    "data": {
        "id": "89272",
        "vid": "xuz",
        "name": "3333",
        "cid": "Videos",
        "hits": "0",
        "duration": "00:00",
        "size": "0 B",
        "uid": "225",
        "addtime": "01-05-2024 | 14:44:22",
        "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/xuz\" frameborder=\"0\" allowfullscreen></iframe>",
        "link": "https://source.build:8080/play/index/xuz",
        "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/xuz\" frameborder=\"0\" allowfullscreen></iframe>",
        "vip_link": "https://source.build:8080/vip/index/xuz"
    }
}</textarea>
            </div>
            </div>
        </div>
    </div>
        <div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                        <div class="caption">
                           <i class="fa fa-clone fa-lg font-blue"></i>
                        <span class="caption-subject font-blue-sharp bold uppercase">Get the Server list for the current user</span>
                        </div>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <pre><?= 'GET https://' . Web_Url . '/api/getserver?apikey={{apikey}}' ?></pre>
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_1">
                                <div style="margin-bottom: 10px;"><strong>Request Param:</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>API Key</td>
                                        <td style="text-align: left;">
                                            User's API Key, get it from Member Center -> Account Settings -> API Key
                                        </td>
                                        <td><?=$user->apikey?></td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="">
                        <div style="margin-bottom: 10px;"><strong>Response(json):</strong></div>
                        
<textarea cols="150" rows="13" disabled style="resize: none;">
{
    "status": "success", // Success or Error 
    "msg": "",
    "data": [
        {
            "12": "Server 1" // ID and name of the server
        },
        {
            "18": "Server 2"
        }
    ]
}
</textarea>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                        <i class="fa fa-clone fa-lg font-blue"></i>
                        <span class="caption-subject font-blue-sharp bold uppercase">Get the list of Video classes (Video classification)</span>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <pre><?= 'GET https://' . Web_Url . '/api/getvideoclass?apikey={{apikey}}' ?></pre>
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_2">
                                <div style="margin-bottom: 10px;"><strong>Request Param:</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>API Key</td>
                                        <td style="text-align: left;">
                                            User's API Key, get it from Member Center -> Account Settings -> API Key
                                        </td>
                                        <td><?=$user->apikey?></td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="">
                        <div style="margin-bottom: 10px;"><strong>Response(json):</strong></div>
                        
<textarea cols="150" rows="20" disabled style="resize: none;">
{
    "status": "success", // Success or Error 
    "msg": "",
    "data": [
        {
            "15": "Videos" // ID of video class and name of video class, on the web it is "Video classification"
        },
        {
            "16": "Short videos"
        },
        {
            "17": "18+"
        },
        {
            "18": "Hentai"
        },
        {
            "19": "Others"
        }
    ]
}</textarea>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                        <i class="fa fa-clone fa-lg font-blue"></i>
                        <span class="caption-subject font-blue-sharp bold uppercase">Get the list of User's Video class (Private classification)</span>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <pre><?= 'GET https://' . Web_Url . '/api/getmyclass?apikey={{apikey}}' ?></pre>
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_3">
                                <div style="margin-bottom: 10px;"><strong>Request Param:</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>API Key</td>
                                        <td style="text-align: left;">
                                            User's API Key, get it from Member Center -> Account Settings -> API Key
                                        </td>
                                        <td><?=$user->apikey?></td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="">
                        <div style="margin-bottom: 10px;"><strong>Response(json):</strong></div>
                        
<textarea cols="150" rows="13" disabled style="resize: none;">
{
    "status": "success", // Success or Error 
    "msg": "",
    "data": [
        {
            "17": "Video"  // ID of Private class and name of Private class
        }
    ]
}</textarea>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                        <i class="fa fa-clone fa-lg font-blue"></i>
                        <span class="caption-subject font-blue-sharp bold uppercase">Get the list of Videos of the current User</span>
                        </div>
                    </div>
                    <div class="portlet-body tabbable-line">
                        <pre><?= 'GET https://' . Web_Url . '/api/myvideo?apikey={{apikey}}&page=1&per_page=20&search=abc&zt=0&cid=15&fid=12&mycid=15&sort_field&sort_by=desc' ?></pre>
                        <div class="tab-content">
                            <div class="tab-pane active" id="overview_4">
                                <div style="margin-bottom: 10px;"><strong>Request Param:</strong></div>
                                <table class="table table-striped table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th> Param name </th>
                                        <th> Description </th>
                                        <th> Example </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>apikey</td>
                                        <td style="text-align: left;">
                                            User's API Key, get it from Member Center -> Account Settings -> API Key
                                        </td>
                                        <td><?=$user->apikey?></td>
                                    </tr>
                                    <tr>
                                        <td>page</td>
                                        <td style="text-align: left;">
                                            current page
                                        </td>
                                        <td>1</td>
                                    </tr>
                                    <tr>
                                        <td>per_page</td>
                                        <td style="text-align: left;">
                                            number of result per one page
                                        </td>
                                        <td>20</td>
                                    </tr>
                                    <tr>
                                        <td>search</td>
                                        <td style="text-align: left;">
                                            search by name
                                        </td>
                                        <td>abc</td>
                                    </tr>
                                    <tr>
                                        <td>zt</td>
                                        <td style="text-align: left;">
                                            Transcoded status : 0 1 2 3
                                        </td>
                                        <td>0</td>
                                    </tr>
                                    <tr>
                                        <td>cid</td>
                                        <td style="text-align: left;">
                                            Video class id
                                        </td>
                                        <td>15</td>
                                    </tr>
                                    <tr>
                                        <td>mycid</td>
                                        <td style="text-align: left;">
                                            Private class
                                        </td>
                                        <td>17</td>
                                    </tr>
                                    <tr>
                                        <td>fid</td>
                                        <td style="text-align: left;">
                                            server id
                                        </td>
                                        <td>12</td>
                                    </tr>
                                    <tr>
                                        <td>sort_field</td>
                                        <td style="text-align: left;">
                                            sort field
                                        </td>
                                        <td>id , name, hits , duration </td>
                                    </tr>
                                    <tr>
                                        <td>sort_by</td>
                                        <td style="text-align: left;">
                                            sort by
                                        </td>
                                        <td>asc , desc</td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="">
                        <div style="margin-bottom: 10px;"><strong>Response(json):</strong></div>
                        
<textarea cols="150" rows="13" disabled style="resize: none;">
{
    "status": "success",
    "msg": "",
    "total_item": 23,
    "total_page": 5,
    "current_page": 1,
    "count": 5,
    "data": [
        {
            "id": "89299",
            "vid": "2acaa2fc1ab6",
            "name": "1234-13",
            "cid": "Videos",
            "hits": "1",
            "duration": "00:05",
            "size": "2.72 MB",
            "uid": "225",
            "addtime": "03-05-2024 | 18:54:23",
            "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/2acaa2fc1ab6\" frameborder=\"0\" allowfullscreen></iframe>",
            "link": "https://source.build:8080/play/index/2acaa2fc1ab6",
            "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/2acaa2fc1ab6\" frameborder=\"0\" allowfullscreen></iframe>",
            "vip_link": "https://source.build:8080/vip/index/2acaa2fc1ab6"
        },
        {
            "id": "89298",
            "vid": "8aa0850975e1",
            "name": "1234-11",
            "cid": "Videos",
            "hits": "4",
            "duration": "00:05",
            "size": "2.72 MB",
            "uid": "225",
            "addtime": "03-05-2024 | 18:04:55",
            "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/8aa0850975e1\" frameborder=\"0\" allowfullscreen></iframe>",
            "link": "https://source.build:8080/play/index/8aa0850975e1",
            "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/8aa0850975e1\" frameborder=\"0\" allowfullscreen></iframe>",
            "vip_link": "https://source.build:8080/vip/index/8aa0850975e1"
        },
        {
            "id": "89297",
            "vid": "831c8da52e46",
            "name": "1234-10",
            "cid": "Videos",
            "hits": "0",
            "duration": "00:05",
            "size": "2.72 MB",
            "uid": "225",
            "addtime": "03-05-2024 | 18:02:49",
            "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/831c8da52e46\" frameborder=\"0\" allowfullscreen></iframe>",
            "link": "https://source.build:8080/play/index/831c8da52e46",
            "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/831c8da52e46\" frameborder=\"0\" allowfullscreen></iframe>",
            "vip_link": "https://source.build:8080/vip/index/831c8da52e46"
        },
        {
            "id": "89296",
            "vid": "f6bd1de85588",
            "name": "1234-9",
            "cid": "Videos",
            "hits": "0",
            "duration": "00:05",
            "size": "2.72 MB",
            "uid": "225",
            "addtime": "03-05-2024 | 18:02:03",
            "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/f6bd1de85588\" frameborder=\"0\" allowfullscreen></iframe>",
            "link": "https://source.build:8080/play/index/f6bd1de85588",
            "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/f6bd1de85588\" frameborder=\"0\" allowfullscreen></iframe>",
            "vip_link": "https://source.build:8080/vip/index/f6bd1de85588"
        },
        {
            "id": "89295",
            "vid": "a2c",
            "name": "123",
            "cid": "Videos",
            "hits": "0",
            "duration": "00:00",
            "size": "0 B",
            "uid": "225",
            "addtime": "02-05-2024 | 00:24:05",
            "iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/play/index/a2c\" frameborder=\"0\" allowfullscreen></iframe>",
            "link": "https://source.build:8080/play/index/a2c",
            "vip_iframe": "<iframe width=\"100%\" height=\"100%\" src=\"https://source.build:8080/vip/index/a2c\" frameborder=\"0\" allowfullscreen></iframe>",
            "vip_link": "https://source.build:8080/vip/index/a2c"
        }
    ]
}</textarea>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                                                    </div>
                                                </div>
                                            </div>
										    <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <h4 class="panel-title">
                                                        <i class="fa fa-circle"></i>
                                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse_2"> How to use "Subtitle"?</a>
                                                    </h4>
                                                </div>
                                                <div id="collapse_2" class="panel-collapse collapse">
                                                    <div class="panel-body">
                                                         <p><a href="https://14412882.net/sub.json" target="_blank">Download Json file</a></p>
                                                        <p> Supported subtitle files have the <strong>.vtt</strong> extension</p>
														<p> Demo: <a href="https://14412882.net/play/index/45dd70ebf55f?subjson_url=https://14412882.com/sub.json" target="_blank">https://14412882.net/play/index/45dd70ebf55f?subjson_url=https://14412882.com/sub.json</a></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                                   