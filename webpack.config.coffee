path = require 'path'

module.exports =
  mode: 'development'
  entry: './src/index.coffee'
  output:
    path: outputDir = path.resolve __dirname, 'dist/staff'
  module:
    rules: [
      test: /\.coffee$/
      loader: 'coffee-loader'
      options:
        bare: false
        transpile:
          plugins: [
            ['@babel/plugin-transform-react-jsx'
             useBuiltIns: true
             pragma: 'preact.h'
             pragmaFrag: 'preact.Fragment'
             throwIfNamespace: false
            ]
          ]
    ,
      test: /\.pug$/
      loader: 'pug-loader'
    ]
  plugins: [
    new (require 'html-webpack-plugin')
      template: './src/index.pug'
      #inject: 'head'
    new (require 'copy-webpack-plugin')
      patterns: [
        from: 'server'
      ]
    new (require 'webpack-permissions-plugin')
      buildFiles: [
        path: "#{outputDir}/db.cgi"
        fileMode: 0o755
      ]
  ]
