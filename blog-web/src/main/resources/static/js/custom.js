$(function () {
    var header = $('.site-header');
    if (!header.length) return;

    var isHome = location.pathname === '/' || location.pathname === '/index';

    /* ========= 非首页：导航永远显示 ========= */
    if (!isHome) {
        header.addClass('nav-fixed').css({
            opacity: 1,
            transform: 'translateY(0)',
            pointerEvents: 'auto'
        });
    }

    /* ========= 滚动事件（首页 + 非首页都会走） ========= */
    $(window).on('scroll', function () {
        var scrollPos = $(this).scrollTop();

        /* 首页：控制导航显示 / 隐藏 */
        if (isHome) {
            if (scrollPos > 50) {
                header.addClass('nav-fixed');
            } else {
                header.removeClass('nav-fixed');
            }
        }

        /* 阅读进度条（所有页面） */
        var docHeight = $(document).height() - $(window).height();
        var progress = docHeight > 0 ? (scrollPos / docHeight) * 100 : 0;
        $('.header-progress-bar').css('width', progress + '%');
    });

    $(window).trigger('scroll');



});

$(function () {
    const $hero = $('.hero-bg');
    const $bgImg = $hero.find('img');

    const bgList = [
        $hero.data('bg1'),
        $hero.data('bg2'),
        $hero.data('bg3')
    ];

    let bgIndex = 0;

    $('.bg-next').on('click', function () {
        bgIndex = (bgIndex + 1) % bgList.length;
        $bgImg.attr('src', bgList[bgIndex]);
    });

    $('.bg-pre').on('click', function () {
        bgIndex = (bgIndex - 1 + bgList.length) % bgList.length;
        $bgImg.attr('src', bgList[bgIndex]);
    });
});
function subscribe(authorId) {
    let btn = document.getElementById('follow-btn');
    let followed = btn.dataset.followed === '1';

    let url = followed ? '/follow/remove' : '/follow/add';

    $.post(url, { authorId: authorId })
        .done(function () {
            if (followed) {
                btn.innerText = '关注';
                btn.dataset.followed = '0';
            } else {
                btn.innerText = '已关注';
                btn.dataset.followed = '1';
            }
        })
        .fail(function () {
            alert('请先登录');
        });
    location.reload()
}