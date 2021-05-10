const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
      $: 'jquery/src/jquery',
      jQuery: 'jquery/src/jquery'
    })
)

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-2, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1,
    sourceMap: true
  }
});

module.exports = environment
