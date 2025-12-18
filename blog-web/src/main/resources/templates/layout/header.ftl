<nav id="topmenu" class="navbar navbar-default navbar-fixed-top">
    <div class="menu-box">
        <div class="pull-left">
            <ul class="list-unstyled list-inline">
                <li><span id="currentTime"></span></li>
            </ul>
            <div class="clear"></div>
        </div>
        <div class="menu-topmenu-container pull-right">
            <ul class="list-unstyled list-inline pull-left">
                <li><a href="${config.siteUrl}/about" class="menu_a" title="关于博客" data-toggle="tooltip" data-placement="bottom">关于本站</a></li>
                <li><a href="${config.siteUrl}/links" class="menu_a" title="友情链接" data-toggle="tooltip" data-placement="bottom">友情链接</a></li>
                <li><a href="${config.siteUrl}/guestbook" class="menu_a" title="友情链接" data-toggle="tooltip" data-placement="bottom">留言板</a></li>
            </ul>
            <!-- ===================================================================== -->
            <!-- 👇 修复版：右侧用户菜单 (修复对齐，修复双重显示) 👇 -->
            <!-- ===================================================================== -->
            <ul class="list-unstyled list-inline pull-left">

                <#-- 情况1：未登录 -->
                <#if !Session["user"]??>
                    <li style="line-height: 35px;">
                        <a href="/login" style="padding-top: 50px; padding-bottom: 15px;">登录</a>
                    </li>
                    <li style="line-height: 35px;">
                        <a href="/register" style="padding-top: 50px; padding-bottom: 15px;">注册</a>
                    </li>
                <#else>
                <#-- 情况2：已登录 -->
                    <#assign currentUser = Session["user"]>

                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" style="padding-top: 15px; padding-bottom: 15px;">
                            <#-- 头像 -->
                            <img src="${(currentUser.avatar)!('/assets/img/default-avatar.png')}"
                                 style="width: 24px; height: 24px; border-radius: 50%; margin-right: 5px; vertical-align: top; margin-top: -2px;">

                            <#-- 只显示账号名 (username) -->
                            <span>${currentUser.username}</span>
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="/user/profile"><i class="fa fa-user"></i> 个人中心</a></li>
                            <li role="separator" class="divider"></li>
                            <li><a href="/logout"><i class="fa fa-sign-out"></i> 退出登录</a></li>
                        </ul>
                    </li>
                </#if>
            </ul>
        </div>
    </div>
</nav>
<div class="modal" id="oauth" tabindex="-1" role="dialog" aria-labelledby="oauthTitle">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <ul class="list-inline">
                    <li><h4 class="modal-title" id="oauthTitle">登录</h4></li>
                    <li><a href="javascript:$.alert.info('没用，别点了！我就没打算开发这个功能。Just to show you~~~');"><h4 class="modal-title" id="myModalLabel">注册</h4></a></li>
                </ul>
            </div>
            <div class="modal-body">
                <div class="oauth">
                    <ul class="list-unstyled list-inline oauth-list" style="text-align: center;">
                        <@zhydTag method="listAvailableOAuthPlatforms">
                            <#if listAvailableOAuthPlatforms?? && listAvailableOAuthPlatforms?size gt 0>
                                <#list listAvailableOAuthPlatforms as item>
                                    <li>
                                        <a href="${config.siteUrl}/oauth/social/${item.platform}" target="">
                                            <img src="${item.logo}" alt="" class="img-circle">
                                        </a>
                                    </li>
                                </#list>
                            <#else>
                                <li>
                                    稍等一下， 博主正在快马加鞭的配置~~
                                </li>
                            </#if>
                        </@zhydTag>
                    </ul>
                    <div class="oauth-line">
                        <span style="font-size: 12px">
                            Powered by <a href="https://gitee.com/fujieid/jap" target="_blank">JustAuthPlus(JAP)</a>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<nav id="mainmenu" class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="menu-box">
        <div class="navbar-header">
            <span class="pull-right nav-search toggle-search" data-toggle="modal" data-target=".nav-search-box"><i class="fa fa-search"></i></span>
            <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">
                <img alt="Brand" src="${config.siteFavicon}">${config.siteName}
            </a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <div class="pull-left site-desc">
                <h1 class="auto-shake"><a href="${config.siteUrl}" data-original-title="${config.siteDesc}" data-toggle="tooltip" data-placement="bottom">${config.siteName}</a></h1>
                <p class="site-description">${config.siteDesc}</p>
            </div>
            <ul class="nav navbar-nav ">
                <li>
                    <a href="/" class="menu_a"><i class="fa fa-home"></i>首页</a>
                </li>
                <@zhydTag method="types">
                    <#if types?? && types?size gt 0>
                        <#list types as item>
                            <#if item.nodes?? && item.nodes?size gt 0>
                                <li class="dropdown">
                                    <a href="/type/${item.id?c}" class="menu_a">
                                        <i class="${item.icon!}"></i>${item.name!} <span class="caret dropdown-toggle" data-toggle="dropdown" aria-expanded="false"></span>
                                    </a>
                                    <ul class="dropdown-menu" role="menu">
                                        <#list item.nodes as node>
                                        <li><a href="/type/${node.id?c}" title="点击查看《${node.name!}》的文章">${node.name!}</a></li>
                                        </#list>
                                    </ul>
                                </li>
                            <#else>
                                <li><a href="/type/${item.id?c}" class="menu_a"><i class="${item.icon!}"></i>${item.name!}</a></li>
                            </#if>
                        </#list>
                    </#if>
                </@zhydTag>
                <li><span class="pull-right nav-search main-search" data-toggle="modal" data-target=".nav-search-box"><i class="fa fa-search"></i></span></li>
            </ul>
        </div>
    </div>
</nav>
