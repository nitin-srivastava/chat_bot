// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            jquery: 'jquery',
            'window.jQuery': 'jquery',
            Popper: ['popper.js', 'default'],
    })
)
const config = environment.toWebpackConfig();
config.resolve.alias = {
    jquery: 'jquery/src/jquery'
};

environment.config.merge({
    output: {
        library: ['Packs', '[scrollToTheLastItem]'],
        libraryTarget: 'var'
    },
})

module.exports = environment