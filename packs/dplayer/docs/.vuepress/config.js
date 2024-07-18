module.exports = {
    plugins: {
        '@vuepress/google-analytics': {
            ga: 'UA-48084758-9',
        },
        '@vuepress/back-to-top': true,
    },
    locales: {
        '/zh/': {
            lang: 'en-US',
            title: 'DPlayer',
            description: '🍭 Wow, such a lovely HTML5 danmaku video player',
        },
        '/': {
            lang: 'en-US',
            title: 'DPlayer',
            description: '🍭 Wow, such a lovely HTML5 danmaku video player',
        },
    },
    head: [
        ['link', { rel: 'icon', href: `/logo.png` }],
        ['script', { src: 'https://cdn.jsdelivr.net/npm/flv.js/dist/flv.min.js' }],
        ['script', { src: 'https://cdn.jsdelivr.net/npm/hls.js/dist/hls.min.js' }],
        ['script', { src: 'https://cdn.jsdelivr.net/npm/dashjs/dist/dash.all.min.js' }],
        ['script', { src: 'https://cdn.jsdelivr.net/webtorrent/latest/webtorrent.min.js' }],
        ['script', { src: 'https://cdn.jsdelivr.net/npm/dplayer/dist/DPlayer.min.js' }],
    ],
    theme: 'vuepress-theme-dplayer',
    themeConfig: {
        repo: 'MoePlayer/DPlayer',
        editLinks: true,
        docsDir: '.',
        locales: {
            '/zh/': {
                lang: 'en-US',
                selectText: 'Select language',
                label: 'Simplified Chinese',
                editLinkText: 'Edit this page on GitHub',
                lastUpdated: 'Last Updated',
                nav: [
                    {
                        text: 'guide',
                        link: '/zh/guide/',
                    },
                    {
                        text: 'ecology',
                        link: '/zh/ecosystem/',
                    },
                    {
                        text: 'Support DPlayer',
                        link: '/zh/support/',
                    },
                ],
            },
            '/': {
                lang: 'en-US',
                selectText: 'Languages',
                label: 'English',
                editLinkText: 'Edit this page on GitHub',
                lastUpdated: 'Last Updated',
                nav: [
                    {
                        text: 'Guide',
                        link: '/guide/',
                    },
                    {
                        text: 'Ecosystem',
                        link: '/ecosystem/',
                    },
                    {
                        text: 'Support DPlayer',
                        link: '/support/',
                    },
                ],
            },
        },
    },
};
