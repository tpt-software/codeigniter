<?php
$currentUrl = str_replace("admin/","",current_url());
$zt = $this->input->get('zt', false);
?>

<div class="menu_left">
    <ul class="layui-nav layui-nav-tree">
        <li class="layui-nav-item layui-nav-itemed"> <a href="javascript:;"><i class="fa fa-video-camera"></i>&nbsp;Video management</a>
            <dl class="layui-nav-child">
                <dd <?= $currentUrl == links('vod') ? 'class="layui-this"' : '' ?>><a  href="<?=links('vod')?>"><i class="fa fa-tasks"></i>&nbsp;Video list</a></dd>
                <dd <?= $currentUrl == links('fav') ? 'class="layui-this"' : '' ?>><a  href="<?=links('fav')?>"><i class="fa fa-flag"></i>&nbsp;Favorites list</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item layui-nav-itemed"> <a href="javascript:;"><i class="fa fa-list"></i>&nbsp;Category management</a>
            <dl class="layui-nav-child">
                <dd <?= $currentUrl == links('lists') ? 'class="layui-this"' : '' ?>><a href="<?=links('lists')?>"><i class="fa fa-list"></i>&nbsp;Category</a></dd>
                <dd <?= $currentUrl == links('lists','index','my') ? 'class="layui-this"' : '' ?>><a  href="<?=links('lists','index','my')?>"><i class="fa fa-user-secret"></i>&nbsp;Private classification</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item layui-nav-itemed"> <a href="javascript:;"><i class="fa fa-address-book"></i>&nbsp;Member management</a>
            <dl class="layui-nav-child">
                <dd <?= ($currentUrl == links('user')) && !$zt ? 'class="layui-this"' : '' ?>><a  href="<?=links('user')?>"><i class="fa fa-address-book"></i>&nbsp;Member list</a></dd>
                <dd <?= $currentUrl . '?zt=2' == links('user','','','zt=2') && $zt == 2 ? 'class="layui-this"' : '' ?>><a  href="<?=links('user','','','zt=2')?>"><i class="fa fa-clock-o"></i>&nbsp;Pending member</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item layui-nav-itemed"> <a href="javascript:;"><i class="fa fa-gear"></i>&nbsp;System management</a>
            <dl class="layui-nav-child">
                <dd <?= $currentUrl == links('setting') ? 'class="layui-this"' : '' ?>><a  href="<?=links('setting')?>"><i class="fa fa-gear"></i>&nbsp;System configuration</a></dd>
                <dd <?= $currentUrl == links('server') ? 'class="layui-this"' : '' ?>><a href="<?=links('server')?>"><i class="fa fa-server"></i>&nbsp;Server management</a></dd>
                <dd <?= $currentUrl == links('link') ? 'class="layui-this"' : '' ?>><a href="<?=links('link')?>"><i class="fa fa-link"></i>&nbsp;Links</a></dd>
                <dd <?= $currentUrl == links('sys') ? 'class="layui-this"' : '' ?>><a  href="<?=links('sys')?>"><i class="fa fa-user"></i>&nbsp;Administrator management</a></dd>
            </dl>
        </li>
    </ul>
</div>