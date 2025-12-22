<#--
    Sakura Style Header for OneBlog
    整合了：透明滚动特效、Session用户信息、动态分类、FontAwesome动画
-->
<nav id="mainmenu" class="navbar navbar-default navbar-fixed-top site-header <#if request.requestURI == '/'>home<#else>inner</#if>" role="navigation">


        <#-- 导航主体 -->
        <div id="navbar" class="navbar-collapse collapse flex-container ">
            <div class="nav-left">
                <span>您的LOGO</span>
            </div>
            <div class="nav-center">
                <ul class="nav navbar-nav">
                    <#-- 1. 首页 -->
                    <li>
                        <a href="/" class="menu_a"><i class="fa fa-home faa-bounce animated-hover"></i> 首页</a>
                    </li>

                    <#-- 2. 动态分类 (包含二级菜单逻辑) -->
                    <@zhydTag method="types">
                        <#if types?? && types?size gt 0>
                            <#list types as item>
                                <#if item.nodes?? && item.nodes?size gt 0>
                                    <li class="dropdown">
                                        <a href="/type/${item.id?c}" class="menu_a">
                                            <i class="${item.icon!} faa-wrench animated-hover"></i> ${item.name!}
                                            <span class="caret dropdown-toggle" data-toggle="dropdown"></span>
                                        </a>
                                        <ul class="dropdown-menu">
                                            <#list item.nodes as node>
                                                <li><a href="/type/${node.id?c}" title="${node.name!}">${node.name!}</a></li>
                                            </#list>
                                        </ul>
                                    </li>
                                <#else>
                                    <li>
                                        <a href="/type/${item.id?c}" class="menu_a">
                                            <i class="${item.icon!} faa-wrench animated-hover"></i> ${item.name!}
                                        </a>
                                    </li>
                                </#if>
                            </#list>
                        </#if>
                    </@zhydTag>

                    <#-- 3. 固定菜单 (关于/友链) -->
                    <li><a href="${config.siteUrl}/about" class="menu_a"><i class="fa fa-leaf faa-pulse animated-hover"></i> 关于</a></li>
                    <li><a href="${config.siteUrl}/links" class="menu_a"><i class="fa fa-link faa-shake animated-hover"></i> 友链</a></li>


                </ul>
            </div>
            <div class="nav-right">
                <ul class="nav navbar-nav">
                    <#-- 4. 用户系统 -->
                    <#if !Session["user"]??>
                    <#-- 未登录 -->
                        <li class="login-btn">
                            <a href="/login" class="menu_a"><i class="fa fa-sign-in"></i> 登录</a>
                        </li>
                    <#else>
                    <#-- 已登录 -->
                        <#assign currentUser = Session["user"]>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <img src="${(currentUser.avatar)!('/assets/img/default-avatar.png')}" class="nav-avatar">
                                <span>${currentUser.username}</span> <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="/user/profile"><i class="fa fa-user"></i> 个人中心</a></li>
                                <li><a href="/logout"><i class="fa fa-sign-out"></i> 退出登录</a></li>
                            </ul>
                        </li>
                    </#if>

                    <#-- 5. 搜索按钮 (PC端) -->
                    <li class="hidden-xs">
                    <span class="main-search-icon" data-toggle="modal" data-target=".nav-search-box">
                        <i class="fa fa-search faa-flash animated-hover"></i>
                    </span>
                    </li>
                </ul>
            </div>

        </div>
    <#-- 阅读进度条 -->
    <div class="header-progress-bar"></div>
</nav>



