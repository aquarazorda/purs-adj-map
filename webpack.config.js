'use strict';

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');
const ModuleFederationPlugin = require("webpack/lib/container/ModuleFederationPlugin");
const isWebpackDevServer = process.argv.some(a => path.basename(a) === 'webpack-dev-server');
const isWatch = process.argv.some(a => a === '--watch');

const plugins =
  isWebpackDevServer || !isWatch ? [] : [
    function () {
      this.plugin('done', function (stats) {
        process.stderr.write(stats.toString('errors-only'));
      });
    }
  ]
  ;

module.exports = {
  // devtool: 'eval-source-map',
  optimization: {
    // We no not want to minimize our code.
    minimize: false
  },

  devServer: {
    historyApiFallback: true,
    contentBase: path.resolve(__dirname, 'dist'),
    hot: true,
  },

  entry: './src/index.js',

  output: {
    uniqueName: 'purs',
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    // publicPath: 'http://localhost:8080/'
    publicPath: './purs/'
  },

  module: {
    rules: [
      {
        test: /\.purs$/,
        use: [
          {
            loader: 'purs-loader',
            options: {
              src: [
                'src/**/*.purs'
              ],
              spago: true,
              watch: isWebpackDevServer || isWatch,
              pscIde: true
            }
          }
        ]
      },
      // {
      //   test: /\.(png|jpg|gif)$/i,
      //   use: [
      //     {
      //       loader: 'url-loader',
      //       options: {
      //         limit: 8192,
      //       },
      //     },
      //   ],
      // },
    ]
  },

  resolve: {
    // modules: [ 'node_modules' ],
    extensions: ['.purs', '.js']
  },

  plugins: [
    // new webpack.LoaderOptionsPlugin({
    //   debug: true
    // }),
    // new HtmlWebpackPlugin({
    //   title: 'purescript-webpack-example',
    //   template: 'index.html',
    //   inject: false  // See stackoverflow.com/a/38292765/3067181
    // }),
    new ModuleFederationPlugin({
      name: "purs",
      filename: "remoteEntry.js",
      exposes: {
        "./Main": "./src/Main.purs"
      }
    })
  ]
};